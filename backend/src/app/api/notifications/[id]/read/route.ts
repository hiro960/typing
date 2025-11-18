import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { markNotificationRead } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    if (!id) {
      throw ERROR.INVALID_INPUT("Notification id is required");
    }
    const user = await requireAuthUser(request);
    const notification = await markNotificationRead(user.id, id);
    return NextResponse.json(notification);
  } catch (error) {
    return handleRouteError(error);
  }
}
