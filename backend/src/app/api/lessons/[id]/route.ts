import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { getLessonById } from "@/lib/store";
import { handleRouteError, ERROR } from "@/lib/errors";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    await requireAuthUser(request);
    const { id } = await params;
    const lesson = await getLessonById(id);
    if (!lesson) {
      throw ERROR.NOT_FOUND("Lesson not found");
    }
    return NextResponse.json(lesson);
  } catch (error) {
    return handleRouteError(error);
  }
}
