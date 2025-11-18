import { NextRequest, NextResponse } from "next/server";
import { findUserById, updateUserProfile } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { assertSameUser, requireAuthUser } from "@/lib/auth";
import { validateUserSettings } from "@/lib/validators/user-settings";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await findUserById(id);
    if (!user) {
      throw ERROR.NOT_FOUND("User not found");
    }

    return NextResponse.json(user);
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const authUser = await requireAuthUser(request);
    assertSameUser(authUser.id, id);

    const payload = await request.json();
    const { displayName, bio, settings } = payload;

    if (typeof displayName !== "undefined") {
      if (typeof displayName !== "string" || displayName.trim().length === 0) {
        throw ERROR.INVALID_INPUT("displayName must be non-empty string", {
          field: "displayName",
        });
      }
      if (displayName.length > 40) {
        throw ERROR.INVALID_INPUT("displayName must be <= 40 characters", {
          field: "displayName",
        });
      }
    }

    if (typeof bio !== "undefined" && bio !== null) {
      if (typeof bio !== "string" || bio.length > 280) {
        throw ERROR.INVALID_INPUT("bio must be <= 280 characters", {
          field: "bio",
        });
      }
    }

    if (settings) {
      validateUserSettings(settings);
    }

    const updated = await updateUserProfile(id, {
      displayName,
      bio,
      settings,
    });

    return NextResponse.json(updated);
  } catch (error) {
    return handleRouteError(error);
  }
}
