import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { createBlock, listBlocks } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";

export async function GET(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const blocks = await listBlocks(user.id);
    return NextResponse.json({ data: blocks });
  } catch (error) {
    return handleRouteError(error);
  }
}

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();
    if (!body.blockedId || typeof body.blockedId !== "string") {
      throw ERROR.INVALID_INPUT("blockedId is required", { field: "blockedId" });
    }

    const block = await createBlock(user.id, body.blockedId);
    return NextResponse.json(block, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
