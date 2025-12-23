import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { markAllNotificationsRead } from "@/lib/store";
import { handleRouteError } from "@/lib/errors";

export async function PATCH(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const updatedCount = await markAllNotificationsRead(user.id);
    return NextResponse.json({ updatedCount, unreadCount: 0 });
  } catch (error) {
    return handleRouteError(error);
  }
}
