import { NextRequest, NextResponse } from "next/server";
import { Prisma } from "@prisma/client";
import { requireAuthUser } from "@/lib/auth";
import { ERROR, handleRouteError } from "@/lib/errors";
import prisma from "@/lib/prisma";
import { toWordbookEntry } from "@/lib/store";
import { validateUpdatePayload } from "../validators";

type RouteParams = {
  params: Promise<{
    id: string;
  }>;
};

export async function PUT(request: NextRequest, ctx: RouteParams) {
  try {
    const user = await requireAuthUser(request);
    const payload = await readJson(request);
    const validation = validateUpdatePayload(payload);
    if (!validation.valid) {
      throw ERROR.INVALID_INPUT("Validation failed", { fields: validation.errors });
    }

    if (Object.keys(validation.value).length === 0) {
      throw ERROR.INVALID_INPUT("No fields to update");
    }

    const { id } = await ctx.params;
    const existing = await prisma.wordbook.findUnique({ where: { id } });
    if (!existing || existing.userId !== user.id) {
      throw ERROR.NOT_FOUND("Word not found");
    }

    const needsDuplicateCheck =
      hasProp(validation.value, "word") || hasProp(validation.value, "category");
    if (needsDuplicateCheck) {
      const nextWord = validation.value.word ?? existing.word;
      const nextCategory = validation.value.category ?? existing.category;
      const duplicate = await prisma.wordbook.findFirst({
        where: {
          userId: user.id,
          category: nextCategory,
          word: { equals: nextWord, mode: "insensitive" },
          NOT: { id: existing.id },
        },
      });
      if (duplicate) {
        throw ERROR.CONFLICT("Word already registered", { field: "word" });
      }
    }

    const data: Prisma.WordbookUpdateInput = {};
    if (hasProp(validation.value, "word")) {
      data.word = validation.value.word!;
    }
    if (hasProp(validation.value, "meaning")) {
      data.meaning = validation.value.meaning!;
    }
    if (hasProp(validation.value, "example")) {
      data.example = validation.value.example ?? null;
    }
    if (hasProp(validation.value, "category")) {
      data.category = validation.value.category!;
    }
    if (hasProp(validation.value, "status")) {
      data.status = validation.value.status!;
    }
    if (hasProp(validation.value, "tags")) {
      data.tags = validation.value.tags ?? [];
    }
    if (hasProp(validation.value, "reviewCount")) {
      data.reviewCount = validation.value.reviewCount!;
    }
    if (hasProp(validation.value, "successRate")) {
      data.successRate = validation.value.successRate!;
    }
    if (hasProp(validation.value, "lastReviewedAt")) {
      data.lastReviewedAt = validation.value.lastReviewedAt ?? null;
    }

    if (Object.keys(data).length === 0) {
      throw ERROR.INVALID_INPUT("No valid fields to update");
    }

    const updated = await prisma.wordbook.update({
      where: { id: existing.id },
      data,
    });

    return NextResponse.json(toWordbookEntry(updated));
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function DELETE(request: NextRequest, ctx: RouteParams) {
  try {
    const user = await requireAuthUser(request);
    const { id } = await ctx.params;
    const existing = await prisma.wordbook.findUnique({ where: { id } });
    if (!existing || existing.userId !== user.id) {
      throw ERROR.NOT_FOUND("Word not found");
    }

    await prisma.wordbook.delete({ where: { id: existing.id } });
    return NextResponse.json({ message: "Word deleted successfully" });
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

function hasProp<T extends object>(input: T, key: keyof T) {
  return Object.prototype.hasOwnProperty.call(input, key);
}
