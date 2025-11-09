import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import {
  findCommentById,
  getPostById,
  removeComment,
} from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = requireAuthUser(request);
    const comment = findCommentById(params.id);
    if (!comment) {
      throw ERROR.NOT_FOUND("Comment not found");
    }

    const post = getPostById(comment.postId);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    if (comment.userId !== user.id && post.userId !== user.id) {
      throw ERROR.FORBIDDEN("You cannot delete this comment");
    }

    removeComment(comment.id);
    return new Response(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
