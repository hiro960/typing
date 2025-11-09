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

export async function getAuthUser(request: NextRequest): Promise<UserDetail | null> {
  const token = extractToken(request);
  if (!token) return null;
  const userId = TOKEN_TO_USER[token];
  if (!userId) return null;
  const user = await findUserById(userId);
  return user ?? null;
}

export async function requireAuthUser(request: NextRequest) {
  const user = await getAuthUser(request);
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
