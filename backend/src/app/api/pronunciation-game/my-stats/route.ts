import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";
import { getPronunciationGameUserStats } from "@/lib/store";

/**
 * GET /api/pronunciation-game/my-stats
 * 自分の統計を取得
 */
export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const stats = await getPronunciationGameUserStats(user.id);
    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
