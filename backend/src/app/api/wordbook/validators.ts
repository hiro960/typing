import { WordCategory as PrismaWordCategory, WordStatus as PrismaWordStatus } from "@prisma/client";
import { ERROR } from "@/lib/errors";

export const WORD_MAX_LENGTH = 100;
export const MEANING_MAX_LENGTH = 200;
export const EXAMPLE_MAX_LENGTH = 500;
export const TAG_MAX_LENGTH = 20;
export const TAG_MAX_COUNT = 10;

export const CATEGORY_VALUES = new Set<string>(Object.values(PrismaWordCategory));
export const STATUS_VALUES = new Set<string>(Object.values(PrismaWordStatus));

export type CreatePayload = {
  word: string;
  meaning: string;
  example: string | null;
  category: PrismaWordCategory;
  status: PrismaWordStatus;
  tags: string[];
};

export type UpdatePayload = Partial<CreatePayload> & {
  lastReviewedAt?: Date | null;
  reviewCount?: number;
  successRate?: number;
};

export function validateCreatePayload(
  body: unknown
): { valid: boolean; errors: Record<string, string>; value: CreatePayload } {
  const errors: Record<string, string> = {};
  const source = (body ?? {}) as Record<string, unknown>;

  const word = pickWord(source.word, errors);
  const meaning = pickMeaning(source.meaning, errors);
  const example = pickExample(source.example, errors);
  const category = pickCategory(source.category, errors);
  const status = pickStatus(source.status, errors);
  const tags = pickTags(source.tags, errors);

  return {
    valid: Object.keys(errors).length === 0,
    errors,
    value: {
      word,
      meaning,
      example,
      category,
      status,
      tags,
    },
  };
}

export function validateUpdatePayload(
  body: unknown
): { valid: boolean; errors: Record<string, string>; value: UpdatePayload } {
  const errors: Record<string, string> = {};
  const source = (body ?? {}) as Record<string, unknown>;
  const value: UpdatePayload = {};

  if (source.word !== undefined) {
    value.word = pickWord(source.word, errors);
  }
  if (source.meaning !== undefined) {
    value.meaning = pickMeaning(source.meaning, errors);
  }
  if (source.example !== undefined) {
    value.example = pickExample(source.example, errors);
  }
  if (source.category !== undefined) {
    value.category = pickCategory(source.category, errors);
  }
  if (source.status !== undefined) {
    value.status = pickStatus(source.status, errors);
  }
  if (source.tags !== undefined) {
    value.tags = pickTags(source.tags, errors);
  }
  if (source.reviewCount !== undefined) {
    const reviewCount = Number(source.reviewCount);
    if (!Number.isInteger(reviewCount) || reviewCount < 0) {
      errors.reviewCount = "reviewCount must be an integer >= 0";
    } else {
      value.reviewCount = reviewCount;
    }
  }
  if (source.successRate !== undefined) {
    const successRate = Number(source.successRate);
    if (Number.isNaN(successRate) || successRate < 0 || successRate > 1) {
      errors.successRate = "successRate must be between 0 and 1";
    } else {
      value.successRate = successRate;
    }
  }
  if (source.lastReviewedAt !== undefined) {
    if (source.lastReviewedAt === null) {
      value.lastReviewedAt = null;
    } else if (typeof source.lastReviewedAt === "string") {
      const parsed = new Date(source.lastReviewedAt);
      if (Number.isNaN(parsed.getTime())) {
        errors.lastReviewedAt = "lastReviewedAt must be ISO string";
      } else {
        value.lastReviewedAt = parsed;
      }
    } else {
      errors.lastReviewedAt = "lastReviewedAt must be ISO string or null";
    }
  }

  return {
    valid: Object.keys(errors).length === 0,
    errors,
    value,
  };
}

function pickWord(input: unknown, errors: Record<string, string>) {
  const word = typeof input === "string" ? input.trim() : "";
  if (!word) {
    errors.word = "word is required";
  } else if (word.length > WORD_MAX_LENGTH) {
    errors.word = `word must be <= ${WORD_MAX_LENGTH} characters`;
  }
  return word;
}

function pickMeaning(input: unknown, errors: Record<string, string>) {
  const meaning = typeof input === "string" ? input.trim() : "";
  if (!meaning) {
    errors.meaning = "meaning is required";
  } else if (meaning.length > MEANING_MAX_LENGTH) {
    errors.meaning = `meaning must be <= ${MEANING_MAX_LENGTH} characters`;
  }
  return meaning;
}

function pickExample(input: unknown, errors: Record<string, string>) {
  if (input === undefined || input === null) {
    return null;
  }
  if (typeof input !== "string") {
    errors.example = "example must be a string";
    return null;
  }
  const example = input.trim();
  if (example.length > EXAMPLE_MAX_LENGTH) {
    errors.example = `example must be <= ${EXAMPLE_MAX_LENGTH} characters`;
    return null;
  }
  return example.length > 0 ? example : null;
}

function pickCategory(input: unknown, errors: Record<string, string>) {
  const category = normalizeEnum(input);
  if (!category) {
    errors.category = "category is required";
    return "WORDS";
  }
  if (!CATEGORY_VALUES.has(category)) {
    errors.category = "invalid category";
    return "WORDS";
  }
  return category as PrismaWordCategory;
}

function pickStatus(input: unknown, errors: Record<string, string>) {
  const status = normalizeEnum(input);
  if (!status) {
    errors.status = "status is required";
    return "REVIEWING";
  }
  if (!STATUS_VALUES.has(status)) {
    errors.status = "invalid status";
    return "REVIEWING";
  }
  return status as PrismaWordStatus;
}

function pickTags(input: unknown, errors: Record<string, string>) {
  if (input === undefined) {
    return [];
  }
  if (!Array.isArray(input)) {
    errors.tags = "tags must be an array";
    return [];
  }
  if (input.length > TAG_MAX_COUNT) {
    errors.tags = `tags must be <= ${TAG_MAX_COUNT} items`;
    return [];
  }

  const tags: string[] = [];
  for (let i = 0; i < input.length; i += 1) {
    const tag = input[i];
    if (typeof tag !== "string") {
      errors.tags = "tags must contain strings";
      return [];
    }
    const normalized = tag.trim();
    if (normalized.length === 0) {
      continue;
    }
    if (normalized.length > TAG_MAX_LENGTH) {
      errors.tags = `tag \"${normalized}\" is too long`;
      return [];
    }
    if (!tags.includes(normalized)) {
      tags.push(normalized);
    }
  }
  return tags;
}

export function normalizeEnum(value: unknown): string | undefined {
  if (typeof value !== "string") {
    return undefined;
  }
  return value.trim().toUpperCase();
}

export function assertEnum(value: string, options: Set<string>, field: string) {
  if (!options.has(value)) {
    throw ERROR.INVALID_INPUT(`Invalid ${field}`, { field });
  }
}

export function parsePagination(limitParam: string | null, offsetParam: string | null) {
  if (limitParam === null && offsetParam === null) {
    return { paginated: false, limit: 0, offset: 0 };
  }

  const limit = limitParam !== null ? Number.parseInt(limitParam, 10) : 50;
  if (!Number.isFinite(limit) || limit <= 0 || limit > 200) {
    throw ERROR.INVALID_INPUT("limit must be between 1 and 200", { field: "limit" });
  }

  const offset = offsetParam !== null ? Number.parseInt(offsetParam, 10) : 0;
  if (!Number.isFinite(offset) || offset < 0) {
    throw ERROR.INVALID_INPUT("offset must be >= 0", { field: "offset" });
  }

  return { paginated: true, limit, offset };
}
