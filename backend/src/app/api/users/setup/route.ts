import { NextRequest, NextResponse } from "next/server";
import { getAuth0Payload } from "@/lib/auth";
import { createUserFromAuth0 } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

/**
 * POST /api/users/setup
 * 初回ユーザー登録（Auth0認証後）
 *
 * @requires Auth0 JWT（認証必須、ただしDB未登録でもOK）
 */
export async function POST(request: NextRequest) {
  try {
    // JWT検証（Auth0ペイロード取得）
    const payload = await getAuth0Payload(request);
    console.log("[USER_SETUP] Auth0 payload received:", { sub: payload.sub, email: payload.email });

    const auth0UserId = payload.sub as string;
    const email = payload.email as string | undefined; // Twitter等ではemailがない場合がある

    if (!auth0UserId) {
      console.error("[USER_SETUP] Missing sub claim in token");
      throw ERROR.UNAUTHORIZED("Invalid token: missing sub claim");
    }

    console.log("[USER_SETUP] Token validated, auth0UserId:", auth0UserId, "email:", email ?? "(not provided)");

    // リクエストボディのパース
    const body = await request.json();
    console.log("[USER_SETUP] Request body:", body);
    const { username, displayName, bio, profileImageUrl } = body;

    // バリデーション
    if (!username || typeof username !== "string") {
      console.error("[USER_SETUP] Invalid username:", username);
      throw ERROR.INVALID_INPUT("Username is required");
    }

    if (!displayName || typeof displayName !== "string") {
      console.error("[USER_SETUP] Invalid displayName:", displayName);
      throw ERROR.INVALID_INPUT("Display name is required");
    }

    // usernameのフォーマットチェック（3〜20文字、英数字とアンダースコアのみ）
    const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
    if (!usernameRegex.test(username)) {
      throw ERROR.INVALID_INPUT(
        "Username must be 3-20 characters and contain only letters, numbers, and underscores"
      );
    }

    // displayNameの長さチェック（1〜50文字）
    if (displayName.length < 1 || displayName.length > 50) {
      throw ERROR.INVALID_INPUT("Display name must be 1-50 characters");
    }

    // bioの長さチェック（最大160文字）
    if (bio && typeof bio === "string" && bio.length > 160) {
      throw ERROR.INVALID_INPUT("Bio must be 160 characters or less");
    }

    // ユーザー作成
    console.log("[USER_SETUP] Creating user with params:", {
      auth0UserId,
      username,
      displayName,
      email,
      bio: bio || undefined,
    });

    const user = await createUserFromAuth0({
      auth0UserId,
      username,
      displayName,
      email,
      bio: bio || undefined,
      profileImageUrl: profileImageUrl || undefined,
    });

    console.log("[USER_SETUP] User created successfully:", user.id);
    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    console.error("[USER_SETUP] Error occurred:", error);
    return handleRouteError(error);
  }
}
