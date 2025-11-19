import crypto from "crypto";
import { del, put } from "@vercel/blob";

const BLOB_TOKEN = process.env.BLOB_READ_WRITE_TOKEN;
const BLOB_BASE_URL = process.env.BLOB_PUBLIC_BASE_URL;

export function isBlobConfigured() {
  return Boolean(BLOB_TOKEN);
}

function normalizeBaseUrl() {
  if (BLOB_BASE_URL) {
    return BLOB_BASE_URL.endsWith("/")
      ? BLOB_BASE_URL
      : `${BLOB_BASE_URL}/`;
  }
  return null;
}

const normalizedBaseUrl = normalizeBaseUrl();

export function isManagedBlobUrl(url: string) {
  if (!url) return false;
  if (normalizedBaseUrl) {
    return url.startsWith(normalizedBaseUrl);
  }
  return url.includes(".blob.vercel-storage.com");
}

export async function deleteManagedBlobs(urls: string[]) {
  if (!BLOB_TOKEN) {
    console.warn(
      "[storage] BLOB_READ_WRITE_TOKEN is not configured. Skipping blob deletion."
    );
    return;
  }

  const targets = urls.filter(isManagedBlobUrl);
  if (targets.length === 0) {
    return;
  }

  await Promise.allSettled(
    targets.map((url) =>
      del(url, {
        token: BLOB_TOKEN,
      }).catch((error) => {
        console.error("[storage] Failed to delete blob", url, error);
      })
    )
  );
}

export async function uploadOptimizedImage(options: {
  buffer: Buffer;
  contentType: string;
  filenamePrefix: string;
  access?: "public";
}) {
  if (!BLOB_TOKEN) {
    throw new Error("BLOB_READ_WRITE_TOKEN is not configured");
  }

  const filename = `${options.filenamePrefix}-${crypto.randomUUID()}.webp`;
  const result = await put(filename, options.buffer, {
    access: options.access ?? "public",
    token: BLOB_TOKEN,
    contentType: options.contentType,
  });

  return result;
}
