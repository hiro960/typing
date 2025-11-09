import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { addFollow } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

export async function POST(request: NextRequest) {
  try {
    const user = requireAuthUser(request);
    const body = await request.json();

    if (!body.userId || typeof body.userId !== "string") {
      throw ERROR.INVALID_INPUT("userId is required", { field: "userId" });
    }

    const follow = addFollow(user.id, body.userId);
    return NextResponse.json(
      {
        followerId: follow.followerId,
        followingId: follow.followingId,
        createdAt: follow.createdAt,
      },
      { status: 201 }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
