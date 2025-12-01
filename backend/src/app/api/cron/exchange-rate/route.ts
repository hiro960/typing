/**
 * Cron Job: 為替レート取得
 *
 * ExchangeRate-APIからJPY→KRWの為替レートを取得し、DBに保存する。
 *
 * Vercel Cronでの設定:
 * vercel.json に以下を追加:
 * "crons": [{ "path": "/api/cron/exchange-rate", "schedule": "every 30 minutes" }]
 *
 * 環境変数:
 * - EXCHANGE_RATE_API_KEY: ExchangeRate-APIのAPIキー
 * - CRON_SECRET: Cronジョブの認証用シークレット
 */

import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

interface ExchangeRateAPIResponse {
  result: string;
  base_code: string;
  conversion_rates: {
    KRW: number;
    [key: string]: number;
  };
  time_last_update_utc: string;
}

export async function GET(request: NextRequest) {
  try {
    // Vercel Cronからの認証を確認
    const authHeader = request.headers.get("authorization");
    const cronSecret = process.env.CRON_SECRET;

    // 認証が設定されている場合は検証
    if (cronSecret && authHeader !== `Bearer ${cronSecret}`) {
      console.error("[cron/exchange-rate] Unauthorized request");
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    console.log("[cron/exchange-rate] Starting exchange rate fetch...");

    const apiKey = process.env.EXCHANGE_RATE_API_KEY;
    if (!apiKey) {
      console.error("[cron/exchange-rate] EXCHANGE_RATE_API_KEY is not set");
      return NextResponse.json(
        { error: "API key not configured" },
        { status: 500 }
      );
    }

    // ExchangeRate-APIからレートを取得
    const apiUrl = `https://v6.exchangerate-api.com/v6/${apiKey}/latest/JPY`;
    const response = await fetch(apiUrl);

    if (!response.ok) {
      console.error(
        "[cron/exchange-rate] Failed to fetch from API:",
        response.status
      );
      return NextResponse.json(
        { error: "Failed to fetch exchange rate" },
        { status: 502 }
      );
    }

    const data: ExchangeRateAPIResponse = await response.json();

    if (data.result !== "success") {
      console.error("[cron/exchange-rate] API returned error:", data);
      return NextResponse.json(
        { error: "Exchange rate API error" },
        { status: 502 }
      );
    }

    const krwRate = data.conversion_rates.KRW;

    // DBにupsert（存在すれば更新、なければ作成）
    const exchangeRate = await prisma.exchangeRate.upsert({
      where: {
        baseCurrency_targetCurrency: {
          baseCurrency: "JPY",
          targetCurrency: "KRW",
        },
      },
      update: {
        rate: krwRate,
        fetchedAt: new Date(),
      },
      create: {
        baseCurrency: "JPY",
        targetCurrency: "KRW",
        rate: krwRate,
      },
    });

    console.log("[cron/exchange-rate] Updated exchange rate:", exchangeRate);

    return NextResponse.json({
      success: true,
      rate: krwRate,
      fetchedAt: exchangeRate.fetchedAt.toISOString(),
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error("[cron/exchange-rate] Error", error);
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
