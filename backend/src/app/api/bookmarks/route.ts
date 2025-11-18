import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { canViewPost, toPostResponse } from "@/lib/store";
import prisma from "@/lib/prisma";
import { handleRouteError } from "@/lib/errors";
import { parseLimit } from "@/lib/pagination";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 100);

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
        take: limit + 1,
        ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
      })) ?? [];

    const visible = [];
    for (const bookmark of bookmarks) {
      if (!bookmark.post) {
        continue;
      }
      if (!(await canViewPost(bookmark.post, user.id))) {
        continue;
      }
      visible.push(bookmark);
    }

    const hasNextPage = visible.length > limit;
    const nodes = hasNextPage ? visible.slice(0, limit) : visible;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;
    const data = await Promise.all(
      nodes.map((bookmark) => toPostResponse(bookmark.post, user.id))
    );

    return NextResponse.json({
      data,
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
