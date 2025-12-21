import { jsonResponse } from "@/lib/response";

/**
 * アプリバージョン設定
 * 将来的にはDBやConfigから取得する可能性あり
 */
const VERSION_CONFIG = {
  ios: {
    minimumVersion: "1.2.8",
    latestVersion: "1.2.8",
    storeUrl:
      "https://apps.apple.com/jp/app/%E3%83%81%E3%83%A3%E3%83%AC%E3%83%83%E3%82%BF/id6755620321",
  },
  android: {
    minimumVersion: "1.0.0",
    latestVersion: "1.0.0",
    storeUrl:
      "https://play.google.com/store/apps/details?id=app.koreantyping.chaletta",
  },
};

/**
 * アプリバージョン情報を取得
 * GET /api/app-version
 * 認証不要
 */
export async function GET() {
  return jsonResponse(VERSION_CONFIG, {
    cache: "public-short", // 5分キャッシュ
  });
}
