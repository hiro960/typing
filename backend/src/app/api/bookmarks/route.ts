import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { canAccessPostSync, toPostResponseBatch, batchCheckBlocks, batchCheckFollowing } from "@/lib/store";
import prisma from "@/lib/prisma";
import { handleRouteError } from "@/lib/errors";
import { parseLimit } from "@/lib/pagination";
import { jsonResponse, CACHE_STRATEGIES } from "@/lib/response";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 100);

    // 可視性フィルタリングで除外される投稿を考慮し、多めに取得
    const fetchLimit = Math.min(limit * 3 + 10, 150);

    const bookmarks =
      (await prisma.bookmark.findMany({
        where: { userId: user.id },
        include: {
          post: {
            include: {
              user: true,
              quotedPost: { include: { user: true } },
            },
          },
        },
        orderBy: { createdAt: "desc" },
        take: fetchLimit,
        ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
      })) ?? [];

    // N+1解消: 投稿作者のIDを収集し、一括でblock/follow判定を取得
    const authorIds = [...new Set(bookmarks.filter((b) => b.post).map((b) => b.post!.userId))];
    const [blockedSet, followingSet] = await Promise.all([
      batchCheckBlocks(authorIds, user.id),
      batchCheckFollowing(user.id, authorIds),
    ]);

    // limit + 1件に達したら終了し、正確なhasNextPage判定を保証
    const visible = [];
    for (const bookmark of bookmarks) {
      if (!bookmark.post) {
        continue;
      }
      if (!canAccessPostSync(bookmark.post, user.id, blockedSet, followingSet)) {
        continue;
      }
      visible.push(bookmark);
      if (visible.length >= limit + 1) {
        break;
      }
    }

    const hasNextPage = visible.length > limit;
    const nodes = hasNextPage ? visible.slice(0, limit) : visible;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;
    const posts = nodes.map((bookmark) => bookmark.post);
    const data = await toPostResponseBatch(posts, user.id);

    return jsonResponse(
      {
        data,
        pageInfo: {
          nextCursor,
          hasNextPage,
          count: nodes.length,
        },
      },
      { cache: CACHE_STRATEGIES.bookmarks }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
