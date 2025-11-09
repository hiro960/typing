import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { removeFollow } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const user = await requireAuthUser(request);
    if (!id) {
      throw ERROR.INVALID_INPUT("target user id is required");
    }
    await removeFollow(user.id, id);
    return new Response(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
