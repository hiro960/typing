import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { ERROR } from "@/lib/errors";
import { createPronunciationGameResult } from "@/lib/store";
import { RankingGameDifficulty } from "@/lib/types";

const VALID_DIFFICULTIES: RankingGameDifficulty[] = [
  "beginner",
  "intermediate",
  "advanced",
];

/**
 * POST /api/pronunciation-game/results
 * ゲーム結果を保存
 */
export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();

    const {
      difficulty,
      score,
      correctCount,
      maxCombo,
      totalBonusTime,
      characterLevel,
      timeSpent,
      accuracy,
    } = body;

    // バリデーション
    if (!difficulty || !VALID_DIFFICULTIES.includes(difficulty)) {
      throw ERROR.INVALID_INPUT("Invalid difficulty", { field: "difficulty" });
    }

    if (typeof score !== "number" || score < 0) {
      throw ERROR.INVALID_INPUT("score must be a non-negative number", {
        field: "score",
      });
    }

    if (typeof correctCount !== "number" || correctCount < 0) {
      throw ERROR.INVALID_INPUT("correctCount must be a non-negative number", {
        field: "correctCount",
      });
    }

    if (typeof maxCombo !== "number" || maxCombo < 0) {
      throw ERROR.INVALID_INPUT("maxCombo must be a non-negative number", {
        field: "maxCombo",
      });
    }

    if (typeof totalBonusTime !== "number" || totalBonusTime < 0) {
      throw ERROR.INVALID_INPUT("totalBonusTime must be a non-negative number", {
        field: "totalBonusTime",
      });
    }

    if (
      typeof characterLevel !== "number" ||
      characterLevel < 0 ||
      characterLevel > 5
    ) {
      throw ERROR.INVALID_INPUT("characterLevel must be between 0 and 5", {
        field: "characterLevel",
      });
    }

    if (timeSpent !== undefined && (typeof timeSpent !== "number" || timeSpent < 0)) {
      throw ERROR.INVALID_INPUT("timeSpent must be a non-negative number", {
        field: "timeSpent",
      });
    }

    if (accuracy !== undefined && (typeof accuracy !== "number" || accuracy < 0 || accuracy > 1)) {
      throw ERROR.INVALID_INPUT("accuracy must be between 0 and 1", {
        field: "accuracy",
      });
    }

    const result = await createPronunciationGameResult({
      userId: user.id,
      difficulty,
      score,
      correctCount,
      maxCombo,
      totalBonusTime,
      characterLevel,
      timeSpent,
      accuracy,
    });

    return NextResponse.json(result, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
