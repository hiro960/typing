import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { addLike, canViewPost, getPostById, removeLike } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

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
      throw ERROR.FORBIDDEN("You cannot like this post");
    }
    const updated = await addLike(post, user.id);
    return NextResponse.json(
      {
        likesCount: updated.likesCount,
        liked: true,
      },
      { status: 201 }
    );
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
    const post = await getPostById(id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }
    if (!(await canViewPost(post, user.id))) {
      throw ERROR.FORBIDDEN("You cannot like this post");
    }
    const updated = await removeLike(post.id, user.id);
    return NextResponse.json({
      likesCount: updated.likesCount,
      liked: false,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
