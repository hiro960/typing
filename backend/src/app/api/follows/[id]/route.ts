import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { removeFollow } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const user = requireAuthUser(request);
    if (!params.id) {
      throw ERROR.INVALID_INPUT("target user id is required");
    }
    removeFollow(user.id, params.id);
    return new Response(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
