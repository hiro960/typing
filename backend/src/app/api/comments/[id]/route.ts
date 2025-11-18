import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { findCommentById, removeComment } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

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

    if (comment.userId !== user.id) {
      throw ERROR.FORBIDDEN("You cannot delete this comment");
    }

    await removeComment(comment.id);
    return new Response(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
