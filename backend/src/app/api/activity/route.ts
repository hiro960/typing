import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { recordActivity } from "@/lib/store";
import { ActivityType } from "@/lib/types";

const VALID_ACTIVITY_TYPES: ActivityType[] = [
  "lesson",
  "ranking_game",
  "pronunciation_game",
  "quick_translation",
  "writing",
  "hanja_quiz",
  "shadowing",
];

/**
 * POST /api/activity
 * アクティビティを記録
 */
export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();

    const { activityType, timeSpent, wpm, accuracy, metadata } = body;

    // activityTypeのバリデーション
    if (!VALID_ACTIVITY_TYPES.includes(activityType)) {
      return NextResponse.json(
        { error: { code: "INVALID_INPUT", message: "Invalid activity type" } },
        { status: 400 }
      );
    }

    // timeSpentのバリデーション
    if (typeof timeSpent !== "number" || timeSpent < 0) {
      return NextResponse.json(
        { error: { code: "INVALID_INPUT", message: "Invalid timeSpent" } },
        { status: 400 }
      );
    }

    const activityLog = await recordActivity({
      userId: user.id,
      activityType: activityType as ActivityType,
      timeSpent,
      wpm: wpm ?? undefined,
      accuracy: accuracy ?? undefined,
      metadata: metadata ?? undefined,
    });

    return NextResponse.json({ success: true, id: activityLog.id });
  } catch (error) {
    return handleRouteError(error);
  }
}
