import { NextRequest } from "next/server";
import { jwtVerify, createRemoteJWKSet, JWTPayload } from "jose";
import { ERROR } from "./errors";
import { findUserByAuth0Id } from "./store";
import { UserDetail } from "./types";

// Auth0のJWKSエンドポイント（公開鍵取得用）
if (!process.env.AUTH0_ISSUER_BASE_URL) {
  throw new Error("AUTH0_ISSUER_BASE_URL environment variable is required");
}

// issuerの末尾スラッシュを正規化（Auth0は常に末尾スラッシュ付きでissを返す）
const normalizeIssuer = (url: string): string => {
  return url.endsWith('/') ? url : `${url}/`;
};

const AUTH0_ISSUER = normalizeIssuer(process.env.AUTH0_ISSUER_BASE_URL);
const JWKS_URL = `${AUTH0_ISSUER}.well-known/jwks.json`;
const JWKS = createRemoteJWKSet(new URL(JWKS_URL));

/**
 * Auth0のJWTトークンを検証してペイロードを取得
 *
 * 注意: このバックエンドは標準的なJWT (JWS形式) のみを受け付けます。
 * Auth0でJWEトークン（暗号化されたOpaque Token）が発行される場合は、
 * Auth0の設定でAPI Audienceを指定してください。
 *
 * @throws {ApiError} トークンが無効または期限切れの場合
 */
async function verifyAuth0Token(request: NextRequest): Promise<JWTPayload> {
  const authHeader = request.headers.get("authorization");

  if (!authHeader?.startsWith("Bearer ")) {
    throw ERROR.UNAUTHORIZED("Missing or invalid authorization header");
  }

  const token = authHeader.substring(7);

  // JWTは3パート (header.payload.signature) であるべき
  const tokenParts = token.split('.').length;
  if (tokenParts !== 3) {
    console.error(
      `[AUTH ERROR] Invalid token format: expected 3 parts (JWT), got ${tokenParts} parts.`
    );
    console.error(
      `[AUTH ERROR] Token preview: ${token.substring(0, 50)}...`
    );
    console.error(
      `[AUTH ERROR] If you are receiving a 5-part JWE token (encrypted), you need to:
      1. Create an API in Auth0 Dashboard (Applications -> APIs -> Create API)
      2. Set the API Identifier (e.g., https://your-api.example.com)
      3. Configure AUTH0_AUDIENCE in backend .env file
      4. Configure AUTH0_AUDIENCE in Flutter .env file
      5. Restart both backend and Flutter app`
    );
    throw ERROR.UNAUTHORIZED("Invalid token format. This API requires JWT tokens with an audience.");
  }

  try {
    // issuerは必須（末尾スラッシュ付きで検証）
    const verifyOptions: any = {
      issuer: AUTH0_ISSUER,
    };

    // audienceが設定されている場合は検証に含める
    // 注意: Auth0の管理API (/api/v2/) をaudienceにしている場合は検証をスキップ
    if (process.env.AUTH0_AUDIENCE && !process.env.AUTH0_AUDIENCE.includes('/api/v2/')) {
      verifyOptions.audience = process.env.AUTH0_AUDIENCE;
      console.log(`[AUTH] Verifying token with audience: ${process.env.AUTH0_AUDIENCE}`);
    } else {
      console.log(`[AUTH] Verifying token without audience (AUTH0_AUDIENCE not set or is management API)`);
    }

    const { payload } = await jwtVerify(token, JWKS, verifyOptions);

    console.log(`[AUTH] Token verified successfully. Sub: ${payload.sub}`);
    return payload;
  } catch (error) {
    console.error("[AUTH ERROR] JWT verification failed:", error);

    if (error instanceof Error) {
      console.error(`[AUTH ERROR] Error name: ${error.name}`);
      console.error(`[AUTH ERROR] Error message: ${error.message}`);

      // JWTのエラータイプに応じて詳細なメッセージを返す
      if (error.name === "JWTExpired") {
        throw ERROR.UNAUTHORIZED("Token has expired");
      }
      if (error.name === "JWTClaimValidationFailed") {
        console.error(`[AUTH ERROR] Token claims validation failed. Check if:
        - AUTH0_ISSUER_BASE_URL matches the token issuer (current: ${AUTH0_ISSUER})
        - AUTH0_AUDIENCE matches the token audience (current: ${process.env.AUTH0_AUDIENCE || 'not set'})`);
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
