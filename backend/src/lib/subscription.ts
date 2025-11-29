/**
 * サブスクリプション管理サービス
 * Apple/Googleへの再検証と、ユーザーステータス更新を担当
 */

import { decodeJwt } from "jose";
import { google } from "googleapis";
import prisma from "@/lib/prisma";
import { UserType } from "@/lib/types";

export type SubscriptionPlatform = "ios" | "android";

export interface SubscriptionStatus {
  isActive: boolean;
  expiresAt: Date | null;
  autoRenewing: boolean;
  productId?: string;
}

export interface SubscriptionVerificationResult {
  isActive: boolean;
  expiresAt: Date | null;
  autoRenewing: boolean;
  originalTransactionId: string;
  productId: string;
}

const APPLE_PROD_VERIFY_URL = "https://buy.itunes.apple.com/verifyReceipt";
const APPLE_SANDBOX_VERIFY_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

/**
 * Apple App Store Connect API を使用してサブスクリプション状態を取得
 */
export async function verifyAppleSubscriptionStatus(
  originalTransactionId: string
): Promise<SubscriptionStatus> {
  const {
    APPLE_API_KEY_ID,
    APPLE_API_ISSUER_ID,
    APPLE_API_PRIVATE_KEY,
    APP_STORE_BUNDLE_ID,
  } = process.env;

  // App Store Server API を使用（推奨）
  if (APPLE_API_KEY_ID && APPLE_API_ISSUER_ID && APPLE_API_PRIVATE_KEY) {
    try {
      const token = await generateAppleJWT();
      const response = await fetch(
        `https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/${originalTransactionId}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (!response.ok) {
        // Sandbox環境でも試す
        const sandboxResponse = await fetch(
          `https://api.storekit-sandbox.itunes.apple.com/inApps/v1/subscriptions/${originalTransactionId}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        if (!sandboxResponse.ok) {
          console.error("[subscription] Apple API failed", {
            status: response.status,
            sandboxStatus: sandboxResponse.status,
          });
          return { isActive: false, expiresAt: null, autoRenewing: false };
        }

        return parseAppleSubscriptionResponse(await sandboxResponse.json());
      }

      return parseAppleSubscriptionResponse(await response.json());
    } catch (error) {
      console.error("[subscription] Apple verification error", error);
      return { isActive: false, expiresAt: null, autoRenewing: false };
    }
  }

  // フォールバック: レシート検証（APPLE_SHARED_SECRET必要）
  console.warn("[subscription] Apple API credentials not configured, cannot verify");
  return { isActive: false, expiresAt: null, autoRenewing: false };
}

function parseAppleSubscriptionResponse(data: unknown): SubscriptionStatus {
  const response = data as {
    data?: Array<{
      lastTransactions?: Array<{
        signedTransactionInfo?: string;
        signedRenewalInfo?: string;
      }>;
    }>;
  };

  if (!response.data || response.data.length === 0) {
    return { isActive: false, expiresAt: null, autoRenewing: false };
  }

  // 最新のトランザクションを取得
  const subscriptionGroup = response.data[0];
  const lastTransaction = subscriptionGroup.lastTransactions?.[0];

  if (!lastTransaction?.signedTransactionInfo) {
    return { isActive: false, expiresAt: null, autoRenewing: false };
  }

  try {
    const transactionInfo = decodeJwt(lastTransaction.signedTransactionInfo);
    const renewalInfo = lastTransaction.signedRenewalInfo
      ? decodeJwt(lastTransaction.signedRenewalInfo)
      : null;

    const expiresDate = transactionInfo.expiresDate as number | undefined;
    const expiresAt = expiresDate ? new Date(expiresDate) : null;
    const isActive = expiresAt ? expiresAt > new Date() : false;

    // autoRenewStatus: 1 = 自動更新ON, 0 = OFF
    const autoRenewing = renewalInfo?.autoRenewStatus === 1;

    return {
      isActive,
      expiresAt,
      autoRenewing,
      productId: transactionInfo.productId as string | undefined,
    };
  } catch (error) {
    console.error("[subscription] Failed to parse Apple response", error);
    return { isActive: false, expiresAt: null, autoRenewing: false };
  }
}

async function generateAppleJWT(): Promise<string> {
  const {
    APPLE_API_KEY_ID,
    APPLE_API_ISSUER_ID,
    APPLE_API_PRIVATE_KEY,
  } = process.env;

  if (!APPLE_API_KEY_ID || !APPLE_API_ISSUER_ID || !APPLE_API_PRIVATE_KEY) {
    throw new Error("Missing Apple API credentials");
  }

  // jose を使用してJWTを生成
  const { SignJWT, importPKCS8 } = await import("jose");

  const privateKey = await importPKCS8(
    APPLE_API_PRIVATE_KEY.replace(/\\n/g, "\n"),
    "ES256"
  );

  const jwt = await new SignJWT({})
    .setProtectedHeader({ alg: "ES256", kid: APPLE_API_KEY_ID, typ: "JWT" })
    .setIssuer(APPLE_API_ISSUER_ID)
    .setIssuedAt()
    .setExpirationTime("1h")
    .setAudience("appstoreconnect-v1")
    .sign(privateKey);

  return jwt;
}

/**
 * Google Play Developer API を使用してサブスクリプション状態を取得
 */
export async function verifyGoogleSubscriptionStatus(
  purchaseToken: string,
  productId: string
): Promise<SubscriptionStatus> {
  const { GOOGLE_SERVICE_ACCOUNT_JSON, GOOGLE_PLAY_PACKAGE_NAME } = process.env;

  if (!GOOGLE_SERVICE_ACCOUNT_JSON || !GOOGLE_PLAY_PACKAGE_NAME) {
    console.error("[subscription] Missing Google credentials");
    return { isActive: false, expiresAt: null, autoRenewing: false };
  }

  try {
    const credentials = JSON.parse(GOOGLE_SERVICE_ACCOUNT_JSON);
    const auth = new google.auth.GoogleAuth({
      credentials,
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });

    const androidPublisher = google.androidpublisher({ version: "v3", auth });

    const response = await androidPublisher.purchases.subscriptions.get({
      packageName: GOOGLE_PLAY_PACKAGE_NAME,
      subscriptionId: productId,
      token: purchaseToken,
    });

    const { expiryTimeMillis, autoRenewing, cancelReason } = response.data;

    const expiresAt = expiryTimeMillis
      ? new Date(Number(expiryTimeMillis))
      : null;
    const isActive = expiresAt ? expiresAt > new Date() : false;

    return {
      isActive,
      expiresAt,
      autoRenewing: autoRenewing ?? false,
      productId,
    };
  } catch (error) {
    console.error("[subscription] Google verification error", error);
    return { isActive: false, expiresAt: null, autoRenewing: false };
  }
}

/**
 * プラットフォームに応じてサブスクリプション状態を検証
 */
export async function verifySubscriptionStatus(
  platform: SubscriptionPlatform,
  originalTransactionId: string,
  productId?: string
): Promise<SubscriptionStatus> {
  if (platform === "ios") {
    return verifyAppleSubscriptionStatus(originalTransactionId);
  } else if (platform === "android") {
    if (!productId) {
      console.error("[subscription] productId required for Android");
      return { isActive: false, expiresAt: null, autoRenewing: false };
    }
    return verifyGoogleSubscriptionStatus(originalTransactionId, productId);
  }

  return { isActive: false, expiresAt: null, autoRenewing: false };
}

/**
 * ユーザーのサブスクリプション情報を更新
 */
export async function updateUserSubscription(
  userId: string,
  params: {
    expiresAt: Date;
    platform: SubscriptionPlatform;
    productId: string;
    originalTransactionId: string;
    autoRenewing?: boolean;
  }
) {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    throw new Error("User not found");
  }

  // OFFICIALユーザーはタイプを変更しない
  const targetType: UserType = user.type === "OFFICIAL" ? "OFFICIAL" : "PREMIUM";

  return prisma.user.update({
    where: { id: userId },
    data: {
      type: targetType,
      subscriptionExpiresAt: params.expiresAt,
      subscriptionPlatform: params.platform,
      subscriptionProductId: params.productId,
      originalTransactionId: params.originalTransactionId,
      subscriptionAutoRenewing: params.autoRenewing ?? true,
    },
  });
}

/**
 * ユーザーをNORMALにダウングレード
 */
export async function downgradeUserSubscription(userId: string) {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    return null;
  }

  // OFFICIALユーザーはダウングレードしない
  if (user.type === "OFFICIAL") {
    return user;
  }

  return prisma.user.update({
    where: { id: userId },
    data: {
      type: "NORMAL",
      subscriptionExpiresAt: null,
      subscriptionAutoRenewing: false,
    },
  });
}

/**
 * originalTransactionIdでユーザーを検索
 */
export async function findUserByOriginalTransactionId(
  originalTransactionId: string
) {
  return prisma.user.findFirst({
    where: { originalTransactionId },
  });
}

/**
 * 期限切れのPREMIUMユーザーを取得
 */
export async function getExpiredPremiumUsers() {
  return prisma.user.findMany({
    where: {
      type: "PREMIUM",
      subscriptionExpiresAt: {
        lt: new Date(),
      },
    },
  });
}

/**
 * 期限切れユーザーを再検証し、必要に応じてダウングレード
 * @returns 処理結果のサマリー
 */
export async function processExpiredSubscriptions(): Promise<{
  checked: number;
  renewed: number;
  downgraded: number;
  errors: number;
}> {
  const expiredUsers = await getExpiredPremiumUsers();
  const results = {
    checked: expiredUsers.length,
    renewed: 0,
    downgraded: 0,
    errors: 0,
  };

  for (const user of expiredUsers) {
    if (!user.subscriptionPlatform || !user.originalTransactionId) {
      // サブスクリプション情報がない場合はダウングレード
      console.log(`[subscription] User ${user.id} has no subscription info, downgrading`);
      await downgradeUserSubscription(user.id);
      results.downgraded++;
      continue;
    }

    try {
      const status = await verifySubscriptionStatus(
        user.subscriptionPlatform as SubscriptionPlatform,
        user.originalTransactionId,
        user.subscriptionProductId ?? undefined
      );

      if (status.isActive && status.expiresAt) {
        // 自動更新されていた → 新しい期限を保存
        console.log(`[subscription] User ${user.id} subscription renewed until ${status.expiresAt}`);
        await prisma.user.update({
          where: { id: user.id },
          data: {
            subscriptionExpiresAt: status.expiresAt,
            subscriptionAutoRenewing: status.autoRenewing,
          },
        });
        results.renewed++;
      } else {
        // 本当に期限切れ → NORMALに戻す
        console.log(`[subscription] User ${user.id} subscription expired, downgrading`);
        await downgradeUserSubscription(user.id);
        results.downgraded++;
      }
    } catch (error) {
      console.error(`[subscription] Error processing user ${user.id}`, error);
      results.errors++;
    }
  }

  return results;
}
