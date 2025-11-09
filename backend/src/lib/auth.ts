import { NextRequest } from "next/server";
import { ERROR } from "./errors";
import { findUserById } from "./store";
import { UserDetail } from "./types";

const TOKEN_TO_USER: Record<string, string> = {
  "demo-token-hanako": "usr_hanako",
  "demo-token-genta": "usr_genta",
  "demo-token-mina": "usr_mina",
};

function extractToken(request: NextRequest) {
  const header = request.headers.get("authorization");
  if (!header) return null;
  const [scheme, token] = header.split(" ");
  if (scheme?.toLowerCase() !== "bearer") {
    return null;
  }
  return token ?? null;
}

export function getAuthUser(request: NextRequest): UserDetail | null {
  const token = extractToken(request);
  if (!token) return null;
  const userId = TOKEN_TO_USER[token];
  if (!userId) return null;
  return findUserById(userId) ?? null;
}

export function requireAuthUser(request: NextRequest) {
  const user = getAuthUser(request);
  if (!user) {
    throw ERROR.UNAUTHORIZED("Missing or invalid access token");
  }
  return user;
}

export function assertSameUser(userId: string, targetUserId: string) {
  if (userId !== targetUserId) {
    throw ERROR.FORBIDDEN("You can only manage your own resources");
  }
}
