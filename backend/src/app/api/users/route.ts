import { NextRequest, NextResponse } from "next/server";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { ERROR, handleRouteError } from "@/lib/errors";
import { db, toUserSummary } from "@/lib/store";
import { LearningLevel } from "@/lib/types";

const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const q = searchParams.get("q")?.toLowerCase();
    const level = searchParams.get("level") as LearningLevel | null;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    if (level && !LEVELS.includes(level)) {
      throw ERROR.INVALID_INPUT("level must be beginner|intermediate|advanced", {
        field: "level",
      });
    }

    let users = db.users.slice();

    if (q) {
      users = users.filter((user) => {
        return (
          user.username.toLowerCase().includes(q) ||
          user.displayName.toLowerCase().includes(q) ||
          (user.bio?.toLowerCase().includes(q) ?? false)
        );
      });
    }

    if (level) {
      users = users.filter((user) => user.learningLevel === level);
    }

    users.sort((a, b) => a.displayName.localeCompare(b.displayName));

    const paginated = paginateArray(users, {
      cursor,
      limit,
      getCursor: (user) => user.id,
    });

    return NextResponse.json({
      data: paginated.data.map(toUserSummary),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
