import { NextRequest, NextResponse } from "next/server";
import { getAuthUser, requireAuthUser } from "@/lib/auth";
import {
  addComment,
  canViewPost,
  getPostById,
  listComments,
  toCommentResponse,
} from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { paginateArray, parseLimit } from "@/lib/pagination";

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const post = getPostById(params.id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    const viewer = getAuthUser(request);
    if (!canViewPost(post, viewer?.id)) {
      throw ERROR.FORBIDDEN("You are not allowed to view this post");
    }

    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    const comments = listComments(post.id).sort(
      (a, b) =>
        new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
    );

    const paginated = paginateArray(comments, {
      cursor,
      limit,
      getCursor: (comment) => comment.id,
    });

    return NextResponse.json({
      data: paginated.data.map(toCommentResponse),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = requireAuthUser(request);
    const post = getPostById(params.id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    if (!canViewPost(post, user.id)) {
      throw ERROR.FORBIDDEN("You cannot comment on this post");
    }

    const body = await request.json();
    if (typeof body.content !== "string" || body.content.trim().length === 0) {
      throw ERROR.INVALID_INPUT("content is required", { field: "content" });
    }
    if (body.content.length > 280) {
      throw ERROR.INVALID_INPUT("content must be <= 280 characters", {
        field: "content",
      });
    }

    const comment = addComment(post.id, user.id, body.content.trim());
    return NextResponse.json(toCommentResponse(comment), { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
