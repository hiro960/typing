import { jsonResponse, CACHE_STRATEGIES } from "@/lib/response";

export async function GET() {
  return jsonResponse(
    {
      status: "ok",
      timestamp: new Date().toISOString(),
    },
    { cache: CACHE_STRATEGIES.health }
  );
}
