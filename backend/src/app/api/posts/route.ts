import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import {
  db,
  toPostResponse,
  canViewPost,
  createPost,
  findUserById,
} from "@/lib/store";
import { getAuthUser, requireAuthUser } from "@/lib/auth";
import { paginateArray, parseLimit } from "@/lib/pagination";
import { Visibility } from "@/lib/types";

const VISIBILITIES: Visibility[] = ["public", "followers", "private"];

export async function GET(request: NextRequest) {
  try {
    const viewer = getAuthUser(request);
    const viewerId = viewer?.id;

    const { searchParams } = request.nextUrl;
    const feed = (searchParams.get("feed") ?? "forYou").toLowerCase();
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);
    const hashtag = searchParams.get("hashtag")?.toLowerCase();
    const userId = searchParams.get("userId");

    if (!["foryou", "following", "popular"].includes(feed)) {
      throw ERROR.INVALID_INPUT("feed must be forYou|following|popular", {
        field: "feed",
      });
    }

    let posts = db.posts.filter((post) => canViewPost(post, viewerId));

    if (userId) {
      const user = findUserById(userId);
      if (!user) {
        throw ERROR.NOT_FOUND("User not found");
      }
      posts = posts.filter((post) => post.userId === user.id);
    }

    if (hashtag) {
      posts = posts.filter((post) =>
        post.tags.some((tag) => tag.toLowerCase().includes(hashtag))
      );
    }

    if (feed === "following") {
      if (!viewerId) {
        throw ERROR.UNAUTHORIZED("Following feed requires authentication");
      }
      const followingIds = db.follows
        .filter((follow) => follow.followerId === viewerId)
        .map((follow) => follow.followingId);
      posts = posts.filter(
        (post) => post.userId === viewerId || followingIds.includes(post.userId)
      );
    } else if (feed === "popular") {
      posts.sort((a, b) => {
        if (b.likesCount === a.likesCount) {
          return (
            new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
          );
        }
        return b.likesCount - a.likesCount;
      });
    } else {
      posts.sort(
        (a, b) =>
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
      );
    }

    const paginated = paginateArray(posts, {
      cursor,
      limit,
      getCursor: (post) => post.id,
    });

    return NextResponse.json({
      data: paginated.data.map((post) => toPostResponse(post, viewerId)),
      pageInfo: paginated.pageInfo,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function POST(request: NextRequest) {
  try {
    const user = requireAuthUser(request);
    const body = await request.json();
    const {
      content,
      imageUrls = [],
      visibility = user.settings.postDefaultVisibility,
      tags = [],
      shareToDiary = true,
    } = body;

    if (typeof content !== "string" || content.trim().length === 0) {
      throw ERROR.INVALID_INPUT("content is required", { field: "content" });
    }

    if (content.length > 280) {
      throw ERROR.INVALID_INPUT("content must be <= 280 characters", {
        field: "content",
      });
    }

    if (!Array.isArray(imageUrls)) {
      throw ERROR.INVALID_INPUT("imageUrls must be an array", {
        field: "imageUrls",
      });
    }

    if (imageUrls.length > 4) {
      throw ERROR.INVALID_INPUT("imageUrls must be <= 4 items", {
        field: "imageUrls",
      });
    }
    imageUrls.forEach((url: unknown, index: number) => {
      if (typeof url !== "string") {
        throw ERROR.INVALID_INPUT("imageUrls must contain strings", {
          field: `imageUrls[${index}]`,
        });
      }
    });

    if (!VISIBILITIES.includes(visibility)) {
      throw ERROR.INVALID_INPUT("visibility must be public|followers|private", {
        field: "visibility",
      });
    }

    if (!Array.isArray(tags)) {
      throw ERROR.INVALID_INPUT("tags must be an array", { field: "tags" });
    }
    tags.forEach((tag: unknown, index: number) => {
      if (typeof tag !== "string" || tag.length > 40) {
        throw ERROR.INVALID_INPUT("tags must be string array (<=40 chars)", {
          field: `tags[${index}]`,
        });
      }
    });

    if (typeof shareToDiary !== "boolean") {
      throw ERROR.INVALID_INPUT("shareToDiary must be boolean", {
        field: "shareToDiary",
      });
    }

    const post = createPost({
      userId: user.id,
      content: content.trim(),
      imageUrls,
      visibility,
      tags,
      shareToDiary,
    });

    return NextResponse.json(toPostResponse(post, user.id), { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
