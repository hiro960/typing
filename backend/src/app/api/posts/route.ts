import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import { toPostResponse, createPost, isFollowingUser } from "@/lib/store";
import { getAuthUser, requireAuthUser } from "@/lib/auth";
import { Visibility } from "@/lib/types";
import prisma from "@/lib/prisma";
import { Prisma } from "@prisma/client";

const VISIBILITIES: Visibility[] = ["public", "followers", "private"];
type FeedBucket = "recommended" | "following" | "latest";

const FEED_ALIASES: Record<string, FeedBucket> = {
  foryou: "recommended",
  recommended: "recommended",
  popular: "recommended",
  following: "following",
  latest: "latest",
};

export async function GET(request: NextRequest) {
  try {
    const viewer = await getAuthUser(request);
    const viewerId = viewer?.id;

    const { searchParams } = request.nextUrl;
    const feedParam = (searchParams.get("feed") ?? "recommended").toLowerCase();
    const feed = FEED_ALIASES[feedParam];
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
    const visibilityParam = searchParams.get("visibility");

    if (!feed) {
      throw ERROR.INVALID_INPUT(
        "feed must be recommended|following|latest (legacy: forYou|following|popular)",
        {
          field: "feed",
        }
      );
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
      const normalized = normalizeHashtag(hashtag);
      if (!normalized) {
        throw ERROR.INVALID_INPUT("Invalid hashtag provided", { field: "hashtag" });
      }
      where.tags = { has: normalized };
    }

    if (visibilityParam) {
      if (!VISIBILITIES.includes(visibilityParam as Visibility)) {
        throw ERROR.INVALID_INPUT("visibility must be public|followers|private", {
          field: "visibility",
        });
      }
      if (visibilityParam === "private") {
        if (!viewerId) {
          throw ERROR.UNAUTHORIZED("Authentication required for private posts");
        }
        if (userId && userId !== viewerId) {
          throw ERROR.FORBIDDEN("Cannot view private posts of other users");
        }
        where.userId = viewerId;
      }
      where.visibility = visibilityParam;
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
    }

    if (feed === "latest") {
      orderBy = [{ createdAt: "desc" }];
    } else if (feed === "recommended") {
      orderBy = [
        { likesCount: "desc" },
        { createdAt: "desc" },
      ];
    }

    const posts =
      (await prisma.post.findMany({
        where,
        include: { user: true, quotedPost: { include: { user: true } } },
        orderBy,
        take: limit + 1,
        ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
      })) ?? [];

    const followCache = new Map<string, boolean>();
    const blockCache = new Map<string, boolean>();
    const visible: typeof posts = [];
    for (const post of posts) {
      if (await canAccessPost(post, viewerId, followCache, blockCache)) {
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
  post: Prisma.PostGetPayload<{ include: { user: true; quotedPost: { include: { user: true } } } }>,
  viewerId?: string,
  followCache?: Map<string, boolean>,
  blockCache?: Map<string, boolean>
) {
  if (await isBlockedFromViewer(post.userId, viewerId, blockCache)) {
    return false;
  }
  if (post.visibility === "public") return true;
  if (!viewerId) return false;
  if (post.userId === viewerId) return true;
  if (post.visibility === "followers") {
    if (!followCache) {
      return isFollowingUser(viewerId, post.userId);
    }
    if (!followCache.has(post.userId)) {
      followCache.set(post.userId, await isFollowingUser(viewerId, post.userId));
    }
    return followCache.get(post.userId) ?? false;
  }
  return false;
}

async function isBlockedFromViewer(
  authorId: string,
  viewerId?: string,
  cache?: Map<string, boolean>
) {
  if (!viewerId) {
    return false;
  }
  if (authorId === viewerId) {
    return false;
  }
  const key = `${authorId}:${viewerId}`;
  if (cache?.has(key)) {
    return cache.get(key) ?? false;
  }
  const blocked = await prisma.block.findFirst({
    where: {
      OR: [
        { blockerId: authorId, blockedId: viewerId },
        { blockerId: viewerId, blockedId: authorId },
      ],
    },
    select: { id: true },
  });
  if (cache) {
    cache.set(key, !!blocked);
  }
  return !!blocked;
}

function normalizeHashtag(tag: string): string | null {
  if (!tag) return null;
  let normalized = tag.trim();
  if (!normalized) return null;
  normalized = normalized.replace(/^#/, "").trim();
  if (!normalized) return null;
  if (/^[a-zA-Z0-9_]+$/.test(normalized)) {
    normalized = normalized.toLowerCase();
  }
  if (normalized.length > 40) {
    normalized = normalized.slice(0, 40);
  }
  return normalized;
}

function normalizeTagsInput(tags: unknown): string[] {
  if (!Array.isArray(tags)) {
    throw ERROR.INVALID_INPUT("tags must be an array", { field: "tags" });
  }
  const normalized = new Set<string>();
  tags.forEach((tag, index) => {
    if (typeof tag !== "string") {
      throw ERROR.INVALID_INPUT("tags must contain strings", {
        field: `tags[${index}]`,
      });
    }
    const value = normalizeHashtag(tag);
    if (!value) {
      return;
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
      quotedPostId: rawQuotedPostId,
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

    const normalizedTags = normalizeTagsInput(tags);

    if (typeof shareToDiary !== "boolean") {
      throw ERROR.INVALID_INPUT("shareToDiary must be boolean", {
        field: "shareToDiary",
      });
    }

    let quotedPostId: string | null = null;
    if (typeof rawQuotedPostId !== "undefined") {
      if (rawQuotedPostId !== null && typeof rawQuotedPostId !== "string") {
        throw ERROR.INVALID_INPUT("quotedPostId must be a string", {
          field: "quotedPostId",
        });
      }
      if (typeof rawQuotedPostId === "string" && rawQuotedPostId.trim().length === 0) {
        throw ERROR.INVALID_INPUT("quotedPostId must not be empty", {
          field: "quotedPostId",
        });
      }
      quotedPostId = rawQuotedPostId ?? null;
    }

    if (quotedPostId) {
      const quoted = await prisma.post.findUnique({
        where: { id: quotedPostId },
        include: { user: true },
      });
      if (!quoted) {
        throw ERROR.NOT_FOUND("Quoted post not found");
      }
      if (quoted.visibility !== "public") {
        throw ERROR.FORBIDDEN("This post cannot be quoted");
      }
      const blocked = await prisma.block.findFirst({
        where: {
          OR: [
            { blockerId: quoted.userId, blockedId: user.id },
            { blockerId: user.id, blockedId: quoted.userId },
          ],
        },
        select: { id: true },
      });
      if (blocked) {
        throw ERROR.FORBIDDEN("You cannot quote this post");
      }
    }

    const post = await createPost({
      userId: user.id,
      content: content.trim(),
      imageUrls,
      visibility,
      tags: normalizedTags,
      shareToDiary,
      quotedPostId,
    });

    const response = await toPostResponse(post, user.id);
    return NextResponse.json(response, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
