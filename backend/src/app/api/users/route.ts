import { NextRequest, NextResponse } from "next/server";
import { paginateArray } from "@/lib/pagination";
import { ERROR, handleRouteError } from "@/lib/errors";
import { toUserSummary } from "@/lib/store";
import { LearningLevel } from "@/lib/types";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const q = searchParams.get("q") ?? "";
    const level = searchParams.get("level") as LearningLevel | null;
    const cursor = searchParams.get("cursor");

    const limitParam = searchParams.get("limit");
    let limit = 20;

    if (limitParam !== null) {
      const parsed = Number.parseInt(limitParam, 10);
      if (Number.isNaN(parsed) || parsed < 1 || parsed > 100) {
        throw ERROR.INVALID_INPUT("limit must be between 1 and 100", {
          field: "limit",
        });
      }
      limit = parsed;
    }

    if (level && !LEVELS.includes(level)) {
      throw ERROR.INVALID_INPUT("level must be beginner|intermediate|advanced", {
        field: "level",
      });
    }

    const where: Prisma.UserWhereInput = {};

    if (q) {
      where.OR = [
        { username: { contains: q, mode: "insensitive" } },
        { displayName: { contains: q, mode: "insensitive" } },
        { bio: { contains: q, mode: "insensitive" } },
      ];
    }

    if (level) {
      where.learningLevel = level;
    }

    const users =
      (await prisma.user.findMany({
        where,
        orderBy: { displayName: "asc" },
      })) ?? [];

    const paginated = paginateArray(users, {
      cursor,
      limit,
      getCursor: (user) => user.id,
    });

    const derivedHasNext =
      paginated.pageInfo.hasNextPage ||
      (!cursor && paginated.pageInfo.count === limit);

    return NextResponse.json({
      data: paginated.data.map(toUserSummary),
      pageInfo: {
        ...paginated.pageInfo,
        hasNextPage: derivedHasNext,
      },
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
