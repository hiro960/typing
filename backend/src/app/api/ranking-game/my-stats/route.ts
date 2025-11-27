import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { getRankingGameUserStats } from "@/lib/store";

/**
 * GET /api/ranking-game/my-stats
 * 自分の統計情報を取得
 */
export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);

    const stats = await getRankingGameUserStats(user.id);

    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
