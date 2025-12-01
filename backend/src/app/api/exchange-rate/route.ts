/**
 * 為替レート取得API
 *
 * DBに保存されている最新の為替レートを返す。
 * 認証不要（公開情報）
 *
 * GET /api/exchange-rate
 * Query parameters:
 *   - base: 基準通貨 (default: JPY)
 *   - target: 対象通貨 (default: KRW)
 *
 * Response:
 * {
 *   baseCurrency: string,
 *   targetCurrency: string,
 *   rate: number,
 *   fetchedAt: string (ISO8601)
 * }
 */

import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const baseCurrency = searchParams.get("base") ?? "JPY";
    const targetCurrency = searchParams.get("target") ?? "KRW";

    const exchangeRate = await prisma.exchangeRate.findUnique({
      where: {
        baseCurrency_targetCurrency: {
          baseCurrency,
          targetCurrency,
        },
      },
    });

    if (!exchangeRate) {
      return NextResponse.json(
        { error: "Exchange rate not found" },
        { status: 404 }
      );
    }

    return NextResponse.json({
      baseCurrency: exchangeRate.baseCurrency,
      targetCurrency: exchangeRate.targetCurrency,
      rate: exchangeRate.rate,
      fetchedAt: exchangeRate.fetchedAt.toISOString(),
    });
  } catch (error) {
    console.error("[exchange-rate] Error fetching exchange rate:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
