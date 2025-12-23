import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { listNotificationsForUser, getUnreadNotificationCount } from "@/lib/store";
import { handleRouteError } from "@/lib/errors";
import { parseLimit } from "@/lib/pagination";
import { jsonResponse, CACHE_STRATEGIES } from "@/lib/response";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const { searchParams } = request.nextUrl;
    const cursor = searchParams.get("cursor");
    const unreadOnly = searchParams.get("unreadOnly") === "true";
    const limit = parseLimit(searchParams.get("limit"), 20, 1, 100);
    const [result, unreadCount] = await Promise.all([
      listNotificationsForUser(user.id, {
        cursor,
        unreadOnly,
        limit,
      }),
      getUnreadNotificationCount(user.id),
    ]);
    return jsonResponse({ ...result, unreadCount }, { cache: CACHE_STRATEGIES.notifications });
  } catch (error) {
    return handleRouteError(error);
  }
}
