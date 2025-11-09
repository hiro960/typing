import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import { toPostResponse, createPost, isFollowingUser } from "@/lib/store";
import { getAuthUser, requireAuthUser } from "@/lib/auth";
import { Visibility } from "@/lib/types";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

const VISIBILITIES: Visibility[] = ["public", "followers", "private"];

export async function GET(request: NextRequest) {
  try {
    const viewer = await getAuthUser(request);
    const viewerId = viewer?.id;

    const { searchParams } = request.nextUrl;
    const feed = (searchParams.get("feed") ?? "forYou").toLowerCase();
    const cursor = searchParams.get("cursor");

    const limitParam = searchParams.get("limit");
    let limit = 20;
    if (limitParam !== null) {
      const parsed = Number.parseInt(limitParam, 10);
      if (Number.isNaN(parsed) || parsed < 1 || parsed > 100) {
        throw ERROR.INVALID_INPUT("limit must be between 1 and 100", {
          field: "limit",
        });
      }
      limit = parsed;
    }
    const hashtag = searchParams.get("hashtag");
    const userId = searchParams.get("userId");

    if (!["foryou", "following", "popular"].includes(feed)) {
      throw ERROR.INVALID_INPUT("feed must be forYou|following|popular", {
        field: "feed",
      });
    }

    const where: Prisma.PostWhereInput = {};
    let orderBy: Prisma.PostOrderByWithRelationInput[] = [{ createdAt: "desc" }];

    if (userId) {
      const user = await prisma.user.findUnique({ where: { id: userId } });
      if (!user) {
        throw ERROR.NOT_FOUND("User not found");
      }
      where.userId = userId;
    }

    if (hashtag) {
      const normalized = hashtag.startsWith("#") ? hashtag : `#${hashtag}`;
      where.tags = { has: normalized };
    }

    if (feed === "following") {
      if (!viewerId) {
        throw ERROR.UNAUTHORIZED("Following feed requires authentication");
      }
      const following = await prisma.follow.findMany({
        where: { followerId: viewerId },
        select: { followingId: true },
      });
      const ids = following.map((item) => item.followingId);
      ids.push(viewerId);
      if (ids.length === 0) {
        return NextResponse.json({
          data: [],
          pageInfo: { nextCursor: null, hasNextPage: false, count: 0 },
        });
      }
      where.userId = { in: ids };
    } else if (feed === "popular") {
      orderBy = [
        { likesCount: "desc" },
        { createdAt: "desc" },
      ];
    }

    const posts =
      (await prisma.post.findMany({
        where,
        include: { user: true },
        orderBy,
        take: limit + 1,
        ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
      })) ?? [];

    const followCache = new Map<string, boolean>();
    const visible: typeof posts = [];
    for (const post of posts) {
      if (await canAccessPost(post, viewerId, followCache)) {
        visible.push(post);
      }
    }

    const hasNextPage = visible.length > limit;
    const nodes = hasNextPage ? visible.slice(0, limit) : visible;
    const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;

    const data = await Promise.all(nodes.map((post) => toPostResponse(post, viewerId)));

    return NextResponse.json({
      data,
      pageInfo: {
        nextCursor,
        hasNextPage,
        count: nodes.length,
      },
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

async function canAccessPost(
  post: Prisma.PostGetPayload<{ include: { user: true } }>,
  viewerId?: string,
  cache?: Map<string, boolean>
) {
  if (post.visibility === "public") return true;
  if (!viewerId) return false;
  if (post.userId === viewerId) return true;
  if (post.visibility === "followers") {
    if (!cache) {
      return isFollowingUser(viewerId, post.userId);
    }
    if (!cache.has(post.userId)) {
      cache.set(post.userId, await isFollowingUser(viewerId, post.userId));
    }
    return cache.get(post.userId) ?? false;
  }
  return false;
}

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
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

    const post = await createPost({
      userId: user.id,
      content: content.trim(),
      imageUrls,
      visibility,
      tags,
      shareToDiary,
    });

    const response = await toPostResponse(post, user.id);
    return NextResponse.json(response, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
