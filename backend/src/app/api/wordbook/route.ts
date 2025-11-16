import { NextRequest, NextResponse } from "next/server";
import { WordCategory as PrismaWordCategory } from "@prisma/client";
import { requireAuthUser } from "@/lib/auth";
import { ERROR, handleRouteError } from "@/lib/errors";
import prisma from "@/lib/prisma";
import { toWordbookEntry } from "@/lib/store";
import {
  CATEGORY_VALUES,
  STATUS_VALUES,
  assertEnum,
  normalizeEnum,
  parsePagination,
  validateCreatePayload,
} from "./validators";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;

    const where: Record<string, unknown> = { userId: user.id };

    const categoryParam = normalizeEnum(searchParams.get("category"));
    if (categoryParam) {
      assertEnum(categoryParam, CATEGORY_VALUES, "category");
      where.category = categoryParam;
    }

    const statusParam = normalizeEnum(searchParams.get("status"));
    if (statusParam) {
      assertEnum(statusParam, STATUS_VALUES, "status");
      where.status = statusParam;
    }

    const { limit, offset, paginated } = parsePagination(searchParams.get("limit"), searchParams.get("offset"));

    const [words, total] = await Promise.all([
      prisma.wordbook.findMany({
        where,
        orderBy: { createdAt: "desc" },
        ...(paginated ? { skip: offset, take: limit } : {}),
      }),
      prisma.wordbook.count({ where }),
    ]);

    const data = words.map(toWordbookEntry);

    if (paginated) {
      return NextResponse.json({
        data,
        pagination: {
          total,
          limit,
          offset,
        },
      });
    }

    return NextResponse.json({ data, total });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const payload = await readJson(request);
    const validation = validateCreatePayload(payload);
    if (!validation.valid) {
      throw ERROR.INVALID_INPUT("Validation failed", { fields: validation.errors });
    }

    const { word, meaning, example, category, status, tags } = validation.value;

    const duplicate = await prisma.wordbook.findFirst({
      where: {
        userId: user.id,
        category,
        word: {
          equals: word,
          mode: "insensitive",
        },
      },
    });
    if (duplicate) {
      throw ERROR.CONFLICT("Word already registered", { field: "word" });
    }

    const created = await prisma.wordbook.create({
      data: {
        userId: user.id,
        word,
        meaning,
        example,
        category,
        status,
        tags,
      },
    });

    return NextResponse.json(toWordbookEntry(created), { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}

async function readJson(request: NextRequest) {
  try {
    return await request.json();
  } catch {
    throw ERROR.INVALID_INPUT("Invalid JSON payload");
  }
}
