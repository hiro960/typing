import { NextResponse } from "next/server";
import { ErrorPayload } from "./types";

export class ApiError extends Error {
  constructor(
    public status: number,
    public code: string,
    message: string,
    public details?: Record<string, unknown> | null
  ) {
    super(message);
  }
}

export const ERROR = {
  INVALID_INPUT: (message: string, details?: Record<string, unknown>) =>
    new ApiError(400, "INVALID_INPUT", message, details),
  UNAUTHORIZED: (message = "Unauthorized") =>
    new ApiError(401, "UNAUTHORIZED", message),
  FORBIDDEN: (message = "Forbidden") =>
    new ApiError(403, "FORBIDDEN", message),
  NOT_FOUND: (message = "Not found") =>
    new ApiError(404, "NOT_FOUND", message),
  CONFLICT: (message: string, details?: Record<string, unknown>) =>
    new ApiError(409, "CONFLICT", message, details),
  UNPROCESSABLE: (message: string) =>
    new ApiError(422, "BUSINESS_RULE_VIOLATION", message),
};

export function createErrorPayload(error: ApiError): ErrorPayload {
  return {
    error: {
      code: error.code,
      message: error.message,
      details: error.details ?? null,
    },
  };
}

export function handleRouteError(error: unknown) {
  if (error instanceof ApiError) {
    return NextResponse.json(createErrorPayload(error), {
      status: error.status,
    });
  }

  console.error("Unexpected API error", error);
  const fallback: ErrorPayload = {
    error: {
      code: "INTERNAL_ERROR",
      message: "An unexpected error occurred",
    },
  };
  return NextResponse.json(fallback, { status: 500 });
}
