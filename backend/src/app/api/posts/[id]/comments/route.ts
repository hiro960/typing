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
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const post = await getPostById(id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    const viewer = await getAuthUser(request);
    if (!(await canViewPost(post, viewer?.id))) {
      throw ERROR.FORBIDDEN("You are not allowed to view this post");
    }

    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    const comments = await listComments(post.id);

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
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await requireAuthUser(request);
    const post = await getPostById(id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    if (!(await canViewPost(post, user.id))) {
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

    const comment = await addComment(post.id, user.id, body.content.trim());
    return NextResponse.json(toCommentResponse(comment), { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
