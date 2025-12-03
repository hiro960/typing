import { NextRequest, NextResponse } from "next/server";
import { getAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { ERROR } from "@/lib/errors";
import { getPronunciationGameRanking } from "@/lib/store";
import { RankingGameDifficulty, RankingPeriod } from "@/lib/types";
import { parseLimit } from "@/lib/pagination";

const VALID_DIFFICULTIES = ["all", "beginner", "intermediate", "advanced"];
const VALID_PERIODS: RankingPeriod[] = ["monthly", "weekly"];

/**
 * GET /api/pronunciation-game/ranking
 * ランキングを取得
 */
export async function GET(request: NextRequest) {
  try {
    const viewer = await getAuthUser(request);
    const { searchParams } = request.nextUrl;

    const difficulty = searchParams.get("difficulty") ?? "all";
    const period = (searchParams.get("period") ?? "monthly") as RankingPeriod;
    const limit = parseLimit(searchParams.get("limit"), 50, 1, 100);
    const followingOnly = searchParams.get("following") === "true";

    // バリデーション
    if (!VALID_DIFFICULTIES.includes(difficulty)) {
      throw ERROR.INVALID_INPUT("Invalid difficulty", { field: "difficulty" });
    }

    if (!VALID_PERIODS.includes(period)) {
      throw ERROR.INVALID_INPUT("Invalid period", { field: "period" });
    }

    if (followingOnly && !viewer) {
      throw ERROR.UNAUTHORIZED("Authentication required for following filter");
    }

    const ranking = await getPronunciationGameRanking({
      difficulty: difficulty as RankingGameDifficulty | "all",
      period,
      limit,
      followingOnly,
      viewerId: viewer?.id,
    });

    return NextResponse.json(ranking);
  } catch (error) {
    return handleRouteError(error);
  }
}
