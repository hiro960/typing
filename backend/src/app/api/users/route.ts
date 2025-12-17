import { NextRequest, NextResponse } from "next/server";
import { ERROR, handleRouteError } from "@/lib/errors";
import { toUserSummary } from "@/lib/store";
import { requireAuthUser } from "@/lib/auth";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";
import { parseLimit } from "@/lib/pagination";

export async function GET(request: NextRequest) {
  try {
    await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const q = searchParams.get("q") ?? "";
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 100);

    const where: Prisma.UserWhereInput = {};

    if (q) {
      where.OR = [
        { username: { contains: q, mode: "insensitive" } },
        { displayName: { contains: q, mode: "insensitive" } },
        { bio: { contains: q, mode: "insensitive" } },
      ];
    }

    // DBレベルでページネーション（全件取得を回避）
    const users = await prisma.user.findMany({
      where,
      orderBy: { displayName: "asc" },
      take: limit + 1,
      ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
    });

    const hasNextPage = users.length > limit;
    const nodes = hasNextPage ? users.slice(0, limit) : users;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;

    return NextResponse.json({
      data: nodes.map(toUserSummary),
      pageInfo: {
        nextCursor,
        hasNextPage,
        count: nodes.length,
      },
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
