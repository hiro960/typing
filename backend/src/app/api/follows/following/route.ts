import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { toUserSummary } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { parseLimit } from "@/lib/pagination";
import prisma from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    const authUser = await requireAuthUser(request);
    const targetUserId = searchParams.get("userId") ?? authUser.id;

    // 存在確認のみ（不要なフィールド取得を回避）
    const targetUser = await prisma.user.findUnique({
      where: { id: targetUserId },
      select: { id: true },
    });
    if (!targetUser) {
      throw ERROR.NOT_FOUND("User not found");
    }

    // DBレベルでページネーション（全件取得を回避）
    const follows = await prisma.follow.findMany({
      where: { followerId: targetUser.id },
      include: { following: true },
      orderBy: { createdAt: "desc" },
      take: limit + 1,
      ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
    });

    const hasNextPage = follows.length > limit;
    const nodes = hasNextPage ? follows.slice(0, limit) : follows;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;

    return NextResponse.json({
      data: nodes.map((follow) => ({
        user: toUserSummary(follow.following),
        followedAt: follow.createdAt,
      })),
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
