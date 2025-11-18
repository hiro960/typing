import { NextRequest, NextResponse } from "next/server";
import { Prisma } from "@prisma/client";
import prisma from "@/lib/prisma";
import { getAuthUser } from "@/lib/auth";
import { handleRouteError, ERROR } from "@/lib/errors";
import { parseLimit, paginateArray } from "@/lib/pagination";
import { canViewPost, toPostResponse, toUserSummary } from "@/lib/store";
import { PaginatedResult, PostResponse, UserSummary } from "@/lib/types";

function normalizeQuery(value: string) {
  return value.trim();
}

function normalizeHashtag(value: string) {
  const trimmed = value.trim().replace(/^#/, "");
  if (!trimmed) {
    return null;
  }
  if (/^[a-zA-Z0-9_]+$/.test(trimmed)) {
    return trimmed.toLowerCase();
  }
  return trimmed;
}

async function searchPosts(
  viewerId: string | undefined,
  query: string,
  limit: number,
  cursor?: string | null
): Promise<PaginatedResult<PostResponse>> {
  const fetchLimit = Math.min(limit * 5 + 20, 200);
  const normalizedHashtag = normalizeHashtag(query);
  const where: Prisma.PostWhereInput = {
    OR: [
      { content: { contains: query, mode: "insensitive" } },
      ...(normalizedHashtag
        ? [{ tags: { has: normalizedHashtag } } as Prisma.PostWhereInput]
        : []),
    ],
  };

  if (!viewerId) {
    where.visibility = "public";
  }

  const candidates = await prisma.post.findMany({
    where,
    include: { user: true, quotedPost: { include: { user: true } } },
    orderBy: { createdAt: "desc" },
    take: fetchLimit,
    ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
  });

  const visible: typeof candidates = [];
  for (const post of candidates) {
    if (await canViewPost(post, viewerId)) {
      visible.push(post);
      if (visible.length >= limit + 1) {
        break;
      }
    }
  }

  const hasNextPage = visible.length > limit;
  const nodes = hasNextPage ? visible.slice(0, limit) : visible;
  const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;
  const data = await Promise.all(
    nodes.map((post) => toPostResponse(post, viewerId))
  );

  return {
    data,
    pageInfo: {
      nextCursor,
      hasNextPage,
      count: data.length,
    },
  };
}

async function searchUsers(
  viewerId: string | undefined,
  query: string,
  limit: number,
  cursor?: string | null
) {
  const fetchLimit = Math.min(limit * 4 + 10, 200);
  const results = await prisma.user.findMany({
    where: {
      OR: [
        { username: { contains: query, mode: "insensitive" } },
        { displayName: { contains: query, mode: "insensitive" } },
      ],
    },
    orderBy: { followersCount: "desc" },
    take: fetchLimit,
    ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
  });

  const visible: UserSummary[] = [];
  for (const candidate of results) {
    if (await prisma.block.findFirst({
      where: {
        OR: [
          { blockerId: candidate.id, blockedId: viewerId },
          { blockerId: viewerId ?? "", blockedId: candidate.id },
        ],
      },
      select: { id: true },
    })) {
      continue;
    }
    visible.push(toUserSummary(candidate));
    if (visible.length >= limit + 1) {
      break;
    }
  }

  const hasNextPage = visible.length > limit;
  const data = hasNextPage ? visible.slice(0, limit) : visible;
  const nextCursor = hasNextPage ? data[data.length - 1]?.id ?? null : null;

  return {
    data,
    pageInfo: {
      nextCursor,
      hasNextPage,
      count: data.length,
    },
  };
}

async function searchHashtags(
  query: string,
  limit: number,
  cursor?: string | null
) {
  const normalized = normalizeHashtag(query);
  const filter =
    normalized && normalized.length > 0
      ? Prisma.sql`WHERE LOWER(tag) LIKE ${`%${normalized.toLowerCase()}%`}`
      : Prisma.empty;

  const rows = await prisma.$queryRaw<
    { tag: string; usage: bigint }[]
  >(Prisma.sql`
    SELECT tag, COUNT(*)::bigint AS usage
    FROM (
      SELECT UNNEST("tags") AS tag
      FROM "Post"
      WHERE "visibility" = 'public'
    ) tags
    ${filter}
    GROUP BY tag
    ORDER BY usage DESC, tag ASC
  `);

  const data = rows.map((row) => ({
    tag: row.tag,
    usage: Number(row.usage),
  }));

  const paginated = paginateArray(data, {
    cursor,
    limit,
    getCursor: (item) => item.tag,
  });

  return {
    data: paginated.data,
    pageInfo: paginated.pageInfo,
  };
}

export async function GET(request: NextRequest) {
  try {
    const viewer = await getAuthUser(request);
    const { searchParams } = request.nextUrl;
    const q = normalizeQuery(searchParams.get("q") ?? "");
    if (!q) {
      throw ERROR.INVALID_INPUT("q is required", { field: "q" });
    }
    const type = (searchParams.get("type") ?? "posts").toLowerCase();
    const cursor = searchParams.get("cursor");
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 50);

    if (type === "users") {
      const result = await searchUsers(viewer?.id, q, limit, cursor);
      return NextResponse.json(result);
    }
    if (type === "hashtags") {
      const result = await searchHashtags(q, limit, cursor);
      return NextResponse.json(result);
    }
    const result = await searchPosts(viewer?.id, q, limit, cursor);
    return NextResponse.json(result);
  } catch (error) {
    return handleRouteError(error);
  }
}
