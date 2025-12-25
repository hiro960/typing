import { Ratelimit } from "@upstash/ratelimit";
import { kv } from "@vercel/kv";

// KV環境変数が設定されているかチェック
const isKvConfigured = !!(process.env.KV_REST_API_URL && process.env.KV_REST_API_TOKEN);

// KVが未設定の場合はレート制限をスキップするダミー実装
const createRatelimiter = (limiter: ReturnType<typeof Ratelimit.slidingWindow>) => {
    if (!isKvConfigured) {
        console.warn("[RATELIMIT] KV not configured, rate limiting disabled");
        return {
            limit: async (_identifier: string) => ({
                success: true,
                limit: 0,
                remaining: 0,
                reset: 0,
            }),
        };
    }
    return new Ratelimit({
        redis: kv,
        limiter,
        analytics: true,
        prefix: "@upstash/ratelimit",
    });
};

export const ratelimit = {
    post: createRatelimiter(Ratelimit.slidingWindow(3, "1 m")),
    comment: createRatelimiter(Ratelimit.slidingWindow(10, "1 m")),
    like: createRatelimiter(Ratelimit.slidingWindow(30, "1 m")),
    follow: createRatelimiter(Ratelimit.slidingWindow(5, "1 m")),
    tts: createRatelimiter(Ratelimit.slidingWindow(30, "1 m")),
};
