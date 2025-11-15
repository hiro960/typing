import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { recordLessonCompletion } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { DeviceType, LessonMode } from "@/lib/types";

const DEVICES: DeviceType[] = ["ios", "android", "web"];
const MODES: LessonMode[] = ["standard", "challenge"];

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();

    const {
      lessonId,
      wpm,
      accuracy,
      timeSpent,
      device,
      mode,
      mistakeCharacters,
    } = body;

    if (!lessonId || typeof lessonId !== "string") {
      throw ERROR.INVALID_INPUT("lessonId is required", { field: "lessonId" });
    }

    if (typeof wpm !== "number" || wpm <= 0) {
      throw ERROR.INVALID_INPUT("wpm must be positive number", {
        field: "wpm",
      });
    }

    if (typeof accuracy !== "number" || accuracy < 0 || accuracy > 1) {
      throw ERROR.INVALID_INPUT("accuracy must be between 0 and 1", {
        field: "accuracy",
      });
    }

    if (
      typeof timeSpent !== "number" ||
      timeSpent <= 0 ||
      !Number.isInteger(timeSpent)
    ) {
      throw ERROR.INVALID_INPUT("timeSpent must be positive integer", {
        field: "timeSpent",
      });
    }

    if (device && !DEVICES.includes(device)) {
      throw ERROR.INVALID_INPUT("device must be ios|android|web", {
        field: "device",
      });
    }

    if (mode && !MODES.includes(mode)) {
      throw ERROR.INVALID_INPUT("mode must be standard|challenge", {
        field: "mode",
      });
    }

    let normalizedMistakes: Record<string, number> | undefined;
    if (typeof mistakeCharacters !== "undefined") {
      if (
        typeof mistakeCharacters !== "object" ||
        mistakeCharacters === null ||
        Array.isArray(mistakeCharacters)
      ) {
        throw ERROR.INVALID_INPUT("mistakeCharacters must be an object", {
          field: "mistakeCharacters",
        });
      }
      normalizedMistakes = {};
      for (const [char, value] of Object.entries(mistakeCharacters)) {
        if (typeof char !== "string") {
          throw ERROR.INVALID_INPUT("mistakeCharacters keys must be strings", {
            field: "mistakeCharacters",
          });
        }
        if (typeof value !== "number" || value < 0) {
          throw ERROR.INVALID_INPUT(
            "mistakeCharacters values must be positive numbers",
            { field: "mistakeCharacters" }
          );
        }
        normalizedMistakes[char] = Math.round(value);
      }
    }

    const completion = await recordLessonCompletion({
      lessonId,
      userId: user.id,
      wpm,
      accuracy,
      timeSpent,
      device: device ?? "ios",
      mode: mode ?? "standard",
      mistakeCharacters: normalizedMistakes,
    });

    return NextResponse.json(
      {
        ...completion,
        completedAt: completion.completedAt.toISOString(),
      },
      { status: 201 }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
