import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { getPronunciationGameUserStatsSummary } from "@/lib/store";

/**
 * GET /api/pronunciation-game/my-stats/summary
 * 自分の統計を取得（軽量版・ホーム画面用）
 */
export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const stats = await getPronunciationGameUserStatsSummary(user.id);
    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
