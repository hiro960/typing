import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { addLike, getPostById, removeLike } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

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
    const updated = addLike(post.id, user.id);
    return NextResponse.json({
      likesCount: updated.likesCount,
      liked: true,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = requireAuthUser(request);
    const post = getPostById(params.id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }
    const updated = removeLike(post.id, user.id);
    return NextResponse.json({
      likesCount: updated.likesCount,
      liked: false,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
