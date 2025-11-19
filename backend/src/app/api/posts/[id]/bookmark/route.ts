import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { addBookmark, canViewPost, getPostById, removeBookmark } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

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
      throw ERROR.FORBIDDEN("You cannot bookmark this post");
    }
    await addBookmark(post.id, user.id);
    return NextResponse.json({ bookmarked: true }, { status: 201 });
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
      throw ERROR.FORBIDDEN("You cannot update this bookmark");
    }
    await removeBookmark(post.id, user.id);
    return NextResponse.json({ bookmarked: false });
  } catch (error) {
    return handleRouteError(error);
  }
}
