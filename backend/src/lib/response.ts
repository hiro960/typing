import { NextResponse } from "next/server";

/**
 * Cache-Control戦略
 * - no-store: キャッシュしない（リアルタイム性が重要なデータ）
 * - no-cache: キャッシュするが毎回サーバーに確認（古いデータを防ぐ）
 * - private-no-store: ユーザー固有データ、キャッシュしない
 * - public-short: 公開データ、5分キャッシュ（変更頻度低いデータ）
 */
type CacheStrategy = "no-store" | "no-cache" | "private-no-store" | "public-short";

const CACHE_HEADERS: Record<CacheStrategy, string> = {
  "no-store": "no-store, no-cache, must-revalidate",
  "no-cache": "no-cache, must-revalidate",
  "private-no-store": "private, no-store, no-cache, must-revalidate",
  "public-short": "public, max-age=300, must-revalidate",
};

/**
 * Cache-Controlヘッダー付きのJSONレスポンスを返す
 */
export function jsonResponse<T>(
  data: T,
  options: { status?: number; cache?: CacheStrategy } = {}
): NextResponse<T> {
  const { status = 200, cache = "no-store" } = options;

  return NextResponse.json(data, {
    status,
    headers: {
      "Cache-Control": CACHE_HEADERS[cache],
    },
  });
}

/**
 * 各APIエンドポイント用の推奨キャッシュ設定
 */
export const CACHE_STRATEGIES = {
  // リアルタイム性が重要
  notifications: "no-store" as const,

  // ユーザー固有データ
  bookmarks: "private-no-store" as const,
  posts: "no-cache" as const,

  // 変更頻度が低い公開データ
  lessons: "public-short" as const,

  // ヘルスチェック
  health: "no-cache" as const,
} as const;
