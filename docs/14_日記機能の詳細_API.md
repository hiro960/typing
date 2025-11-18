# 日記機能 - API設計

> **Note**: このドキュメントは日記機能のAPI設計を記載しています。
> 機能仕様は [機能仕様](./14_日記機能の詳細_機能.md) を、
> データモデル設計は [DB設計](./14_日記機能の詳細_DB.md) を、
> UI/UX設計は [UI/UX設計](./14_日記機能の詳細_UI.md) を参照してください。

---

## API設計

### 既存エンドポイント（実装済み）

#### GET /api/posts
**投稿一覧の取得（フィード）**

**Query Parameters**:
- `feed`: `recommended` | `following` | `latest` （デフォルト: `recommended`）
  - `recommended`: スコアベースのおすすめ投稿
  - `following`: フォロー中のユーザーの投稿
  - `latest`: 時系列で全ての投稿
- `cursor`: ページネーションカーソル
- `limit`: 取得件数（1-100、デフォルト20）
- `hashtag`: ハッシュタグフィルター（#なしで指定、例: `korean`）
- `userId`: 特定ユーザーの投稿のみ
- `visibility`: 下書き取得用（`private`を指定すると自分の下書きのみ取得、認証必須）

**アクセス制御とフィルタリング**:
- **下書き（`visibility=private`）**:
  - `visibility=private` を指定した場合、自分の下書き投稿のみ取得可能
  - それ以外の場合、下書きは結果に含まれない
- **フォロワー限定投稿（`visibility=followers`）**:
  - 投稿者本人は自分の投稿を閲覧可能
  - 投稿者のフォロワーは閲覧可能
  - 非フォロワーには結果から**除外**（403や404ではなく、結果に含めない）
- **ブロック関係**:
  - 閲覧者と投稿者の間にブロック関係がある投稿は結果から除外

**フィルタリング実装方針**:
タイムライン取得時、以下の条件を満たす投稿のみを返却します：
1. `visibility=public` の投稿は誰でも閲覧可能
2. `visibility=followers` の投稿は、閲覧者が投稿者のフォロワーまたは本人の場合のみ
3. `visibility=private` の投稿は、`visibility=private`クエリパラメータを指定し、かつ本人の場合のみ
4. ブロック関係にあるユーザーの投稿は除外

**Response**:
```json
{
  "data": [
    {
      "id": "string",
      "content": "string",
      "imageUrls": ["string"],
      "tags": ["string"],
      "visibility": "public",
      "userId": "string",
      "quotedPostId": "string or null",
      "user": {
        "id": "string",
        "username": "string",
        "displayName": "string",
        "profileImageUrl": "string"
      },
      "quotedPost": {
        "id": "string",
        "content": "string",
        "user": {
          "id": "string",
          "username": "string",
          "displayName": "string"
        },
        "createdAt": "ISO8601"
      },
      "likesCount": 0,
      "commentsCount": 0,
      "repostsCount": 0,
      "quotesCount": 0,
      "isLikedByViewer": false,
      "isRepostedByViewer": false,
      "isBookmarkedByViewer": false,
      "isEdited": false,
      "editedAt": "ISO8601 or null",
      "repostInfo": {
        "isRepost": false,
        "repostedBy": null,
        "repostedAt": null
      },
      "createdAt": "ISO8601",
      "updatedAt": "ISO8601"
    }
  ],
  "pageInfo": {
    "nextCursor": "string",
    "hasNextPage": false,
    "count": 0
  }
}
```

**Quoteリポストの判定**:
- `quotedPostId` が null でない場合、その投稿は Quoteリポスト
- `quotedPost` オブジェクトに引用元の投稿情報が含まれる
- 引用元の投稿が削除されている場合は `quotedPost: null`

**通常のリポストとの違い**:
- **通常のリポスト**: `repostInfo.isRepost = true`（リポストメタ情報のみ）
- **Quoteリポスト**: `quotedPostId != null`（独立した投稿エンティティ）

#### GET /api/posts/{postId}
**投稿の単体取得**

**認証**: オプション（未認証でも public 投稿は閲覧可能）

**Response**:
```json
{
  "id": "string",
  "content": "string",
  "imageUrls": ["string"],
  "tags": ["string"],
  "visibility": "public",
  "userId": "string",
  "quotedPostId": "string or null",
  "user": {
    "id": "string",
    "username": "string",
    "displayName": "string",
    "profileImageUrl": "string"
  },
  "quotedPost": {
    "id": "string",
    "content": "string",
    "user": {
      "id": "string",
      "username": "string",
      "displayName": "string"
    },
    "createdAt": "ISO8601"
  },
  "likesCount": 0,
  "commentsCount": 0,
  "repostsCount": 0,
  "quotesCount": 0,
  "isLikedByViewer": false,
  "isRepostedByViewer": false,
  "isBookmarkedByViewer": false,
  "isEdited": false,
  "editedAt": "ISO8601 or null",
  "repostInfo": {
    "isRepost": false,
    "repostedBy": null,
    "repostedAt": null
  },
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

**アクセス制御**:
- **`visibility=public`**: 誰でも閲覧可能
- **`visibility=followers`**:
  - 投稿者のフォロワーのみ閲覧可能
  - 投稿者本人は閲覧可能
  - 非フォロワーがアクセスした場合は **404 Not Found**（投稿の存在を隠蔽）
- **`visibility=private`（下書き）**:
  - 投稿者本人のみ閲覧可能
  - 他のユーザーがアクセスした場合は **404 Not Found**

**ブロック関係のアクセス制御**:
- 閲覧者と投稿者の間にブロック関係がある場合は **404 Not Found**

**エラーレスポンス**:
- `404 Not Found`: 投稿が存在しない、または閲覧権限がない
  ```json
  {
    "error": "投稿が見つかりません"
  }
  ```

**注意事項**:
- 認証されていない場合、`isLikedByViewer`, `isRepostedByViewer`, `isBookmarkedByViewer` は常に `false`
- 削除済み投稿は `404 Not Found` を返却

#### POST /api/posts
**新規投稿の作成（通常投稿 & Quoteリポスト）**

**Request Body**:
```json
{
  "content": "string (max 280文字)",
  "imageUrls": ["url1", "url2"], // 最大4枚
  "visibility": "public" | "followers" | "private",
  "tags": ["tag1", "tag2"],  // #なしで送信
  "quotedPostId": "string or null"  // Quoteリポストの場合、元の投稿ID
}
```

**Quoteリポストの作成**:
- `quotedPostId` を指定することで、Quoteリポスト（引用リツイート）として作成
- `content` には自分のコメント（最大280文字）を記載
- 通常の投稿と同様に、いいね・コメント・リポストが可能な独立した投稿エンティティ

**Validation**:
- `content` は必須（1文字以上280文字以下）
- `imageUrls` は最大4枚
- `quotedPostId` を指定する場合:
  - 引用元の投稿が存在すること
  - 引用元の投稿が `visibility=public` であること（`followers` や `private` は引用不可）
  - 引用元の投稿が削除されていないこと

**Response**: 作成された投稿オブジェクト（201 Created）

**エラーレスポンス**:
- `400 Bad Request`: バリデーションエラー
- `403 Forbidden`: 引用元の投稿が `visibility=followers` または `private`
  ```json
  {
    "error": "この投稿は引用できません"
  }
  ```
- `404 Not Found`: 引用元の投稿が存在しない

#### PATCH /api/posts/{postId}
**投稿の編集**

**制限事項**:
- 自分の投稿のみ編集可能
- **公開済み投稿**（`visibility=public` または `followers`）:
  - 投稿後24時間以内のみ編集可能
  - 24時間を過ぎた場合は `403 Forbidden`
- **下書き**（`visibility=private`）:
  - 編集期限なし、いつでも編集可能

**Request Body**:
```json
{
  "content": "string (max 280文字)",
  "imageUrls": ["url1", "url2"], // 最大4枚
  "visibility": "public" | "followers" | "private",
  "tags": ["tag1", "tag2"]  // #なしで送信
}
```

**Response**:
```json
{
  "id": "string",
  "content": "string",
  "imageUrls": ["string"],
  "tags": ["string"],
  "visibility": "public",
  "isEdited": true,
  "editedAt": "ISO8601",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

**特殊な動作**:
- **下書きの初回公開時**（`visibility=private` → `public` または `followers`）:
  - `createdAt` を現在時刻に更新
  - `User.postsCount` をインクリメント
  - これにより、編集制限（24時間）が正しく機能し、タイムライン順序も自然になる
- **通常の編集時**:
  - `createdAt` は変更されない
  - `isEdited` を `true` に、`editedAt` を現在時刻に更新

**エラーレスポンス**:
- `403 Forbidden`: 編集権限なし
  ```json
  {
    "error": "この投稿は編集できません"
  }
  ```
  - 公開済み投稿で24時間を過ぎている場合
  - 他人の投稿を編集しようとした場合
- `404 Not Found`: 投稿が存在しない

**注意**: 下書き（`visibility=private`）には編集期限がないため、いつでも編集可能です。

**実装時の考慮点**:
```typescript
// 下書き公開時の処理例
async function updatePost(postId: string, updateData: UpdatePostData) {
  const post = await prisma.post.findUnique({ where: { id: postId } });

  // 下書きを公開する場合
  if (post.visibility === 'private' &&
      (updateData.visibility === 'public' || updateData.visibility === 'followers')) {
    // createdAt を現在時刻に更新
    await prisma.post.update({
      where: { id: postId },
      data: {
        ...updateData,
        createdAt: new Date(), // 重要: 現在時刻に更新
      }
    });

    // postsCount をインクリメント
    await prisma.user.update({
      where: { id: post.userId },
      data: { postsCount: { increment: 1 } }
    });
  } else {
    // 通常の編集
    await prisma.post.update({
      where: { id: postId },
      data: {
        ...updateData,
        isEdited: true,
        editedAt: new Date(),
      }
    });
  }
}
```

#### DELETE /api/posts/{postId}
**投稿の削除**

**Response**: 204 No Content

#### GET /api/follows
**フォロー関係の取得**

**Query Parameters**:
- `userId`: 対象ユーザーID
- `type`: `followers` | `following`
- `cursor`, `limit`

#### POST /api/follows
**フォローの作成**

**Request Body**: `{ followingId: "userId" }`

#### DELETE /api/follows/{followId}
**フォローの解除**

#### GET /api/users
**ユーザー情報の取得**

**Query Parameters**: `username` or `id`

---

### 新規追加が必要なエンドポイント

#### POST /api/posts/{postId}/like
**投稿にいいね**

**Response**: `{ liked: boolean, likesCount: number }`

#### DELETE /api/posts/{postId}/like
**いいねの取り消し**

**Response**: `{ liked: boolean, likesCount: number }`

---

#### GET /api/posts/{postId}/comments
**コメント一覧の取得**

**Query Parameters**: `cursor`, `limit`

**Response**:
```json
{
  "data": [
    {
      "id": "string",
      "content": "string",
      "postId": "string",
      "userId": "string",
      "user": { /* User object */ },
      "likesCount": 0,
      "isLikedByViewer": false,
      "createdAt": "ISO8601"
    }
  ],
  "pageInfo": { /* ... */ }
}
```

#### POST /api/posts/{postId}/comments
**コメントの投稿**

**Request Body**:
```json
{
  "content": "string (max 280文字)"
}
```

**Validation**:
- `content` は必須
- `content` は1文字以上280文字以下

**Response**: 作成されたコメントオブジェクト（201 Created）

**エラーレスポンス**:
- `400 Bad Request`: 文字数超過、または空のコメント
  ```json
  {
    "error": "コメントは1文字以上280文字以内で入力してください"
  }
  ```
- `404 Not Found`: 投稿が存在しない

#### DELETE /api/comments/{commentId}
**コメントの削除**

**認証**: 必須

**削除権限**:
- **コメント投稿者のみ**が削除可能
- 元の投稿の作者でも、他人のコメントは削除できない
- 管理者機能は初期実装に含まれない（Phase 5 以降）

**処理内容**:
1. コメントを削除
2. `Post.commentsCount` をデクリメント
3. 関連する `CommentLike` を CASCADE 削除
4. 関連する `Notification` を削除

**Response**: 204 No Content

**エラーレスポンス**:
- `403 Forbidden`: 削除権限なし（他人のコメントを削除しようとした場合）
  ```json
  {
    "error": "このコメントを削除する権限がありません"
  }
  ```
- `404 Not Found`: コメントが存在しない、または既に削除済み

**将来の拡張（Phase 5 以降）**:
- 投稿作者が自分の投稿に対するコメントを削除できる機能を検討
- 不適切なコメントを削除する管理者機能を検討

---

#### POST /api/comments/{commentId}/like
**コメントにいいね**

**Response**: `{ liked: boolean, likesCount: number }`

#### DELETE /api/comments/{commentId}/like
**コメントのいいね取り消し**

**Response**: `{ liked: boolean, likesCount: number }`

---

#### POST /api/posts/{postId}/repost
**通常のリポスト（コメントなし）**

**Request Body**: なし（空のPOSTリクエスト）

**機能**:
- 元の投稿をそのまま自分のフォロワーにシェア
- コメント追加なし（コメントを追加したい場合は Quoteリポストを使用）

**アクセス制御**:
- **`visibility=public` の投稿**: 誰でもリポスト可能
- **`visibility=followers` の投稿**: リポスト不可（プライバシー保護のため）
- **`visibility=private` の投稿**: リポスト不可

**Response**:
```json
{
  "id": "string",
  "userId": "string",
  "originalPostId": "string",
  "createdAt": "ISO8601"
}
```

**エラーレスポンス**:
- `403 Forbidden`: リポストできない投稿
  ```json
  {
    "error": "この投稿はリポストできません"
  }
  ```
  - `visibility=followers` の投稿をリポストしようとした場合
  - `visibility=private` の投稿をリポストしようとした場合
  - ブロック関係にあるユーザーの投稿
- `404 Not Found`: 投稿が存在しない、または閲覧権限がない
- `409 Conflict`: 既にリポスト済み
  ```json
  {
    "error": "この投稿は既にリポスト済みです"
  }
  ```

**Quoteリポスト（コメント付きリポスト）を作成する場合**:
- `POST /api/posts` を使用
- `quotedPostId` に元の投稿IDを指定
- `content` に自分のコメントを記載

**実装注意事項**:
- フォロワー限定投稿のリポストを禁止する理由:
  - リポストによって非フォロワーに投稿が拡散されるのを防ぐため
  - 投稿者のプライバシー意図を尊重するため
- Quoteリポストは制限されない（引用元が public の場合のみ可能）

#### DELETE /api/posts/{postId}/repost
**リポストの取り消し**

**Response**: 204 No Content

---

#### POST /api/posts/{postId}/bookmark
**ブックマークの追加**

**Response**: `{ bookmarked: boolean }`

#### DELETE /api/posts/{postId}/bookmark
**ブックマークの削除**

**Response**: `{ bookmarked: boolean }`

#### GET /api/bookmarks
**ブックマーク一覧の取得**

**Query Parameters**: `cursor`, `limit`

**Response**: 投稿一覧（ページネーション付き）

**アクセス制御とフィルタリング**:
- 削除済み投稿は結果から除外
- 投稿者と閲覧者の間にブロック関係が生じた場合、その投稿は結果から除外
- `visibility=followers` の投稿で、閲覧者が投稿者のフォロワーでなくなった場合は結果から除外
- `visibility=private` の投稿（投稿者が下書きから公開に変更した場合など）は通常通り表示

---

#### GET /api/notifications
**通知一覧の取得**

**Query Parameters**:
- `cursor`, `limit`
- `unreadOnly`: `true` | `false`

**Response**:
```json
{
  "data": [
    {
      "id": "string",
      "userId": "string",
      "actorId": "string",
      "actor": { /* User object */ },
      "type": "LIKE",
      "postId": "string",
      "post": { /* Post object */ },
      "isRead": false,
      "createdAt": "ISO8601"
    }
  ],
  "pageInfo": { /* ... */ }
}
```

**アクセス制御とフィルタリング**:
- ブロック関係にあるユーザーからの通知は結果から除外
- 削除済み投稿に関する通知は除外
- 関連する投稿が `visibility=followers` で、閲覧者が非フォロワーの場合は除外（通常は起こらない）

#### PATCH /api/notifications/{notificationId}/read
**通知を既読にする**

**Response**: 更新されたNotificationオブジェクト

#### PATCH /api/notifications/mark-all-read
**全ての通知を既読にする**

**Response**: `{ updatedCount: number }`

---

#### POST /api/reports
**報告の作成**

**Request Body**:
```json
{
  "type": "POST" | "COMMENT" | "USER",
  "targetId": "string",
  "reason": "SPAM" | "HARASSMENT" | "INAPPROPRIATE_CONTENT" | "HATE_SPEECH" | "OTHER",
  "description": "string"
}
```

**Response**: 作成されたReportオブジェクト（201 Created）

---

#### POST /api/blocks
**ユーザーをブロック**

**Request Body**: `{ blockedId: "userId" }`

**Response**: 作成されたBlockオブジェクト（201 Created）

#### DELETE /api/blocks/{blockId}
**ブロックの解除**

**Response**: 204 No Content

#### GET /api/blocks
**ブロック一覧の取得**

**Response**: ブロックしたユーザーのリスト

---

#### GET /api/search
**全体検索**

**Query Parameters**:
- `q`: 検索キーワード（必須）
- `type`: `posts` | `users` | `hashtags`
- `cursor`, `limit`

**Response**:
```json
{
  "data": [ /* 検索結果（typeによって異なる） */ ],
  "pageInfo": { /* ... */ }
}
```

**アクセス制御（`type=posts` の場合）**:
- タイムラインと同じフィルタリングルールを適用
- `visibility=public` の投稿のみ検索対象（基本方針）
- `visibility=followers` の投稿は、閲覧者が投稿者のフォロワーまたは本人の場合のみ検索結果に含む
- `visibility=private` の投稿は検索結果に含めない
- ブロック関係にあるユーザーの投稿は検索結果から除外

**実装方法**:
- PostgreSQLのfull-text search機能を使用
- `to_tsvector`と`to_tsquery`で全文検索インデックス作成
- ハッシュタグは`tags`配列フィールドの部分一致検索

---

#### POST /api/upload/image
**画像アップロード**

**Request**: `multipart/form-data`
- `file`: 画像ファイル（JPEG, PNG）
- `type`: `post` | `profile`

**Response**:
```json
{
  "url": "https://...",
  "width": 1920,
  "height": 1080
}
```

**実装方法**:
1. クライアントから画像をアップロード
2. サーバー側で画像を検証（サイズ、フォーマット）
3. 画像を圧縮・リサイズ（Sharp等を使用）
4. S3/R2にアップロード
5. URLを返却

---

#### GET /api/users/me/settings
**ユーザー設定の取得**

**Response**:
```json
{
  "notifications": {
    "likes": true,
    "comments": true,
    "reposts": true,
    "follows": true
  },
  "postDefaultVisibility": "public"
}
```

#### PATCH /api/users/me/settings
**ユーザー設定の更新**

**Request Body**:
```json
{
  "notifications": {
    "likes": true,
    "comments": false,
    "reposts": true,
    "follows": false
  },
  "postDefaultVisibility": "followers"
}
```

**Validation**:
- `notifications` はオプション（省略可）
  - 各通知項目（`likes`, `comments`, `reposts`, `follows`）は boolean
- `postDefaultVisibility` はオプション（省略可）
  - 許容値: `"public"` | `"followers"` | `"private"`
  - デフォルト値: `"public"`
  - 無効な値の場合は `400 Bad Request`

**Response**:
```json
{
  "notifications": {
    "likes": true,
    "comments": false,
    "reposts": true,
    "follows": false
  },
  "postDefaultVisibility": "followers"
}
```

**エラーレスポンス**:
- `400 Bad Request`: 無効な `postDefaultVisibility` 値
  ```json
  {
    "error": "postDefaultVisibility は 'public', 'followers', 'private' のいずれかを指定してください"
  }
  ```

**実装詳細**:
- 設定は `User.settings` JSONフィールドに保存
- 通知送信時に設定をチェックし、OFFの場合は通知を送信しない
- `postDefaultVisibility` は投稿作成画面で初期値として使用される

**UI実装**:
- 設定画面（`setting_screen.dart`）に投稿のデフォルト公開範囲セクションを追加
- ラジオボタンまたはドロップダウンで選択
  - 「全体公開（public）」
  - 「フォロワーのみ（followers）」
  - 「下書き（private）」※通常は選択しない

---

#### PUT /api/users/me/push-token
**FCMデバイストークンの登録・更新**

**Request Body**:
```json
{
  "fcmToken": "string"
}
```

**Response**:
```json
{
  "success": true,
  "fcmToken": "string"
}
```

**実装詳細**:
- ユーザーの `fcmToken` フィールドを更新
- 既存のトークンがある場合は上書き（マルチデバイス非対応）
- トークンの有効性検証は行わない（Firebase側で管理）

---

#### DELETE /api/users/me/push-token
**FCMデバイストークンの削除**

**使用タイミング**: ログアウト時、またはプッシュ通知をオフにする時

**Response**:
```json
{
  "success": true
}
```

**実装詳細**:
- ユーザーの `fcmToken` を null に設定
- トークン削除後は、そのユーザーにプッシュ通知が送信されなくなる

**マルチデバイス対応について**:
- 現在の仕様では、1ユーザーにつき1つのトークンのみ保存（マルチデバイス非対応）
- 別デバイスでログインすると、前のデバイスのトークンは上書きされる
- 将来的にマルチデバイス対応が必要な場合は、別途 `DeviceToken` テーブルを作成する必要がある

---
