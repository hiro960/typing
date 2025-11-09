import { NextRequest, NextResponse } from "next/server";
import { getLessonById } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

export async function GET(
  _request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const lesson = getLessonById(params.id);
    if (!lesson) {
      throw ERROR.NOT_FOUND("Lesson not found");
    }
    return NextResponse.json(lesson);
  } catch (error) {
    return handleRouteError(error);
  }
}
