import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { db, findUserById, toUserSummary } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { UserSummary } from "@/lib/types";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    const targetUserId =
      searchParams.get("userId") ?? requireAuthUser(request).id;

    const targetUser = findUserById(targetUserId);
    if (!targetUser) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const entries = db.follows
      .filter((follow) => follow.followerId === targetUser.id)
      .sort(
        (a, b) =>
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
      )
      .map((follow) => {
        const user = findUserById(follow.followingId);
        if (!user) return null;
        return {
          user: toUserSummary(user),
          followedAt: follow.createdAt,
          cursor: `${follow.createdAt}:${user.id}`,
        };
      })
      .filter(
        (
          item
        ): item is { user: UserSummary; followedAt: string; cursor: string } =>
          !!item
      );

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
