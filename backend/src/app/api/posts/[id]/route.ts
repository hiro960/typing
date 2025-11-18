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
import { PostRecord, Visibility } from "@/lib/types";

const VISIBILITIES: Visibility[] = ["public", "followers", "private"];

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

    return NextResponse.json(await toPostResponse(post, viewer?.id));
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function PUT(
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

    if (post.userId !== user.id) {
      throw ERROR.FORBIDDEN("You can only update your own posts");
    }

    const body = await request.json();
    if (typeof body.quotedPostId !== "undefined") {
      throw ERROR.INVALID_INPUT("quotedPostId cannot be updated", {
        field: "quotedPostId",
      });
    }

    const isDraft = post.visibility === "private";
    const publishedAt = new Date(post.createdAt);
    const twentyFourHoursMs = 24 * 60 * 60 * 1000;
    if (!isDraft && Date.now() - publishedAt.getTime() > twentyFourHoursMs) {
      throw ERROR.FORBIDDEN("This post can no longer be edited");
    }

    let isPublishing = false;
    const updates: Partial<PostRecord> = {};

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
      updates.visibility = body.visibility as Visibility;
      if (post.visibility === "private" && body.visibility !== "private") {
        isPublishing = true;
      }
    }

    if (typeof body.tags !== "undefined") {
      updates.tags = normalizeTagsInput(body.tags);
    }

    if (typeof body.shareToDiary !== "undefined") {
      if (typeof body.shareToDiary !== "boolean") {
        throw ERROR.INVALID_INPUT("shareToDiary must be boolean", {
          field: "shareToDiary",
        });
      }
      updates.shareToDiary = body.shareToDiary;
    }

    const hasContentMutation =
      typeof updates.content !== "undefined" ||
      typeof updates.imageUrls !== "undefined" ||
      typeof updates.tags !== "undefined" ||
      typeof updates.shareToDiary !== "undefined";

    const updated = await updatePost(id, updates, {
      resetCreatedAt: isPublishing,
      markEdited: !isPublishing && !isDraft && hasContentMutation,
      incrementPostsCount: isPublishing,
    });
    return NextResponse.json(await toPostResponse(updated, user.id));
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
    if (post.userId !== user.id) {
      throw ERROR.FORBIDDEN("You can only delete your own posts");
    }
    await deletePost(id);
    return new NextResponse(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}

function normalizeTagsInput(tags: unknown): string[] {
  if (!Array.isArray(tags)) {
    throw ERROR.INVALID_INPUT("tags must be an array", { field: "tags" });
  }
  const normalized = new Set<string>();
  tags.forEach((tag, index) => {
    if (typeof tag !== "string") {
      throw ERROR.INVALID_INPUT("tags must contain strings", { field: `tags[${index}]` });
    }
    let value = tag.trim().replace(/^#/, "").trim();
    if (!value) {
      return;
    }
    if (/^[a-zA-Z0-9_]+$/.test(value)) {
      value = value.toLowerCase();
    }
    if (value.length > 40) {
      throw ERROR.INVALID_INPUT("tags must be string array (<=40 chars)", {
        field: `tags[${index}]`,
      });
    }
    normalized.add(value);
  });
  return Array.from(normalized);
}
