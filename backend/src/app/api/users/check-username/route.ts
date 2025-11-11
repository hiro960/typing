import { NextRequest, NextResponse } from "next/server";
import { checkUsernameAvailability } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

/**
 * GET /api/users/check-username?username=xxx
 * Username可用性のリアルタイムチェック
 *
 * @requires 認証不要（公開エンドポイント）
 */
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const username = searchParams.get("username");

    // バリデーション
    if (!username) {
      throw ERROR.INVALID_INPUT("Username is required");
    }

    // usernameのフォーマットチェック（3〜20文字、英数字とアンダースコアのみ）
    const usernameRegex = /^[a-zA-Z0-9_]{3,20}$/;
    if (!usernameRegex.test(username)) {
      throw ERROR.INVALID_INPUT(
        "Username must be 3-20 characters and contain only letters, numbers, and underscores"
      );
    }

    // 可用性チェック
    const available = await checkUsernameAvailability(username);

    return NextResponse.json({ available }, { status: 200 });
  } catch (error) {
    return handleRouteError(error);
  }
}
