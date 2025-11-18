import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { updateUserProfile } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { validateUserSettings } from "@/lib/validators/user-settings";
import { UserSettings } from "@/lib/types";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    return NextResponse.json(user.settings);
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function PATCH(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const payload = (await request.json()) as Partial<UserSettings>;
    if (!payload || typeof payload !== "object") {
      throw ERROR.INVALID_INPUT("Invalid settings payload");
    }
    validateUserSettings(payload);
    const updated = await updateUserProfile(user.id, { settings: payload });
    return NextResponse.json(updated.settings);
  } catch (error) {
    return handleRouteError(error);
  }
}
