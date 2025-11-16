import { NextRequest, NextResponse } from "next/server";
import { WordCategory as PrismaWordCategory, WordStatus as PrismaWordStatus } from "@prisma/client";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import prisma from "@/lib/prisma";

const CATEGORY_LIST = Object.values(PrismaWordCategory);
const STATUS_LIST = Object.values(PrismaWordStatus);

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const where = { userId: user.id };

    const [categoryGroups, statusGroups, aggregate, totalWords] = await Promise.all([
      prisma.wordbook.groupBy({
        by: ["category"],
        where,
        _count: { _all: true },
      }),
      prisma.wordbook.groupBy({
        by: ["status"],
        where,
        _count: { _all: true },
      }),
      prisma.wordbook.aggregate({
        where,
        _avg: { successRate: true },
        _sum: { reviewCount: true },
      }),
      prisma.wordbook.count({ where }),
    ]);

    const byCategory = CATEGORY_LIST.reduce<Record<string, number>>((acc, category) => {
      acc[category] = 0;
      return acc;
    }, {});
    categoryGroups.forEach((group) => {
      byCategory[group.category] = group._count._all;
    });

    const byStatus = STATUS_LIST.reduce<Record<string, number>>((acc, status) => {
      acc[status] = 0;
      return acc;
    }, {});
    statusGroups.forEach((group) => {
      byStatus[group.status] = group._count._all;
    });

    return NextResponse.json({
      totalWords,
      byCategory,
      byStatus,
      averageSuccessRate: aggregate._avg.successRate ?? 0,
      totalReviewCount: aggregate._sum.reviewCount ?? 0,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
