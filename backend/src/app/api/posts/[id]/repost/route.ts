import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { addRepost, canViewPost, getPostById, removeRepost } from "@/lib/store";
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
    if (post.visibility !== "public") {
      throw ERROR.FORBIDDEN("This post cannot be reposted");
    }
    if (!(await canViewPost(post, user.id))) {
      throw ERROR.FORBIDDEN("You cannot repost this post");
    }
    const { updatedPost } = await addRepost(post, user.id);
    return NextResponse.json(
      {
        repostsCount: updatedPost.repostsCount,
        reposted: true,
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
      throw ERROR.FORBIDDEN("You cannot modify this repost");
    }
    const updatedPost = await removeRepost(post.id, user.id);
    return NextResponse.json({
      repostsCount: updatedPost.repostsCount,
      reposted: false,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}
