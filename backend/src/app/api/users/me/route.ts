import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError } from "@/lib/errors";

export async function GET(request: NextRequest) {
  try {
    const user = requireAuthUser(request);
    return NextResponse.json(user);
  } catch (error) {
    return handleRouteError(error);
  }
}
