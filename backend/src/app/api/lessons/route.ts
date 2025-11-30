import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError, ERROR } from "@/lib/errors";
import { listLessons } from "@/lib/store";
import { LearningLevel } from "@/lib/types";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { jsonResponse, CACHE_STRATEGIES } from "@/lib/response";

const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

export async function GET(request: NextRequest) {
  try {
    await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const level = searchParams.get("level") as LearningLevel | null;
    const order = (searchParams.get("order") ?? "asc").toLowerCase();
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

    let lessons = await listLessons();
    if (level) {
      lessons = lessons.filter((lesson) => lesson.level === level);
    }

    lessons.sort((a, b) =>
      order === "asc" ? a.order - b.order : b.order - a.order
    );

    const paginated = paginateArray(lessons, {
      cursor,
      limit,
      getCursor: (lesson) => lesson.id,
    });

    return jsonResponse(
      { data: paginated.data, pageInfo: paginated.pageInfo },
      { cache: CACHE_STRATEGIES.lessons }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
