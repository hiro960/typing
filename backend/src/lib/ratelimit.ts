import { Ratelimit } from "@upstash/ratelimit";
import { kv } from "@vercel/kv";

export const ratelimit = {
    post: new Ratelimit({
        redis: kv,
        limiter: Ratelimit.slidingWindow(3, "1 m"),
        analytics: true,
        prefix: "@upstash/ratelimit",
    }),
    comment: new Ratelimit({
        redis: kv,
        limiter: Ratelimit.slidingWindow(10, "1 m"),
        analytics: true,
        prefix: "@upstash/ratelimit",
    }),
    like: new Ratelimit({
        redis: kv,
        limiter: Ratelimit.slidingWindow(30, "1 m"),
        analytics: true,
        prefix: "@upstash/ratelimit",
    }),
    follow: new Ratelimit({
        redis: kv,
        limiter: Ratelimit.slidingWindow(5, "1 m"),
        analytics: true,
        prefix: "@upstash/ratelimit",
    }),
};
