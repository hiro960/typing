import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { canViewPost, findCommentById, getPostById, likeComment, unlikeComment } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await requireAuthUser(request);
    const comment = await findCommentById(id);
    if (!comment) {
      throw ERROR.NOT_FOUND("Comment not found");
    }
    const post = await getPostById(comment.postId);
    if (!post || !(await canViewPost(post, user.id))) {
      throw ERROR.FORBIDDEN("You cannot interact with this comment");
    }

    const updated = await likeComment(comment.id, user.id);
    return NextResponse.json({
      liked: true,
      likesCount: updated.likesCount,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await requireAuthUser(request);
    const comment = await findCommentById(id);
    if (!comment) {
      throw ERROR.NOT_FOUND("Comment not found");
    }
    const post = await getPostById(comment.postId);
    if (!post || !(await canViewPost(post, user.id))) {
      throw ERROR.FORBIDDEN("You cannot interact with this comment");
    }

    const updated = await unlikeComment(comment.id, user.id);
    return NextResponse.json({
      liked: false,
      likesCount: updated.likesCount,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
