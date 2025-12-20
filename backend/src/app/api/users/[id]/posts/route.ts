import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import { toPostResponseBatch, findUserById, canAccessPostSync, batchCheckBlocks, batchCheckFollowing } from "@/lib/store";
import { parseLimit } from "@/lib/pagination";
import { requireAuthUser } from "@/lib/auth";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const targetUser = await findUserById(id);
    if (!targetUser) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const viewer = await requireAuthUser(request);
    const viewerId = viewer.id;

    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);
    const visibility = searchParams.get("visibility");

    if (
      visibility &&
      !["public", "followers", "private"].includes(visibility)
    ) {
      throw ERROR.INVALID_INPUT(
        "visibility must be public|followers|private",
        { field: "visibility" }
      );
    }

    if (visibility && viewerId !== targetUser.id) {
      throw ERROR.FORBIDDEN("Cannot filter visibility for other users");
    }

    const postWhere: Prisma.PostWhereInput = {
      userId: targetUser.id,
      ...(visibility ? { visibility } : {}),
    };

    // 可視性フィルタリングで除外される投稿を考慮し、多めに取得
    const fetchLimit = Math.min(limit * 3 + 10, 150);

    // DBレベルでページネーション（全件取得を回避）
    const posts = await prisma.post.findMany({
      where: postWhere,
      orderBy: { createdAt: "desc" },
      include: { user: true, quotedPost: { include: { user: true } } },
      take: fetchLimit,
      ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
    });

    // N+1解消: 投稿作者のIDを収集し、一括でblock/follow判定を取得
    const authorIds = [...new Set(posts.map((p) => p.userId))];
    const [blockedSet, followingSet] = viewerId
      ? await Promise.all([
          batchCheckBlocks(authorIds, viewerId),
          batchCheckFollowing(viewerId, authorIds),
        ])
      : [new Set<string>(), new Set<string>()];

    // limit + 1件に達したら終了し、正確なhasNextPage判定を保証
    const visiblePosts = [];
    for (const post of posts) {
      if (canAccessPostSync(post, viewerId, blockedSet, followingSet)) {
        visiblePosts.push(post);
        if (visiblePosts.length >= limit + 1) {
          break;
        }
      }
    }

    const hasNextPage = visiblePosts.length > limit;
    const nodes = hasNextPage ? visiblePosts.slice(0, limit) : visiblePosts;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;

    return NextResponse.json({
      data: await toPostResponseBatch(nodes, viewerId),
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
