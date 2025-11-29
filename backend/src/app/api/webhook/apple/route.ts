/**
 * Apple App Store Server Notifications V2 Webhook
 * https://developer.apple.com/documentation/appstoreservernotifications
 *
 * Apple側での設定:
 * App Store Connect > アプリ > App情報 > App Store Server Notifications
 * - Production Server URL: https://your-domain.com/api/webhook/apple
 * - Sandbox Server URL: https://your-domain.com/api/webhook/apple
 * - Version: Version 2
 */

import { NextRequest, NextResponse } from "next/server";
import { decodeJwt } from "jose";
import prisma from "@/lib/prisma";
import {
  findUserByOriginalTransactionId,
  downgradeUserSubscription,
} from "@/lib/subscription";

// Apple Server Notifications V2 の通知タイプ
// https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
type AppleNotificationType =
  | "CONSUMPTION_REQUEST"
  | "DID_CHANGE_RENEWAL_PREF"
  | "DID_CHANGE_RENEWAL_STATUS"
  | "DID_FAIL_TO_RENEW"
  | "DID_RENEW"
  | "EXPIRED"
  | "GRACE_PERIOD_EXPIRED"
  | "OFFER_REDEEMED"
  | "PRICE_INCREASE"
  | "REFUND"
  | "REFUND_DECLINED"
  | "REFUND_REVERSED"
  | "RENEWAL_EXTENDED"
  | "RENEWAL_EXTENSION"
  | "REVOKE"
  | "SUBSCRIBED"
  | "TEST";

// サブタイプ
type AppleSubtype =
  | "INITIAL_BUY"
  | "RESUBSCRIBE"
  | "DOWNGRADE"
  | "UPGRADE"
  | "AUTO_RENEW_ENABLED"
  | "AUTO_RENEW_DISABLED"
  | "VOLUNTARY"
  | "BILLING_RETRY"
  | "PRICE_INCREASE"
  | "GRACE_PERIOD"
  | "PENDING"
  | "ACCEPTED"
  | "BILLING_RECOVERY"
  | "PRODUCT_NOT_FOR_SALE"
  | "SUMMARY"
  | "FAILURE";

interface DecodedNotification {
  notificationType: AppleNotificationType;
  subtype?: AppleSubtype;
  data?: {
    signedTransactionInfo?: string;
    signedRenewalInfo?: string;
  };
}

interface TransactionInfo {
  originalTransactionId?: string;
  transactionId?: string;
  productId?: string;
  expiresDate?: number;
  bundleId?: string;
}

interface RenewalInfo {
  autoRenewStatus?: number; // 1 = ON, 0 = OFF
  autoRenewProductId?: string;
  expirationIntent?: number;
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { signedPayload } = body;

    if (!signedPayload || typeof signedPayload !== "string") {
      console.error("[webhook/apple] Missing signedPayload");
      return NextResponse.json({ error: "Missing signedPayload" }, { status: 400 });
    }

    // JWSをデコード（本番環境ではAppleの証明書で署名検証を行うべき）
    let notification: DecodedNotification;
    try {
      notification = decodeJwt(signedPayload) as unknown as DecodedNotification;
    } catch (e) {
      console.error("[webhook/apple] Failed to decode JWS", e);
      return NextResponse.json({ error: "Invalid JWS" }, { status: 400 });
    }

    console.log("[webhook/apple] Received notification", {
      type: notification.notificationType,
      subtype: notification.subtype,
    });

    // トランザクション情報をデコード
    let transactionInfo: TransactionInfo | null = null;
    let renewalInfo: RenewalInfo | null = null;

    if (notification.data?.signedTransactionInfo) {
      try {
        transactionInfo = decodeJwt(notification.data.signedTransactionInfo) as unknown as TransactionInfo;
      } catch (e) {
        console.error("[webhook/apple] Failed to decode transaction info", e);
      }
    }

    if (notification.data?.signedRenewalInfo) {
      try {
        renewalInfo = decodeJwt(notification.data.signedRenewalInfo) as unknown as RenewalInfo;
      } catch (e) {
        console.error("[webhook/apple] Failed to decode renewal info", e);
      }
    }

    const originalTransactionId = transactionInfo?.originalTransactionId;
    if (!originalTransactionId) {
      console.warn("[webhook/apple] No originalTransactionId found");
      return NextResponse.json({ received: true });
    }

    // ユーザーを検索
    const user = await findUserByOriginalTransactionId(originalTransactionId);
    if (!user) {
      console.warn(`[webhook/apple] User not found for originalTransactionId: ${originalTransactionId}`);
      return NextResponse.json({ received: true });
    }

    // 通知タイプに応じて処理
    switch (notification.notificationType) {
      case "DID_RENEW":
        // 自動更新成功
        console.log(`[webhook/apple] Subscription renewed for user ${user.id}`);
        if (transactionInfo?.expiresDate) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              subscriptionExpiresAt: new Date(transactionInfo.expiresDate),
              subscriptionAutoRenewing: true,
            },
          });
        }
        break;

      case "DID_CHANGE_RENEWAL_STATUS":
        // 自動更新のON/OFF切り替え
        const autoRenewing = renewalInfo?.autoRenewStatus === 1;
        console.log(`[webhook/apple] Auto-renew status changed for user ${user.id}: ${autoRenewing}`);
        await prisma.user.update({
          where: { id: user.id },
          data: { subscriptionAutoRenewing: autoRenewing },
        });
        // 注意: キャンセルしても現在の期限まではPREMIUM維持
        break;

      case "EXPIRED":
        // サブスクリプション期限切れ
        console.log(`[webhook/apple] Subscription expired for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case "DID_FAIL_TO_RENEW":
        // 更新失敗（支払い問題）
        console.log(`[webhook/apple] Renewal failed for user ${user.id}, subtype: ${notification.subtype}`);
        // GRACE_PERIOD中は猶予があるので、EXPIREDを待つ
        if (notification.subtype !== "GRACE_PERIOD") {
          // 猶予期間外の場合は自動更新をOFFに
          await prisma.user.update({
            where: { id: user.id },
            data: { subscriptionAutoRenewing: false },
          });
        }
        break;

      case "GRACE_PERIOD_EXPIRED":
        // 猶予期間終了
        console.log(`[webhook/apple] Grace period expired for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case "REFUND":
        // 返金
        console.log(`[webhook/apple] Refund processed for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case "REVOKE":
        // 家族共有の取り消しなど
        console.log(`[webhook/apple] Access revoked for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case "SUBSCRIBED":
        // 新規購入または再購読
        console.log(`[webhook/apple] New subscription for user ${user.id}, subtype: ${notification.subtype}`);
        if (transactionInfo?.expiresDate) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              type: user.type === "OFFICIAL" ? "OFFICIAL" : "PREMIUM",
              subscriptionExpiresAt: new Date(transactionInfo.expiresDate),
              subscriptionAutoRenewing: true,
            },
          });
        }
        break;

      case "RENEWAL_EXTENDED":
      case "RENEWAL_EXTENSION":
        // 更新期間延長
        console.log(`[webhook/apple] Renewal extended for user ${user.id}`);
        if (transactionInfo?.expiresDate) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              subscriptionExpiresAt: new Date(transactionInfo.expiresDate),
            },
          });
        }
        break;

      case "TEST":
        // テスト通知
        console.log("[webhook/apple] Test notification received");
        break;

      default:
        console.log(`[webhook/apple] Unhandled notification type: ${notification.notificationType}`);
    }

    return NextResponse.json({ received: true });
  } catch (error) {
    console.error("[webhook/apple] Error processing webhook", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
