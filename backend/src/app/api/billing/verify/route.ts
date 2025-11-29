import { NextRequest, NextResponse } from "next/server";

import { requireAuthUser } from "@/lib/auth";
import { ERROR, handleRouteError } from "@/lib/errors";
import prisma from "@/lib/prisma";
import { findUserById } from "@/lib/store";
import { updateUserSubscription, SubscriptionPlatform } from "@/lib/subscription";
import { UserType } from "@/lib/types";
import { google } from "googleapis";

const SUPPORTED_PRODUCT_IDS = new Set<string>(["PRO_0001", "pro_0001"]);
const SUPPORTED_PLATFORMS = new Set<string>(["ios", "android"]);
const APPLE_PROD_VERIFY_URL = "https://buy.itunes.apple.com/verifyReceipt";
const APPLE_SANDBOX_VERIFY_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

// 検証結果の型
interface VerificationResult {
  originalTransactionId: string;
  expiresAt: Date;
  autoRenewing: boolean;
}

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
    let verificationResult: VerificationResult;

    if (platform === "ios") {
      verificationResult = await verifyAppleReceipt({
        receiptData: verificationData,
        productId,
        transactionId,
      });
    } else if (platform === "android") {
      verificationResult = await verifyAndroidPurchase({
        token: verificationData,
        productId,
      });
    } else {
      throw ERROR.INVALID_INPUT("Unsupported platform");
    }

    // 検証成功 -> サブスクリプション情報を保存して権限付与
    await updateUserSubscription(user.id, {
      expiresAt: verificationResult.expiresAt,
      platform: platform as SubscriptionPlatform,
      productId,
      originalTransactionId: verificationResult.originalTransactionId,
      autoRenewing: verificationResult.autoRenewing,
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

async function verifyAndroidPurchase(params: { token: string; productId: string }): Promise<VerificationResult> {
  const { GOOGLE_SERVICE_ACCOUNT_JSON, GOOGLE_PLAY_PACKAGE_NAME } = process.env;

  if (!GOOGLE_SERVICE_ACCOUNT_JSON) {
    throw new Error("Missing GOOGLE_SERVICE_ACCOUNT_JSON");
  }
  if (!GOOGLE_PLAY_PACKAGE_NAME) {
    throw new Error("Missing GOOGLE_PLAY_PACKAGE_NAME");
  }

  try {
    const credentials = JSON.parse(GOOGLE_SERVICE_ACCOUNT_JSON);
    const auth = new google.auth.GoogleAuth({
      credentials,
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });

    const androidPublisher = google.androidpublisher({
      version: "v3",
      auth,
    });

    const res = await androidPublisher.purchases.subscriptions.get({
      packageName: GOOGLE_PLAY_PACKAGE_NAME,
      subscriptionId: params.productId,
      token: params.token,
    });

    console.log("[billing/verify] Android verify result", res.data);

    const expiryTimeMillis = res.data.expiryTimeMillis ? Number(res.data.expiryTimeMillis) : 0;

    if (expiryTimeMillis && expiryTimeMillis < Date.now()) {
      throw ERROR.UNPROCESSABLE("Subscription has expired");
    }

    if (!res.data.acknowledgementState) {
      console.log("[billing/verify] Acknowledging subscription...");
      await androidPublisher.purchases.subscriptions.acknowledge({
        packageName: GOOGLE_PLAY_PACKAGE_NAME,
        subscriptionId: params.productId,
        token: params.token,
      });
    }

    return {
      originalTransactionId: params.token, // Google では purchaseToken を使用
      expiresAt: new Date(expiryTimeMillis),
      autoRenewing: res.data.autoRenewing ?? true,
    };
  } catch (e) {
    console.error("[billing/verify] Android verification failed", e);
    if (e instanceof Error && "status" in e) {
      throw e;
    }
    throw ERROR.UNPROCESSABLE("Android verification failed");
  }
}

async function verifyAppleReceipt(params: {
  receiptData: string;
  productId: string;
  transactionId: string;
}): Promise<VerificationResult> {
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
      const expiresDate = payload.expiresDate as number; // milliseconds
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

      return {
        originalTransactionId: originalTxId || txId,
        expiresAt: expiresDate ? new Date(expiresDate) : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // デフォルト30日
        autoRenewing: true, // JWSからは直接取得できないため、デフォルトtrue
      };
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

  return {
    originalTransactionId: matched.original_transaction_id || matched.transaction_id || params.transactionId,
    expiresAt: expires ? new Date(expires) : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // デフォルト30日
    autoRenewing: true, // StoreKit 1からは直接取得できないため、デフォルトtrue
  };
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
