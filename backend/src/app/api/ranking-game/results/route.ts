import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { ERROR } from "@/lib/errors";
import { createRankingGameResult } from "@/lib/store";
import { RankingGameDifficulty } from "@/lib/types";

const VALID_DIFFICULTIES: RankingGameDifficulty[] = [
  "beginner",
  "intermediate",
  "advanced",
];

/**
 * POST /api/ranking-game/results
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
      avgInputSpeed,
      characterLevel,
      timeSpent,
      accuracy,
      mistakeCharacters,
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

    if (typeof avgInputSpeed !== "number" || avgInputSpeed < 0) {
      throw ERROR.INVALID_INPUT("avgInputSpeed must be a non-negative number", {
        field: "avgInputSpeed",
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

    // timeSpent バリデーション（オプション）
    if (timeSpent !== undefined && (typeof timeSpent !== "number" || timeSpent < 0)) {
      throw ERROR.INVALID_INPUT("timeSpent must be a non-negative number", {
        field: "timeSpent",
      });
    }

    // accuracy バリデーション（オプション）
    if (accuracy !== undefined && (typeof accuracy !== "number" || accuracy < 0 || accuracy > 1)) {
      throw ERROR.INVALID_INPUT("accuracy must be between 0 and 1", {
        field: "accuracy",
      });
    }

    // mistakeCharacters バリデーション（オプション）
    if (mistakeCharacters !== undefined && typeof mistakeCharacters !== "object") {
      throw ERROR.INVALID_INPUT("mistakeCharacters must be an object", {
        field: "mistakeCharacters",
      });
    }

    const result = await createRankingGameResult({
      userId: user.id,
      difficulty,
      score,
      correctCount,
      maxCombo,
      totalBonusTime,
      avgInputSpeed,
      characterLevel,
      timeSpent,
      accuracy,
      mistakeCharacters,
    });

    return NextResponse.json(result, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
