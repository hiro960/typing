import { NextRequest } from "next/server";
import { jwtVerify, createRemoteJWKSet, JWTPayload } from "jose";
import { ERROR } from "./errors";
import { findUserByAuth0Id } from "./store";
import { UserDetail } from "./types";

// Auth0のJWKSエンドポイント（公開鍵取得用）
// 環境変数が未設定の場合はダミーURLを使用（開発環境でのエラー回避）
const JWKS_URL = process.env.AUTH0_ISSUER_BASE_URL
  ? `${process.env.AUTH0_ISSUER_BASE_URL}/.well-known/jwks.json`
  : "https://dummy.auth0.com/.well-known/jwks.json";

const JWKS = createRemoteJWKSet(new URL(JWKS_URL));

/**
 * Auth0のJWTトークンを検証してペイロードを取得
 * @throws {ApiError} トークンが無効または期限切れの場合
 */
async function verifyAuth0Token(request: NextRequest): Promise<JWTPayload> {
  const authHeader = request.headers.get("authorization");

  if (!authHeader?.startsWith("Bearer ")) {
    throw ERROR.UNAUTHORIZED("Missing or invalid authorization header");
  }

  const token = authHeader.substring(7);

  try {
    const { payload } = await jwtVerify(token, JWKS, {
      issuer: process.env.AUTH0_ISSUER_BASE_URL,
      audience: process.env.AUTH0_AUDIENCE,
    });

    return payload;
  } catch (error) {
    console.error("JWT verification failed:", error);

    if (error instanceof Error) {
      // JWTのエラータイプに応じて詳細なメッセージを返す
      if (error.name === "JWTExpired") {
        throw ERROR.UNAUTHORIZED("Token has expired");
      }
      if (error.name === "JWTClaimValidationFailed") {
        throw ERROR.UNAUTHORIZED("Invalid token claims");
      }
    }

    throw ERROR.UNAUTHORIZED("Invalid or expired token");
  }
}

/**
 * 認証必須のエンドポイントで使用
 * DBに登録済みのユーザーを返す
 * @throws {ApiError} トークンが無効またはユーザーが未登録の場合
 */
export async function requireAuthUser(request: NextRequest): Promise<UserDetail> {
  const payload = await verifyAuth0Token(request);
  const auth0UserId = payload.sub as string;

  if (!auth0UserId) {
    throw ERROR.UNAUTHORIZED("Invalid token: missing sub claim");
  }

  const user = await findUserByAuth0Id(auth0UserId);
  if (!user) {
    throw ERROR.UNAUTHORIZED("User not registered. Please complete setup.");
  }

  return user;
}

/**
 * 認証オプショナルのエンドポイントで使用
 * トークンが有効でもDBに未登録の場合はnullを返す
 */
export async function getAuthUser(request: NextRequest): Promise<UserDetail | null> {
  try {
    return await requireAuthUser(request);
  } catch {
    return null;
  }
}

/**
 * Auth0ペイロードのみ取得（初回登録用）
 * DBに未登録でもエラーを出さない
 * @throws {ApiError} トークンが無効な場合のみ
 */
export async function getAuth0Payload(request: NextRequest): Promise<JWTPayload> {
  return await verifyAuth0Token(request);
}

/**
 * ユーザーIDの権限チェック
 * @throws {ApiError} ユーザーIDが一致しない場合
 */
export function assertSameUser(userId: string, targetUserId: string): void {
  if (userId !== targetUserId) {
    throw ERROR.FORBIDDEN("You can only manage your own resources");
  }
}
