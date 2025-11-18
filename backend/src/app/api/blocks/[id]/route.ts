import { NextRequest } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { removeBlock } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    if (!id) {
      throw ERROR.INVALID_INPUT("Block id is required");
    }
    const user = await requireAuthUser(request);
    await removeBlock(id, user.id);
    return new Response(null, { status: 204 });
  } catch (error) {
    return handleRouteError(error);
  }
}
