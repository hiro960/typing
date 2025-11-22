import { NextRequest, NextResponse } from "next/server";
import { findUserById, updateUserProfile } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";
import { assertSameUser, requireAuthUser } from "@/lib/auth";
import { validateUserSettings } from "@/lib/validators/user-settings";

import prisma from "@/lib/prisma";
import { getAuthUser } from "@/lib/auth";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await findUserById(id);
    if (!user) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const authUser = await getAuthUser(request);
    let isFollowing = false;

    if (authUser) {
      const follow = await prisma.follow.findUnique({
        where: {
          followerId_followingId: {
            followerId: authUser.id,
            followingId: id,
          },
        },
      });
      isFollowing = !!follow;
    }

    return NextResponse.json({ ...user, isFollowing });
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
    const { displayName, bio, settings, profileImageUrl } = payload;

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

    if (typeof profileImageUrl !== "undefined") {
      if (profileImageUrl !== null && typeof profileImageUrl !== "string") {
        throw ERROR.INVALID_INPUT("profileImageUrl must be string or null", {
          field: "profileImageUrl",
        });
      }
      if (typeof profileImageUrl === "string" && profileImageUrl.trim().length === 0) {
        throw ERROR.INVALID_INPUT("profileImageUrl must be non-empty", {
          field: "profileImageUrl",
        });
      }
    }

    const updated = await updateUserProfile(id, {
      displayName,
      bio,
      settings,
      profileImageUrl: typeof profileImageUrl === "undefined" ? undefined : profileImageUrl ?? null,
    });

    return NextResponse.json(updated);
  } catch (error) {
    return handleRouteError(error);
  }
}
