import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { getRankingGameUserStatsSummary } from "@/lib/store";

/**
 * GET /api/ranking-game/my-stats/summary
 * ホーム画面用軽量版統計（bestScoreのみ、1クエリで高速）
 */
export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);

    const stats = await getRankingGameUserStatsSummary(user.id);

    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
