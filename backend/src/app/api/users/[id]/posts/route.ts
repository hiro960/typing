import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import {
  canViewPost,
  db,
  toPostResponse,
  findUserById,
} from "@/lib/store";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { getAuthUser } from "@/lib/auth";

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const targetUser = findUserById(params.id);
    if (!targetUser) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const viewer = getAuthUser(request);
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

    let posts = db.posts
      .filter((post) => post.userId === targetUser.id)
      .filter((post) => canViewPost(post, viewerId));

    if (visibility) {
      posts = posts.filter((post) => post.visibility === visibility);
    }

    posts.sort(
      (a, b) =>
        new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );

    const paginated = paginateArray(posts, {
      cursor,
      limit,
      getCursor: (post) => post.id,
    });

    return NextResponse.json({
      data: paginated.data.map((post) => toPostResponse(post, viewerId)),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
