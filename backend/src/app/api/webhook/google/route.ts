/**
 * Google Play Real-time Developer Notifications Webhook
 * https://developer.android.com/google/play/billing/rtdn-reference
 *
 * Google Play Console での設定:
 * 1. Cloud Pub/Sub トピックを作成
 * 2. Push サブスクリプションを作成し、このエンドポイントを設定
 * 3. Play Console > アプリ > 収益化 > 収益化の設定 > Real-time developer notifications
 *    でトピックを設定
 *
 * エンドポイント URL: https://your-domain.com/api/webhook/google
 */

import { NextRequest, NextResponse } from "next/server";
import { google } from "googleapis";
import prisma from "@/lib/prisma";
import {
  findUserByOriginalTransactionId,
  downgradeUserSubscription,
  verifyGoogleSubscriptionStatus,
} from "@/lib/subscription";

// Google Play Real-time Developer Notifications のタイプ
// https://developer.android.com/google/play/billing/rtdn-reference#sub
enum SubscriptionNotificationType {
  SUBSCRIPTION_RECOVERED = 1,      // 一時停止からの復帰
  SUBSCRIPTION_RENEWED = 2,        // 更新成功
  SUBSCRIPTION_CANCELED = 3,       // キャンセル（自発的または支払い失敗）
  SUBSCRIPTION_PURCHASED = 4,      // 新規購入
  SUBSCRIPTION_ON_HOLD = 5,        // 支払い保留（Account Hold）
  SUBSCRIPTION_IN_GRACE_PERIOD = 6, // 猶予期間
  SUBSCRIPTION_RESTARTED = 7,      // 再開
  SUBSCRIPTION_PRICE_CHANGE_CONFIRMED = 8, // 価格変更承認
  SUBSCRIPTION_DEFERRED = 9,       // 延期
  SUBSCRIPTION_PAUSED = 10,        // 一時停止
  SUBSCRIPTION_PAUSE_SCHEDULE_CHANGED = 11, // 一時停止スケジュール変更
  SUBSCRIPTION_REVOKED = 12,       // 取り消し
  SUBSCRIPTION_EXPIRED = 13,       // 期限切れ
  SUBSCRIPTION_PENDING_PURCHASE_CANCELED = 20, // 保留中の購入がキャンセル
}

interface PubSubMessage {
  message: {
    data: string; // Base64エンコードされたJSON
    messageId: string;
    publishTime: string;
  };
  subscription: string;
}

interface DeveloperNotification {
  version: string;
  packageName: string;
  eventTimeMillis: string;
  subscriptionNotification?: {
    version: string;
    notificationType: SubscriptionNotificationType;
    purchaseToken: string;
    subscriptionId: string;
  };
  oneTimeProductNotification?: {
    version: string;
    notificationType: number;
    purchaseToken: string;
    sku: string;
  };
  voidedPurchaseNotification?: {
    purchaseToken: string;
    orderId: string;
    productType: number;
  };
  testNotification?: {
    version: string;
  };
}

export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as PubSubMessage;

    if (!body.message?.data) {
      console.error("[webhook/google] Missing message data");
      return NextResponse.json({ error: "Missing message data" }, { status: 400 });
    }

    // Base64デコード
    let notification: DeveloperNotification;
    try {
      const decoded = Buffer.from(body.message.data, "base64").toString("utf-8");
      notification = JSON.parse(decoded) as DeveloperNotification;
    } catch (e) {
      console.error("[webhook/google] Failed to decode message", e);
      return NextResponse.json({ error: "Invalid message format" }, { status: 400 });
    }

    console.log("[webhook/google] Received notification", {
      packageName: notification.packageName,
      subscriptionNotification: notification.subscriptionNotification,
      testNotification: notification.testNotification,
    });

    // テスト通知の処理
    if (notification.testNotification) {
      console.log("[webhook/google] Test notification received");
      return NextResponse.json({ received: true });
    }

    // サブスクリプション通知の処理
    const subNotification = notification.subscriptionNotification;
    if (!subNotification) {
      console.log("[webhook/google] Not a subscription notification, ignoring");
      return NextResponse.json({ received: true });
    }

    const { purchaseToken, subscriptionId, notificationType } = subNotification;

    // purchaseToken でユーザーを検索
    const user = await findUserByOriginalTransactionId(purchaseToken);
    if (!user) {
      console.warn(`[webhook/google] User not found for purchaseToken: ${purchaseToken.substring(0, 20)}...`);
      return NextResponse.json({ received: true });
    }

    // 通知タイプに応じて処理
    switch (notificationType) {
      case SubscriptionNotificationType.SUBSCRIPTION_RENEWED:
      case SubscriptionNotificationType.SUBSCRIPTION_RECOVERED:
      case SubscriptionNotificationType.SUBSCRIPTION_RESTARTED:
        // 更新成功 / 復帰 / 再開
        console.log(`[webhook/google] Subscription renewed/recovered for user ${user.id}`);
        const renewedStatus = await verifyGoogleSubscriptionStatus(purchaseToken, subscriptionId);
        if (renewedStatus.isActive && renewedStatus.expiresAt) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              type: user.type === "OFFICIAL" ? "OFFICIAL" : "PREMIUM",
              subscriptionExpiresAt: renewedStatus.expiresAt,
              subscriptionAutoRenewing: renewedStatus.autoRenewing,
            },
          });
        }
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_PURCHASED:
        // 新規購入
        console.log(`[webhook/google] New subscription purchased for user ${user.id}`);
        const purchasedStatus = await verifyGoogleSubscriptionStatus(purchaseToken, subscriptionId);
        if (purchasedStatus.isActive && purchasedStatus.expiresAt) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              type: user.type === "OFFICIAL" ? "OFFICIAL" : "PREMIUM",
              subscriptionExpiresAt: purchasedStatus.expiresAt,
              subscriptionAutoRenewing: purchasedStatus.autoRenewing,
            },
          });
        }
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_CANCELED:
        // キャンセル（期限までは有効）
        console.log(`[webhook/google] Subscription canceled for user ${user.id}`);
        await prisma.user.update({
          where: { id: user.id },
          data: { subscriptionAutoRenewing: false },
        });
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_EXPIRED:
        // 期限切れ
        console.log(`[webhook/google] Subscription expired for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_REVOKED:
        // 取り消し（返金など）
        console.log(`[webhook/google] Subscription revoked for user ${user.id}`);
        await downgradeUserSubscription(user.id);
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_ON_HOLD:
        // 支払い保留（Account Hold）
        console.log(`[webhook/google] Subscription on hold for user ${user.id}`);
        // 猶予期間中なのでまだダウングレードしない
        await prisma.user.update({
          where: { id: user.id },
          data: { subscriptionAutoRenewing: false },
        });
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_IN_GRACE_PERIOD:
        // 猶予期間中
        console.log(`[webhook/google] Subscription in grace period for user ${user.id}`);
        // 猶予期間中はまだ有効
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_PAUSED:
        // 一時停止
        console.log(`[webhook/google] Subscription paused for user ${user.id}`);
        // 一時停止中もダウングレード
        await downgradeUserSubscription(user.id);
        break;

      case SubscriptionNotificationType.SUBSCRIPTION_DEFERRED:
        // 延期
        console.log(`[webhook/google] Subscription deferred for user ${user.id}`);
        const deferredStatus = await verifyGoogleSubscriptionStatus(purchaseToken, subscriptionId);
        if (deferredStatus.expiresAt) {
          await prisma.user.update({
            where: { id: user.id },
            data: {
              subscriptionExpiresAt: deferredStatus.expiresAt,
            },
          });
        }
        break;

      default:
        console.log(`[webhook/google] Unhandled notification type: ${notificationType}`);
    }

    return NextResponse.json({ received: true });
  } catch (error) {
    console.error("[webhook/google] Error processing webhook", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
