import { NextRequest, NextResponse } from "next/server";
import { findUserById, getUserStats } from "@/lib/store";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError, ERROR } from "@/lib/errors";
import { UserStatsRange } from "@/lib/types";

const RANGES: UserStatsRange[] = ["weekly", "monthly", "all"];

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    await requireAuthUser(request);
    const { id } = await params;
    const user = await findUserById(id);
    if (!user) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const range = (request.nextUrl.searchParams.get("range") ??
      "weekly") as UserStatsRange;

    if (!RANGES.includes(range)) {
      throw ERROR.INVALID_INPUT("range must be weekly|monthly|all", {
        field: "range",
      });
    }

    const stats = await getUserStats(user.id, range);
    return NextResponse.json(stats);
  } catch (error) {
    return handleRouteError(error);
  }
}
