import { NextRequest, NextResponse } from "next/server";
import sharp from "sharp";
import { requireAuthUser } from "@/lib/auth";
import { handleRouteError, ERROR } from "@/lib/errors";
import { uploadOptimizedImage } from "@/lib/storage";

const MAX_FILE_SIZE = 8 * 1024 * 1024; // 8MB

export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);
    const formData = await request.formData();
    const file = formData.get("file");
    const type = (formData.get("type") as string) ?? "post";

    if (!(file instanceof File)) {
      throw ERROR.INVALID_INPUT("file is required");
    }
    if (!file.type?.startsWith("image/")) {
      throw ERROR.INVALID_INPUT("Only image uploads are supported", {
        field: "file",
      });
    }

    const arrayBuffer = await file.arrayBuffer();
    if (arrayBuffer.byteLength > MAX_FILE_SIZE) {
      throw ERROR.INVALID_INPUT("Image must be <= 8MB", { field: "file" });
    }

    const isProfile = type === "profile";
    const transformer = sharp(Buffer.from(arrayBuffer)).rotate();
    if (isProfile) {
      transformer.resize(512, 512, { fit: "cover" });
    } else {
      transformer.resize({
        width: 2048,
        height: 2048,
        fit: "inside",
        withoutEnlargement: true,
      });
    }
    const optimized = await transformer.webp({ quality: 85 }).toBuffer();
    const metadata = await sharp(optimized).metadata();

    const blob = await uploadOptimizedImage({
      buffer: optimized,
      filenamePrefix: `${type}s/${user.id}/${Date.now()}`,
      contentType: "image/webp",
    });

    return NextResponse.json(
      {
        url: blob.url,
        width: metadata.width ?? null,
        height: metadata.height ?? null,
        size: optimized.length,
        contentType: "image/webp",
      },
      { status: 201 }
    );
  } catch (error) {
    return handleRouteError(error);
  }
}
