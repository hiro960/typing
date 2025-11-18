import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { updateUserPushToken } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

export async function PUT(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();
    if (!body.fcmToken || typeof body.fcmToken !== "string") {
      throw ERROR.INVALID_INPUT("fcmToken is required", { field: "fcmToken" });
    }
    const updated = await updateUserPushToken(user.id, body.fcmToken);
    return NextResponse.json({
      success: true,
      fcmToken: updated.fcmToken,
    });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    await updateUserPushToken(user.id, null);
    return NextResponse.json({ success: true });
  } catch (error) {
    return handleRouteError(error);
  }
}
