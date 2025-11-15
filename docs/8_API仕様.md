# API仕様書

Flutterクライアントと Next.js バックエンド間の REST API 仕様。docs/3_バックエンドアーキテクチャ.md のエンドポイント群をベースに、入出力・ステータスコード・ページング・エラー形式を定義する。

## 1. 基本情報
- **ベースURL**
  - 本番: `https://api.example.com`
  - ステージング: `https://stg-api.example.com`
  - ローカル: `http://localhost:3000`
- **プロトコル**: HTTPS 必須（HSTS 有効化）
- **コンテンツタイプ**: `application/json; charset=utf-8`
- **文字コード**: UTF-8（サロゲートペア含む）
- **日付形式**: ISO 8601（UTC、例: `2024-03-01T12:34:56.789Z`）

## 2. 認証・認可
Auth0 Universal Login を認証基盤とする。**モバイルアプリ（iOS/Android）はAuth0と直接通信**し、Authorization Code + PKCE フローでトークンを取得する。取得したアクセストークンをREST APIのBearerトークンとして利用する。

### 2.1 モバイルアプリ認証フロー
**モバイルアプリはバックエンドを経由せず、Auth0と直接通信します。**

#### サインインフロー
1. `auth0_flutter` の `webAuthorize()` を呼び出し、Auth0 Hosted Login Page（Google/Apple/Xボタン付き）へ遷移
2. ユーザーが認証プロバイダーを選択し認証完了
3. **Auth0と直接通信**してトークンを取得：
   - SDK が Authorization Code + PKCE を使って Auth0 `/oauth/token` エンドポイントに直接交換
   - 資格情報を `CredentialsManager` に自動保存

取得されるトークン例:
```json
{
  "accessToken": "eyJhbGciOi...",
  "idToken": "eyJraWQiOi...",
  "refreshToken": "rt_Lf...",
  "expiresIn": 3600,
  "tokenType": "Bearer",
  "scope": "openid profile email offline_access"
}
```

4. Next.js API呼び出し時に `Authorization: Bearer <accessToken>` をヘッダーに付与

#### トークンリフレッシュ
**Auth0に直接リクエスト**します。バックエンドのエンドポイントは不要です。

```dart
// Flutter側の実装例
final credentials = await credentialsManager.credentials();
// 内部的に以下をAuth0に直接リクエスト:
// POST https://{tenant}.auth0.com/oauth/token
// {
//   "grant_type": "refresh_token",
//   "client_id": "AUTH0_CLIENT_ID",
//   "refresh_token": "rt_Lf..."
// }
```

- 401/400 が返却された場合、SDKが自動的に資格情報を破棄し、再ログインフローへ誘導

#### ログアウト
**Auth0のエンドセッションエンドポイントに直接アクセス**します。

```dart
await auth0.webAuthentication().logout();
// 内部的にAuth0のエンドセッションエンドポイントへリダイレクト
```

### 2.2 API 認可ヘッダー（バックエンドAPI保護）
Next.js APIは、モバイルアプリから送信されたアクセストークンを検証します。

#### 必須ヘッダー
```http
Authorization: Bearer <accessToken>
```

#### 検証内容
Next.js APIは以下を検証します：
- `iss`: Auth0テナント (`https://{tenant}.auth0.com/`)
- `aud`: API識別子 (`https://api.korean-typing.app`)
- `sub`: Auth0ユーザーID → Users テーブルの `auth0UserId` と突合
- `exp`: トークン有効期限
- 署名: Auth0 JWKSをキャッシュして検証

#### スコープ設計
- `openid profile email offline_access`: 基本スコープ
- 将来的な拡張: `read:posts`, `write:posts`, `read:lessons`, `write:stats`

#### エラーレスポンス
無効・期限切れトークンの場合：
```json
HTTP 401 UNAUTHORIZED
{
  "error": {
    "code": "TOKEN_EXPIRED",
    "message": "Access token has expired"
  }
}
```

## 3. 共通仕様

### 3.1 リクエストヘッダー
| ヘッダー | 必須 | 説明 |
| --- | --- | --- |
| `Authorization` | 認証必要エンドポイントで必須 | `Bearer <accessToken>` |
| `X-Client-Version` | 任意 | Flutter アプリの SemVer。AB テスト判定に使用 |
| `X-Platform` | 任意 | `ios`/`android` |

### 3.2 ページング
- Cursor ベース: `?cursor=<opaque>&limit=20` (1〜100)。
- レスポンス例:
```json
{
  "data": [ ... ],
  "pageInfo": {
    "nextCursor": "opaque",
    "hasNextPage": true,
    "count": 20
  }
}
```
- 並び順
  - 投稿: `sort=latest`(デフォルト) / `popular`
  - レッスン: `order=asc|desc`（`orderBy` と併用不可）

### 3.3 エラー形式
```json
{
  "error": {
    "code": "INVALID_INPUT",
    "message": "level must be beginner|intermediate|advanced",
    "details": { "field": "level" }
  }
}
```
- HTTP ステータスとアプリコードをセットで扱う。

| HTTP | code | 説明 |
| --- | --- | --- |
| 400 | `INVALID_INPUT` | バリデーションエラー |
| 401 | `UNAUTHORIZED` | トークン欠如 or 失効 |
| 403 | `FORBIDDEN` | 権限不足 (他ユーザー編集など) |
| 404 | `NOT_FOUND` | リソース無し |
| 409 | `CONFLICT` | 重複フォロー / いいねなど |
| 422 | `BUSINESS_RULE_VIOLATION` | ビジネスルール違反（現在は予約、将来拡張用） |
| 429 | `RATE_LIMITED` | Upstash レートリミット超過 |
| 500 | `INTERNAL_ERROR` | 想定外エラー |

### 3.4 並列制御
- 変更系 API には `Idempotency-Key` ヘッダー (UUID) を許容し、多重送信を防止。
- Pusher イベント名: `post.created`, `post.liked`, `follow.added`, `lesson.completed`。Payload は該当モデルと `timestamp`。

## 4. モデル定義

### 4.1 UserSummary
```json
{
  "id": "usr_123",
  "username": "hanako",
  "displayName": "花子",
  "profileImageUrl": "https://...",
  "learningLevel": "beginner",
  "followersCount": 120,
  "followingCount": 45,
  "postsCount": 58,
  "settings": null
}
```

### 4.2 UserDetail (= Summary + 下記)
```json
{
  "bio": "韓ドラ好き",
  "maxWPM": 220,
  "maxAccuracy": 0.97,
  "totalLessonsCompleted": 42,
  "totalPracticeTime": 3600,
  "settings": {
    "theme": "auto",
    "language": "ja",
    "soundEnabled": true,
    "hapticEnabled": true,
    "strictMode": true,
    "notifications": { "push": true, "comment": true, "like": true, "follow": true, "email": false },
    "profileVisibility": "public",
    "postDefaultVisibility": "public",
    "fontSize": "medium"
  }
}
```

### 4.3 Post
```json
{
  "id": "post_123",
  "content": "오늘은 한국 드라마를 봤어요",
  "imageUrls": ["https://blob.vercel.com/..."],
  "visibility": "public",
  "user": { ...UserSummary },
  "likesCount": 12,
  "commentsCount": 3,
  "liked": true,
  "bookmarked": false,
  "createdAt": "2024-03-10T12:00:00Z",
  "updatedAt": "2024-03-10T12:00:00Z"
}
```

### 4.4 Comment
```json
{
  "id": "cmt_1",
  "content": "저도 보고 싶어요!",
  "postId": "post_123",
  "user": { ...UserSummary },
  "likesCount": 1,
  "createdAt": "2024-03-10T12:05:00Z"
}
```

### 4.5 Lesson
```json
{
  "id": "les_beginner_001",
  "title": "基本の子音 ㄱ, ㄴ, ㄷ",
  "level": "beginner",
  "order": 1,
  "description": "韓国語の基本子音3つを学びます。",
  "assetPath": "assets/lessons/beginner_001.json",
  "assetVersion": 3,
  "estimatedMinutes": 12,
  "createdAt": "2024-03-01T00:00:00Z",
  "updatedAt": "2024-03-01T00:00:00Z"
}
```

- `assetPath` / `assetVersion`: モバイルクライアントに同梱された JSON アセットを指し示すメタデータ。本文コンテンツの変更は JSON 側で管理し、API では配信しない。
- `estimatedMinutes`: レッスンの想定学習時間。XP や報酬値は保持しない。
- 学習アイテムの構造は `docs/11_タイピング機能の詳細.md`（セクション2）を参照。

**注意**: モバイルアプリではレッスンデータはアプリ内にJSON形式で同梱されます。APIから取得するのは以下の場合のみ:
- 新規レッスンの追加時
- レッスン内容の更新時
- 将来的なコンテンツ配信機能の実装時

### 4.6 LessonCompletion
```json
{
  "id": "lc_1",
  "lessonId": "les_1",
  "userId": "usr_123",
  "accuracy": 0.92,
  "wpm": 210,
  "timeSpent": 180,
  "completedAt": "2024-03-11T00:00:00Z"
}
```

## 5. エンドポイント詳細

### 5.1 /api/users

#### GET /api/users
- クエリ: `q`, `level` (`beginner|intermediate|advanced`), `cursor`, `limit`。
- レスポンス: `data: UserSummary[]` + `pageInfo`。

#### GET /api/users/{id}
- 成功: 200 + `UserDetail`。
- 404: 存在しない。

#### GET /api/users/me
- トークンベースの省略エンドポイント。

#### PUT /api/users/{id}
- Body: `displayName`, `bio`, `learningLevel`, `settings` 部分更新。
- 権限: 自分のみ。
- 成功: 200 + 更新済み `UserDetail`。

#### GET /api/users/{id}/stats
- クエリ: `range=weekly|monthly|all`。
- レスポンス例:
```json
{
  "wpmAvg": 210,
  "accuracyAvg": 0.94,
  "lessonsCompleted": 12,
  "streakDays": 5,
  "histories": [ { "date": "2024-03-10", "wpm": 215, "accuracy": 0.96 } ]
}
```

#### GET /api/users/{id}/posts
- クエリ: `cursor`, `limit`, `visibility` (self only)。
- レスポンス: Post のページング。

### 5.2 /api/posts
| メソッド | パス | 概要 |
| --- | --- | --- |
| GET | `/api/posts` | タイムライン取得 |
| POST | `/api/posts` | 新規投稿 |
| GET | `/api/posts/{id}` | 投稿詳細 |
| PUT | `/api/posts/{id}` | 投稿更新 |
| DELETE | `/api/posts/{id}` | 投稿削除 |
| POST | `/api/posts/{id}/like` | いいね |
| DELETE | `/api/posts/{id}/like` | いいね解除 |
| GET | `/api/posts/{id}/comments` | コメント一覧 |
| POST | `/api/posts/{id}/comments` | コメント作成 |

#### GET /api/posts
- クエリ:
  - `feed`: `forYou`(デフォルト)、`following`、`popular`
  - `cursor`, `limit`
  - `hashtag`, `userId`
- レスポンス: Post[] + `pageInfo`。
- リアルタイム: `post.created` Pusher イベント を合わせて購読。

#### POST /api/posts
- Body:
```json
{
  "content": "오늘...",
  "imageUrls": ["https://blob..."],
  "visibility": "public|followers|private",
  "tags": ["#推し活"],
  "shareToDiary": true
}
```
- バリデーション: content 1〜280 文字、画像最大4枚。
- 成功: 201 + Post。

#### POST /api/posts/{id}/like
- 成功: 200 + `{ "likesCount": 13, "liked": true }`
- 409: 既にいいね済み。

#### GET /api/posts/{id}/comments
- `cursor`, `limit` 対応。
- レスポンス: Comment[] + `pageInfo`。

#### POST /api/posts/{id}/comments
- Body: `{ "content": "좋아요" }`
- 成功: 201 + Comment。

### 5.3 /api/comments/{id}
- DELETE: 自身 or 投稿主のみ削除可能 (204)。

### 5.4 /api/follows
| メソッド | パス | 概要 |
| --- | --- | --- |
| POST | `/api/follows` | 指定ユーザーをフォロー |
| DELETE | `/api/follows/{targetUserId}` | フォロー解除 |
| GET | `/api/follows/followers` | フォロワーリスト |
| GET | `/api/follows/following` | フォロー中リスト |

- POST Body: `{ "userId": "usr_456" }`
- レスポンス: `{ "followerId": "usr_me", "followingId": "usr_456" }`
- GET クエリ: `userId`, `cursor`, `limit`。

### 5.5 /api/lessons
| メソッド | パス |
| --- | --- |
| GET | `/api/lessons` |
| GET | `/api/lessons/{id}` |
| POST | `/api/lessons/complete` |
| GET | `/api/lessons/stats` |

#### GET /api/lessons
- クエリ: `level=beginner|intermediate|advanced`, `cursor`, `limit`, `order=asc|desc`。
- レスポンス: Lesson[]（`content`フィールドは含まれない、メタデータのみ）。
- 使用目的: レッスン一覧の表示、レッスン選択UI
- 注意: モバイルアプリでは通常、アプリ内に同梱されたJSONを使用するため、このエンドポイントは主にコンテンツ更新時に使用

#### GET /api/lessons/{id}
- レスポンス: Lessonメタデータのみ（タイトル、レベル、順序、アセット情報など）。
- 使用目的: バックエンドのメタデータ整合性チェックや運営ツール向け。
- **本文コンテンツは返さない**。モバイルアプリは常にアプリ内 JSON を参照する。

#### POST /api/lessons/complete
- Body:
```json
{
  "lessonId": "les_beginner_001",
  "wpm": 48,
  "accuracy": 0.95,
  "timeSpent": 332000,
  "device": "ios",
  "mode": "standard",
  "mistakeCharacters": { "ㅂ": 2, "ㅈ": 1 }
}
```
- **フィールド説明**:
  - `lessonId`: レッスンID（必須）
  - `wpm`: Words Per Minute（必須、正の整数）韓国語では1文字=1単語として計算
  - `accuracy`: 正解率（必須、0.0〜1.0）小数点2桁まで
  - `timeSpent`: 所要時間（必須、ミリ秒単位の正の整数）
  - `device`: デバイスタイプ（任意、`ios` | `android` | `web`。省略時は`ios`）
  - `mode`: プレイモード（任意、`standard` | `challenge`。省略時は`standard`）
  - `mistakeCharacters`: 誤入力した文字の出現回数マップ（任意、例: `{ "ㅂ": 2 }`）
- **バリデーション**:
  - `wpm > 0`
  - `0.0 <= accuracy <= 1.0`
  - `timeSpent > 0`
  - `device in ['ios', 'android', 'web']`
  - `mode in ['standard', 'challenge']`
- **成功**: 201 Created + LessonCompletion オブジェクト
- **エラー**:
  - 400: バリデーションエラー（不正な値）
  - 404: レッスンが存在しない
- **リアルタイム通知**: 完了時に Pusher `lesson.completed` イベントを送信（フォロワーのフィードに表示）
- **備考**: 同一レッスンでもクールダウン無しで連続送信できる。再挑戦ごとに即座にAPIへ送信する。

#### GET /api/lessons/stats
- クエリ: `range=daily|weekly|monthly|all`, `level?`。
- レスポンス:
```json
{
  "totals": { "lessons": 12, "timeSpent": 5400 },
  "trend": [ { "date": "2024-03-10", "wpmAvg": 205, "accuracyAvg": 0.93 } ],
  "weakCharacters": ["ㅂ", "ㅍ"],
  "recommendedLessons": [ { ...Lesson } ]
}
```
- `weakCharacters`: `mistakeCharacters` で送信された履歴から、出現頻度の高い文字上位3件を返す。

## 6. ステータスコード/イベント対応
- 作成: 201 (Location ヘッダーでリソース URL)
- 更新: 200 or 204
- 削除: 204
- 非同期通知は Pusher 経由で発火。

## 7. セキュリティ/レートリミット
- レートリミット: `60 rpm`/アクセストークン (認証) / `20 rpm` (匿名)。Upstash Redis を使用 (`docs/3` の `rateLimit`).
- CSRF: 認証済み POST には `SameSite=Lax` Cookie + JWT チェック。モバイルは Bearer のみ。
- 入力検証: Zod スキーマでサーバー側バリデーション。エラー時 400。

## 8. 今後の拡張
- `/api/notifications` エンドポイント（未実装）: Pusher と整合する永続化層を設計予定。
- `/api/posts/search` の全文検索 (Neon + pg_trgm) 追加を検討。
