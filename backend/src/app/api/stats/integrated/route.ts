import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { getIntegratedStats } from "@/lib/store";

/**
 * GET /api/stats/integrated
 * 統合統計を取得（レッスン + ランキングゲーム）
 */
export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const range = request.nextUrl.searchParams.get("range") || "weekly";

    // rangeのバリデーション
    if (!["weekly", "monthly", "all"].includes(range)) {
      return NextResponse.json(
        { error: { code: "INVALID_INPUT", message: "Invalid range parameter" } },
        { status: 400 }
      );
    }

    const stats = await getIntegratedStats(
      user.id,
      range as "weekly" | "monthly" | "all"
    );

    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
