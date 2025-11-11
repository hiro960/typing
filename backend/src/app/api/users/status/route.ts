import { NextRequest, NextResponse } from "next/server";
import { getAuth0Payload } from "@/lib/auth";
import { findUserByAuth0Id } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

/**
 * GET /api/users/status
 * 現在のユーザーの登録状況確認
 *
 * @requires Auth0 JWT（認証必須）
 */
export async function GET(request: NextRequest) {
  try {
    // JWT検証（Auth0ペイロード取得）
    const payload = await getAuth0Payload(request);
    const auth0UserId = payload.sub as string;

    if (!auth0UserId) {
      throw ERROR.UNAUTHORIZED("Invalid token: missing sub claim");
    }

    // ユーザー検索
    const user = await findUserByAuth0Id(auth0UserId);

    if (user) {
      // 登録済み
      return NextResponse.json(
        {
          registered: true,
          user,
        },
        { status: 200 }
      );
    } else {
      // 未登録
      return NextResponse.json(
        {
          registered: false,
        },
        { status: 200 }
      );
    }
  } catch (error) {
    return handleRouteError(error);
  }
}
