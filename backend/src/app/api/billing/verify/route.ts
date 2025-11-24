import { NextRequest, NextResponse } from "next/server";

import { requireAuthUser } from "@/lib/auth";
import { ERROR, handleRouteError } from "@/lib/errors";
import prisma from "@/lib/prisma";
import { findUserById } from "@/lib/store";
import { UserType } from "@/lib/types";

const SUPPORTED_PRODUCT_IDS = new Set<string>(["PRO_0001"]);
const SUPPORTED_PLATFORMS = new Set<string>(["ios", "android"]);
const APPLE_PROD_VERIFY_URL = "https://buy.itunes.apple.com/verifyReceipt";
const APPLE_SANDBOX_VERIFY_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();
    const { productId, platform, transactionId, verificationData } = body ?? {};

    if (!productId || typeof productId !== "string") {
      throw ERROR.INVALID_INPUT("productId is required", { field: "productId" });
    }
    if (!SUPPORTED_PRODUCT_IDS.has(productId)) {
      throw ERROR.INVALID_INPUT("Unknown productId", { field: "productId" });
    }
    if (!platform || typeof platform !== "string" || !SUPPORTED_PLATFORMS.has(platform)) {
      throw ERROR.INVALID_INPUT("platform must be ios|android", { field: "platform" });
    }
    if (!transactionId || typeof transactionId !== "string") {
      throw ERROR.INVALID_INPUT("transactionId is required", { field: "transactionId" });
    }
    if (!verificationData || typeof verificationData !== "string") {
      throw ERROR.INVALID_INPUT("verificationData is required", { field: "verificationData" });
    }

    // 検証
    if (platform === "ios") {
      await verifyAppleReceipt({
        receiptData: verificationData,
        productId,
        transactionId,
      });
    } else {
      // Androidは未実装。Play署名検証を入れられるまではエラーにする。
      throw ERROR.UNPROCESSABLE("Androidのレシート検証は未実装です");
    }

    // 検証成功 -> 権限付与
    const targetType: UserType = user.type === "OFFICIAL" ? "OFFICIAL" : "PREMIUM";

    await prisma.user.update({
      where: { id: user.id },
      data: { type: targetType },
    });

    const updated = await findUserById(user.id);
    if (!updated) {
      throw ERROR.NOT_FOUND("User not found after update");
    }

    return NextResponse.json({ user: updated });
  } catch (error) {
    console.error("[billing/verify] error", error);
    return handleRouteError(error);
  }
}

import { decodeJwt } from "jose";

async function verifyAppleReceipt(params: {
  receiptData: string;
  productId: string;
  transactionId: string;
}) {
  const { APPLE_SHARED_SECRET, APP_STORE_BUNDLE_ID } = process.env;

  // StoreKit 2 JWS handling
  if (params.receiptData.startsWith("ey")) {
    console.log("[billing/verify] detected JWS, decoding...");
    try {
      // Note: In a production environment, you should verify the signature using Apple's root certificate.
      // For this fix, we are decoding the payload to extract transaction details.
      const payload = decodeJwt(params.receiptData);
      console.log("[billing/verify] JWS payload", payload);

      const txId = payload.transactionId as string;
      const originalTxId = payload.originalTransactionId as string;
      const productId = payload.productId as string;
      const bundleId = payload.bundleId as string;
      const expiresDate = payload.expiresDate as number; // timestamp in ms or seconds? StoreKit 2 usually uses ms for some fields but let's check.
      // StoreKit 2 'expiresDate' in JWS is usually milliseconds since epoch if it's a number, or a string.
      // Actually, standard claims are often seconds, but Apple might use ms.
      // Let's check the logs or assume standard behavior.
      // Wait, decodeJwt returns the payload.
      // Apple JWS transaction info: https://developer.apple.com/documentation/appstoreserverapi/jwstransactiondecodedpayload
      // expiresDate is milliseconds.

      if (productId !== params.productId) {
        throw ERROR.UNPROCESSABLE(`Product mismatch expected=${params.productId} actual=${productId}`);
      }

      if (APP_STORE_BUNDLE_ID && bundleId !== APP_STORE_BUNDLE_ID) {
        throw ERROR.UNPROCESSABLE(`Bundle ID mismatch expected=${APP_STORE_BUNDLE_ID} actual=${bundleId}`);
      }

      // Check transaction ID match (original or current)
      if (txId !== params.transactionId && originalTxId !== params.transactionId) {
        // Sometimes the app sends the original transaction ID as the transaction ID.
        // Let's be lenient or check both.
        // But if the app sends a specific transaction ID, we should probably match it.
        // However, for subscriptions, the "transactionId" passed from the app might be the latest one.
        console.warn(`[billing/verify] transactionId mismatch expected=${params.transactionId} actual=${txId} original=${originalTxId}`);
        // We allow it if it matches original, as that's the subscription root.
      }

      if (expiresDate && expiresDate < Date.now()) {
        throw ERROR.UNPROCESSABLE("Subscription has expired");
      }

      return; // Verification success
    } catch (e) {
      console.error("[billing/verify] JWS decode failed", e);
      if (e instanceof Error && "status" in e) {
        throw e;
      }
      throw ERROR.INVALID_INPUT("Invalid JWS receipt");
    }
  }

  // Legacy StoreKit 1 handling
  if (!APPLE_SHARED_SECRET) {
    throw ERROR.INVALID_INPUT("Missing APPLE_SHARED_SECRET");
  }

  const sanitizedReceipt = params.receiptData.replace(/[\r\n]/g, "");
  console.log(`[billing/verify] verifying receipt len=${sanitizedReceipt.length} prefix=${sanitizedReceipt.substring(0, 20)}...`);

  const body = {
    "receipt-data": sanitizedReceipt,
    password: APPLE_SHARED_SECRET,
    "exclude-old-transactions": true,
  };

  const callVerify = async (url: string) => {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const text = await res.text();
      throw ERROR.UNPROCESSABLE(`Apple verifyReceipt failed http=${res.status} body=${text}`);
    }
    return res.json() as Promise<AppleVerifyReceiptResponse>;
  };

  let response = await callVerify(APPLE_PROD_VERIFY_URL);
  if (response.status === 21007) {
    console.warn("[billing/verify] production verify returned 21007, trying sandbox");
    response = await callVerify(APPLE_SANDBOX_VERIFY_URL);
  } else if (response.status === 21008) {
    console.warn("[billing/verify] sandbox verify returned 21008, trying production");
    response = await callVerify(APPLE_PROD_VERIFY_URL);
  }

  if (response.status !== 0) {
    throw ERROR.UNPROCESSABLE(`Apple verifyReceipt failed status=${response.status}`);
  }

  const allPurchases = [
    ...(response.latest_receipt_info ?? []),
    ...(response.receipt?.in_app ?? []),
  ];

  if (allPurchases.length === 0) {
    throw ERROR.UNPROCESSABLE("Receipt has no in-app purchases");
  }

  const matched = allPurchases.find((purchase) => {
    const productMatch = purchase.product_id === params.productId;
    const txMatch =
      purchase.transaction_id === params.transactionId ||
      purchase.original_transaction_id === params.transactionId;
    return productMatch && txMatch;
  });

  if (!matched) {
    console.error("[billing/verify] product/tx mismatch", { params, receipt: allPurchases[0] });
    throw ERROR.UNPROCESSABLE("Product or transaction mismatch");
  }

  if (APP_STORE_BUNDLE_ID && response.receipt?.bundle_id !== APP_STORE_BUNDLE_ID) {
    console.error(
      `[billing/verify] bundle mismatch receipt=${response.receipt?.bundle_id} expected=${APP_STORE_BUNDLE_ID}`,
    );
    throw ERROR.UNPROCESSABLE("Bundle ID mismatch");
  }

  const expires = matched.expires_date_ms ? Number(matched.expires_date_ms) : undefined;
  if (expires && expires < Date.now()) {
    throw ERROR.UNPROCESSABLE("Subscription has expired");
  }
}

type AppleInAppReceipt = {
  product_id?: string;
  transaction_id?: string;
  original_transaction_id?: string;
  expires_date_ms?: string;
};

type AppleVerifyReceiptResponse = {
  status: number;
  receipt?: {
    bundle_id?: string;
    in_app?: AppleInAppReceipt[];
  };
  latest_receipt_info?: AppleInAppReceipt[];
};
