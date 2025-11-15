import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { getLessonStats } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { LessonStatsRange, LearningLevel } from "@/lib/types";

const RANGES: LessonStatsRange[] = ["daily", "weekly", "monthly", "all"];
const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const range = (searchParams.get("range") ?? "weekly") as LessonStatsRange;
    const level = searchParams.get("level") as LearningLevel | null;

    if (!RANGES.includes(range)) {
      throw ERROR.INVALID_INPUT("range must be daily|weekly|monthly|all", {
        field: "range",
      });
    }

    if (level && !LEVELS.includes(level)) {
      throw ERROR.INVALID_INPUT("level must be beginner|intermediate|advanced", {
        field: "level",
      });
    }

    const stats = await getLessonStats(user.id, range, level ?? undefined);
    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
