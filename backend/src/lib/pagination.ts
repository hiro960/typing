import { PageInfo } from "./types";

export function parseLimit(
  value: string | null,
  defaultValue = 20,
  min = 1,
  max = 100
) {
  if (!value) return defaultValue;
  const parsed = Number.parseInt(value, 10);
  if (Number.isNaN(parsed)) {
    return defaultValue;
  }
  return Math.min(Math.max(parsed, min), max);
}

export function paginateArray<T>(
  items: T[],
  options: { cursor?: string | null; limit?: number; getCursor: (item: T) => string }
) {
  const { cursor, limit = 20, getCursor } = options;
  let startIndex = 0;

  if (cursor) {
    const index = items.findIndex((item) => getCursor(item) === cursor);
    if (index >= 0) {
      startIndex = index + 1;
    }
  }

  const slice = items.slice(startIndex, startIndex + limit);
  const reachedEnd = startIndex + limit >= items.length;
  const pageInfo: PageInfo = {
    nextCursor:
      slice.length > 0 && !reachedEnd
        ? getCursor(slice[slice.length - 1])
        : null,
    hasNextPage: !reachedEnd && slice.length > 0,
    count: slice.length,
  };

  return {
    data: slice,
    pageInfo,
  };
}
