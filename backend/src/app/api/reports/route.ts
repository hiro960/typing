import { NextRequest, NextResponse } from "next/server";
import { requireAuthUser } from "@/lib/auth";
import { createReport } from "@/lib/store";
import { ERROR, handleRouteError } from "@/lib/errors";
import { ReportReason, ReportType } from "@/lib/types";

const REPORT_TYPES: ReportType[] = ["POST", "COMMENT", "USER"];
const REPORT_REASONS: ReportReason[] = [
  "SPAM",
  "HARASSMENT",
  "INAPPROPRIATE_CONTENT",
  "HATE_SPEECH",
  "OTHER",
];

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const body = await request.json();

    if (!REPORT_TYPES.includes(body.type)) {
      throw ERROR.INVALID_INPUT("Invalid report type", { field: "type" });
    }
    if (!REPORT_REASONS.includes(body.reason)) {
      throw ERROR.INVALID_INPUT("Invalid report reason", { field: "reason" });
    }
    if (!body.targetId || typeof body.targetId !== "string") {
      throw ERROR.INVALID_INPUT("targetId is required", { field: "targetId" });
    }
    if (
      typeof body.description !== "undefined" &&
      body.description !== null &&
      (typeof body.description !== "string" || body.description.length > 500)
    ) {
      throw ERROR.INVALID_INPUT("description must be <=500 characters", {
        field: "description",
      });
    }

    const report = await createReport({
      reporterId: user.id,
      type: body.type,
      reason: body.reason,
      targetId: body.targetId,
      description: body.description,
    });

    return NextResponse.json(report, { status: 201 });
  } catch (error) {
    return handleRouteError(error);
  }
}
