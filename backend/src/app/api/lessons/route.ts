import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError, ERROR } from "@/lib/errors";
import { listLessons } from "@/lib/store";
import { LearningLevel } from "@/lib/types";
import { parseLimit } from "@/lib/pagination";
import { jsonResponse, CACHE_STRATEGIES } from "@/lib/response";

const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

export async function GET(request: NextRequest) {
  try {
    await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const level = searchParams.get("level") as LearningLevel | null;
    const order = (searchParams.get("order") ?? "asc").toLowerCase() as "asc" | "desc";
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    if (level && !LEVELS.includes(level)) {
      throw ERROR.INVALID_INPUT("level must be beginner|intermediate|advanced", {
        field: "level",
      });
    }

    if (!["asc", "desc"].includes(order)) {
      throw ERROR.INVALID_INPUT("order must be asc|desc", { field: "order" });
    }

    // DBレベルでフィルタ、ソート、ページネーション（listLessonsが対応）
    const result = await listLessons({
      level: level ?? undefined,
      order,
      cursor,
      limit,
    });

    return jsonResponse(
      {
        data: result.data,
        pageInfo: {
          nextCursor: result.nextCursor,
          hasNextPage: result.hasNextPage,
          count: result.data.length,
        },
      },
      { cache: CACHE_STRATEGIES.lessons }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
