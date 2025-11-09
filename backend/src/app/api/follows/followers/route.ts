import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { findUserById, toUserSummary } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { paginateArray, parseLimit } from "@/lib/pagination";
import prisma from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    const authUser = await requireAuthUser(request);
    const targetUserId = searchParams.get("userId") ?? authUser.id;

    const targetUser = await findUserById(targetUserId);
    if (!targetUser) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const follows = await prisma.follow.findMany({
      where: { followingId: targetUser.id },
      include: { follower: true },
      orderBy: { createdAt: "desc" },
    });

    const entries = follows.map((follow) => ({
      user: toUserSummary(follow.follower),
      followedAt: follow.createdAt,
      cursor: `${follow.createdAt.toISOString()}:${follow.followerId}`,
    }));

    const paginated = paginateArray(entries, {
      cursor,
      limit,
      getCursor: (item) => item.cursor,
    });

    return NextResponse.json({
      data: paginated.data.map((entry) => ({
        user: entry.user,
        followedAt: entry.followedAt,
      })),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
