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
NextAuth.js の JWT セッションをモバイル向けに拡張し、Bearer トークン方式で受け渡す。

### 2.1 モバイルサインインフロー
1. Flutter で各 IdP (Google / Apple / Twitter) の認可コード or ID Token を取得（PKCE 推奨）。
2. `POST /api/auth/signin` に下記ボディを送信。

```json
{
  "provider": "google",
  "code": "authorization_code",
  "codeVerifier": "pkce_verifier",
  "redirectUri": "com.example.app:/oauth"
}
```
- Apple/Twitter でコードが無い場合は `idToken` を指定可能。

3. 成功時レスポンス例:
```json
{
  "accessToken": "jwt",
  "refreshToken": "rjwt",
  "expiresIn": 3600,
  "user": { "id": "usr_123", "displayName": "りな", "learningLevel": "intermediate" }
}
```

### 2.2 リフレッシュ
- `POST /api/auth/refresh`
```json
{ "refreshToken": "rjwt" }
```
- 200 応答 = 新しい `accessToken` と `expiresIn`。
- 401 応答 = トークン失効、再ログイン要求。

### 2.3 セッション取得
- `GET /api/auth/session`
- ヘッダー `Authorization: Bearer <accessToken>` 必須。
- ログインユーザー情報 + 設定値を返却。

### 2.4 サインアウト
- `POST /api/auth/signout`
- リフレッシュトークンを無効化し、サーバー側セッションを破棄。

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
| 422 | `BUSINESS_RULE_VIOLATION` | 同一レッスン短期重複登録など |
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
  "id": "les_1",
  "title": "子音 基礎",
  "level": "beginner",
  "order": 1,
  "description": "基本子音と配列",
  "content": { "blocks": [...] }
}
```

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

### 5.1 /api/auth
| メソッド | パス | 概要 |
| --- | --- | --- |
| POST | `/api/auth/signin` | OAuth コードを JWT に交換 |
| POST | `/api/auth/refresh` | リフレッシュトークン交換 |
| GET | `/api/auth/session` | 現在のユーザー取得 |
| POST | `/api/auth/signout` | サインアウト |

#### POST /api/auth/signin
- Body: 前述 2.1 と同様。
- 成功: 200 + `accessToken`, `refreshToken`, `expiresIn`, `user`。
- エラー: 400 (`INVALID_INPUT`), 401 (`PROVIDER_AUTH_FAILED`), 422 (`BUSINESS_RULE_VIOLATION` - BAN user)。

#### POST /api/auth/refresh
- Body: `{ "refreshToken": string }`
- 成功: 200 + 新 JWT。
- エラー: 401 (`UNAUTHORIZED`), 409 (`TOKEN_REUSED`).

#### GET /api/auth/session
- 成功: 200 + `user: UserDetail`。
- エラー: 401。

#### POST /api/auth/signout
- Body optional (`refreshToken`).
- 成功: 204。

### 5.2 /api/users

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

### 5.3 /api/posts
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

### 5.4 /api/comments/{id}
- DELETE: 自身 or 投稿主のみ削除可能 (204)。

### 5.5 /api/follows
| メソッド | パス | 概要 |
| --- | --- | --- |
| POST | `/api/follows` | 指定ユーザーをフォロー |
| DELETE | `/api/follows/{targetUserId}` | フォロー解除 |
| GET | `/api/follows/followers` | フォロワーリスト |
| GET | `/api/follows/following` | フォロー中リスト |

- POST Body: `{ "userId": "usr_456" }`
- レスポンス: `{ "followerId": "usr_me", "followingId": "usr_456" }`
- GET クエリ: `userId`, `cursor`, `limit`。

### 5.6 /api/lessons
| メソッド | パス |
| --- | --- |
| GET | `/api/lessons` |
| GET | `/api/lessons/{id}` |
| POST | `/api/lessons/complete` |
| GET | `/api/lessons/stats` |

#### GET /api/lessons
- クエリ: `level=beginner|intermediate|advanced`, `cursor`, `limit`, `order=asc|desc`。
- レスポンス: Lesson[]。

#### GET /api/lessons/{id}
- レスポンス: Lesson + `content`。

#### POST /api/lessons/complete
- Body:
```json
{
  "lessonId": "les_1",
  "wpm": 210,
  "accuracy": 0.95,
  "timeSpent": 180,
  "device": "ios",
  "mode": "standard|challenge"
}
```
- 成功: 201 + LessonCompletion。
- 422: 連続登録制限 (同レッスンは 10 分クールダウン)。
- 完了時 Pusher `lesson.completed` を送信。

#### GET /api/lessons/stats
- クエリ: `range=daily|weekly|monthly`, `level?`。
- レスポンス:
```json
{
  "totals": { "lessons": 12, "timeSpent": 5400 },
  "trend": [ { "date": "2024-03-10", "wpmAvg": 205, "accuracyAvg": 0.93 } ],
  "weakCharacters": ["ㅂ", "ㅍ"],
  "recommendedLessons": [ { ...Lesson } ]
}
```

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
