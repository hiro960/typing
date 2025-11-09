import { NextRequest, NextResponse } from "next/server";
import { findUserById, updateUserProfile } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { LearningLevel, UserSettings } from "@/lib/types";
import { assertSameUser, requireAuthUser } from "@/lib/auth";

const LEVELS: LearningLevel[] = ["beginner", "intermediate", "advanced"];

function validateSettings(settings: Partial<UserSettings>) {
  const booleanKeys: Array<keyof UserSettings> = [
    "soundEnabled",
    "hapticEnabled",
    "strictMode",
  ];
  booleanKeys.forEach((key) => {
    if (
      Object.prototype.hasOwnProperty.call(settings, key) &&
      typeof settings[key] !== "boolean"
    ) {
      throw ERROR.INVALID_INPUT(`${key} must be boolean`, { field: key });
    }
  });

  if (settings.notifications) {
    for (const [name, value] of Object.entries(settings.notifications)) {
      if (typeof value !== "boolean") {
        throw ERROR.INVALID_INPUT(`notifications.${name} must be boolean`, {
          field: `notifications.${name}`,
        });
      }
    }
  }

  if (
    settings.theme &&
    !["light", "dark", "auto"].includes(settings.theme)
  ) {
    throw ERROR.INVALID_INPUT("theme must be light|dark|auto", {
      field: "theme",
    });
  }

  if (
    settings.fontSize &&
    !["small", "medium", "large"].includes(settings.fontSize)
  ) {
    throw ERROR.INVALID_INPUT("fontSize must be small|medium|large", {
      field: "fontSize",
    });
  }

  if (
    settings.language &&
    !["ja", "ko", "en"].includes(settings.language)
  ) {
    throw ERROR.INVALID_INPUT("language must be ja|ko|en", {
      field: "language",
    });
  }

  if (
    settings.profileVisibility &&
    !["public", "followers"].includes(settings.profileVisibility)
  ) {
    throw ERROR.INVALID_INPUT(
      "profileVisibility must be public|followers",
      { field: "profileVisibility" }
    );
  }

  if (
    settings.postDefaultVisibility &&
    !["public", "followers", "private"].includes(
      settings.postDefaultVisibility
    )
  ) {
    throw ERROR.INVALID_INPUT(
      "postDefaultVisibility must be public|followers|private",
      { field: "postDefaultVisibility" }
    );
  }
}

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
    const { displayName, bio, learningLevel, settings } = payload;

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

    if (learningLevel && !LEVELS.includes(learningLevel)) {
      throw ERROR.INVALID_INPUT(
        "learningLevel must be beginner|intermediate|advanced",
        { field: "learningLevel" }
      );
    }

    if (settings) {
      validateSettings(settings);
    }

    const updated = await updateUserProfile(id, {
      displayName,
      bio,
      learningLevel,
      settings,
    });

    return NextResponse.json(updated);
  } catch (error) {
    return handleRouteError(error);
  }
}
