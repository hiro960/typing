import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import { toPostResponse, findUserById, canViewPost } from "@/lib/store";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { getAuthUser } from "@/lib/auth";
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

    const viewer = await getAuthUser(request);
    const viewerId = viewer?.id;

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

    const posts = await prisma.post.findMany({
      where: postWhere,
      orderBy: { createdAt: "desc" },
      include: { user: true, quotedPost: { include: { user: true } } },
    });

    const visiblePosts = [];
    for (const post of posts) {
      if (await canViewPost(post, viewerId)) {
        visiblePosts.push(post);
      }
    }

    const paginated = paginateArray(visiblePosts, {
      cursor,
      limit,
      getCursor: (post) => post.id,
    });

    return NextResponse.json({
      data: await Promise.all(
        paginated.data.map((post) => toPostResponse(post, viewerId))
      ),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
