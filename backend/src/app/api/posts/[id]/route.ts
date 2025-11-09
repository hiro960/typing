import { NextRequest, NextResponse } from "next/server";
import { getAuthUser, requireAuthUser } from "@/lib/auth";
import {
  canViewPost,
  deletePost,
  getPostById,
  toPostResponse,
  updatePost,
} from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { Visibility } from "@/lib/types";

const VISIBILITIES: Visibility[] = ["public", "followers", "private"];

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

    return NextResponse.json(toPostResponse(post, viewer?.id));
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = requireAuthUser(request);
    const post = getPostById(params.id);
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    if (post.userId !== user.id) {
      throw ERROR.FORBIDDEN("You can only update your own posts");
    }

    const body = await request.json();
    const updates: Partial<typeof post> = {};

    if (typeof body.content !== "undefined") {
      if (typeof body.content !== "string" || body.content.trim().length === 0) {
        throw ERROR.INVALID_INPUT("content must be a non-empty string", {
          field: "content",
        });
      }
      if (body.content.length > 280) {
        throw ERROR.INVALID_INPUT("content must be <= 280 characters", {
          field: "content",
        });
      }
      updates.content = body.content.trim();
    }

    if (typeof body.imageUrls !== "undefined") {
      if (!Array.isArray(body.imageUrls) || body.imageUrls.length > 4) {
        throw ERROR.INVALID_INPUT("imageUrls must be an array <=4 items", {
          field: "imageUrls",
        });
      }
      body.imageUrls.forEach((url: unknown, index: number) => {
        if (typeof url !== "string") {
          throw ERROR.INVALID_INPUT("imageUrls must contain strings", {
            field: `imageUrls[${index}]`,
          });
        }
      });
      updates.imageUrls = body.imageUrls;
    }

    if (typeof body.visibility !== "undefined") {
      if (!VISIBILITIES.includes(body.visibility)) {
        throw ERROR.INVALID_INPUT("visibility must be public|followers|private", {
          field: "visibility",
        });
      }
      updates.visibility = body.visibility;
    }

    if (typeof body.tags !== "undefined") {
      if (!Array.isArray(body.tags)) {
        throw ERROR.INVALID_INPUT("tags must be an array", { field: "tags" });
      }
      body.tags.forEach((tag: unknown, index: number) => {
        if (typeof tag !== "string" || tag.length > 40) {
          throw ERROR.INVALID_INPUT("tags must be string array (<=40 chars)", {
            field: `tags[${index}]`,
          });
        }
      });
      updates.tags = body.tags;
    }

    if (typeof body.shareToDiary !== "undefined") {
      if (typeof body.shareToDiary !== "boolean") {
        throw ERROR.INVALID_INPUT("shareToDiary must be boolean", {
          field: "shareToDiary",
        });
      }
      updates.shareToDiary = body.shareToDiary;
    }

    const updated = updatePost(post.id, updates);
    return NextResponse.json(toPostResponse(updated, user.id));
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
    if (post.userId !== user.id) {
      throw ERROR.FORBIDDEN("You can only delete your own posts");
    }
    deletePost(post.id);
    return new NextResponse(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
