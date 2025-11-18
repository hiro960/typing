import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { listNotificationsForUser } from "@/lib/store";
import { handleRouteError } from "@/lib/errors";
import { parseLimit } from "@/lib/pagination";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const unreadOnly = searchParams.get("unreadOnly") === "true";
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 100);
    const result = await listNotificationsForUser(user.id, {
      cursor,
      unreadOnly,
      limit,
    });
    return NextResponse.json(result);
  } catch (error) {
    return handleRouteError(error);
  }
}
