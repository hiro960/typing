/**
 * Cron Job: サブスクリプション期限切れチェック
 *
 * Webhookが失敗した場合のバックアップとして、期限切れのPREMIUMユーザーを
 * Apple/Googleに再問い合わせし、自動更新されていれば期限を延長、
 * そうでなければNORMALにダウングレードする。
 *
 * Vercel Cronでの設定:
 * vercel.json に以下を追加:
 * {
 *   "crons": [{
 *     "path": "/api/cron/subscription-check",
 *     "schedule": "0 * * * *"  // 毎時実行
 *   }]
 * }
 *
 * 環境変数:
 * - CRON_SECRET: Cronジョブの認証用シークレット
 */

import { NextRequest, NextResponse } from "next/server";
import { processExpiredSubscriptions } from "@/lib/subscription";

export async function GET(request: NextRequest) {
  try {
    // Vercel Cronからの認証を確認
    const authHeader = request.headers.get("authorization");
    const cronSecret = process.env.CRON_SECRET;

    // 認証が設定されている場合は検証
    if (cronSecret && authHeader !== `Bearer ${cronSecret}`) {
      console.error("[cron/subscription-check] Unauthorized request");
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    console.log("[cron/subscription-check] Starting subscription check...");

    const results = await processExpiredSubscriptions();

    console.log("[cron/subscription-check] Completed", results);

    return NextResponse.json({
      success: true,
      results,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("[cron/subscription-check] Error", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

// POSTも対応（手動トリガー用）
export async function POST(request: NextRequest) {
  return GET(request);
}
