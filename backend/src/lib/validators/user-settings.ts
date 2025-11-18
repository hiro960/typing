import { ERROR } from "@/lib/errors";
import { UserSettings } from "@/lib/types";

export function validateUserSettings(settings: Partial<UserSettings>) {
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
