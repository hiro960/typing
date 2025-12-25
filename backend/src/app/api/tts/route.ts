import { NextRequest, NextResponse } from "next/server";
import { handleRouteError, ERROR } from "@/lib/errors";
import { requireAuthUser } from "@/lib/auth";
import { ratelimit } from "@/lib/ratelimit";
import { google } from "googleapis";

// Google Cloud TTS の音声設定
const TTS_CONFIG = {
  languageCode: "ko-KR",
  // Neural2 voice for high-quality Korean pronunciation
  name: "ko-KR-Neural2-A",
  ssmlGender: "FEMALE" as const,
};

// キャッシュ用のMapを作成（同じテキストの再リクエストを防ぐ）
const audioCache = new Map<string, { audio: string; timestamp: number }>();
const CACHE_TTL_MS = 60 * 60 * 1000; // 1時間

/**
 * Google Cloud TTS APIの認証を取得
 */
function getGoogleAuth() {
  // 環境変数からサービスアカウントのJSONを取得
  const credentials = process.env.GOOGLE_SERVICE_ACCOUNT_JSON;
  if (!credentials) {
    throw new Error("GOOGLE_SERVICE_ACCOUNT_JSON environment variable is required");
  }

  const serviceAccount = JSON.parse(credentials);

  return new google.auth.GoogleAuth({
    credentials: serviceAccount,
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });
}

/**
 * 古いキャッシュエントリをクリーンアップ
 */
function cleanupCache() {
  const now = Date.now();
  for (const [key, value] of audioCache.entries()) {
    if (now - value.timestamp > CACHE_TTL_MS) {
      audioCache.delete(key);
    }
  }
}

/**
 * POST /api/tts
 * テキストを音声に変換（有料会員限定）
 */
export async function POST(request: NextRequest) {
  try {
    const user = await requireAuthUser(request);

    // 有料会員チェック（PREMIUM または OFFICIAL のみ）
    const userType = user.type.toUpperCase();
    if (userType !== "PREMIUM" && userType !== "OFFICIAL") {
      throw ERROR.FORBIDDEN("この機能は有料会員限定です");
    }

    // レートリミット（1分間に30回まで）
    if (process.env.NODE_ENV === "production") {
      const { success } = await ratelimit.tts.limit(user.id);
      if (!success) {
        throw ERROR.TOO_MANY_REQUESTS("Rate limit exceeded. Please try again later.");
      }
    }

    const body = await request.json();
    const { text } = body;

    // バリデーション
    if (typeof text !== "string" || text.trim().length === 0) {
      throw ERROR.INVALID_INPUT("text is required", { field: "text" });
    }

    if (text.length > 200) {
      throw ERROR.INVALID_INPUT("text must be <= 200 characters", { field: "text" });
    }

    const normalizedText = text.trim();

    // キャッシュチェック
    cleanupCache();
    const cacheKey = normalizedText;
    const cached = audioCache.get(cacheKey);
    if (cached) {
      return NextResponse.json({ audioContent: cached.audio });
    }

    // Google Cloud TTS API呼び出し
    const auth = getGoogleAuth();
    const tts = google.texttospeech({ version: "v1", auth });

    const response = await tts.text.synthesize({
      requestBody: {
        input: { text: normalizedText },
        voice: {
          languageCode: TTS_CONFIG.languageCode,
          name: TTS_CONFIG.name,
          ssmlGender: TTS_CONFIG.ssmlGender,
        },
        audioConfig: {
          audioEncoding: "MP3",
          speakingRate: 0.9, // 少しゆっくりめ（学習用）
          pitch: 0,
        },
      },
    });

    const audioContent = response.data.audioContent as string;

    if (!audioContent) {
      throw new Error("No audio content returned from TTS API");
    }

    // キャッシュに保存
    audioCache.set(cacheKey, {
      audio: audioContent,
      timestamp: Date.now(),
    });

    return NextResponse.json({ audioContent });
  } catch (error) {
    return handleRouteError(error);
  }
}
