# バックエンドAPI性能分析レポート

## 概要

本ドキュメントは、バックエンドAPIにおけるデータ取得の効率性を調査し、速度改善が可能な箇所を特定したレポートです。

## 調査対象

- 全54個のAPIエンドポイント (`backend/src/app/api/`)
- データアクセス層 (`backend/src/lib/store.ts`)
- ページネーション処理 (`backend/src/lib/pagination.ts`)

---

## 発見された問題

### 1. 全件取得後のメモリページネーション（重大度: 高）

以下のエンドポイントでは、データベースから全件取得した後にメモリ上でページネーションを行っています。データ量が増加すると深刻なパフォーマンス問題となります。

| エンドポイント | ファイル | 問題の詳細 |
|--------------|---------|-----------|
| `GET /api/users` | `users/route.ts:39-43` | `prisma.user.findMany()` で全ユーザー取得後、`paginateArray()` でメモリページネーション |
| `GET /api/follows/following` | `follows/following/route.ts:22-26` | 全フォロー関係を取得後、メモリでページネーション |
| `GET /api/follows/followers` | `follows/followers/route.ts:22-26` | 全フォロワーを取得後、メモリでページネーション |
| `GET /api/posts/[id]/comments` | `posts/[id]/comments/route.ts:34` | `listComments()` で全コメント取得後、`paginateArray()` 使用 |
| `GET /api/users/[id]/posts` | `users/[id]/posts/route.ts:47-51` | 全投稿を取得後、可視性フィルタ＆メモリページネーション |
| `GET /api/lessons` | `lessons/route.ts:30` | `listLessons()` で全レッスン取得後、フィルタ＆ページネーション |

**改善案:**
```typescript
// Before: 全件取得
const users = await prisma.user.findMany({ where });
const paginated = paginateArray(users, { cursor, limit, getCursor: (user) => user.id });

// After: DBレベルでページネーション
const users = await prisma.user.findMany({
  where,
  orderBy: { displayName: "asc" },
  take: limit + 1,
  ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
});
```

---

### 2. N+1問題（重大度: 高）

#### 2.1 `canViewPost` 関数のループ内呼び出し

`canViewPost` 関数は内部で以下のクエリを実行します:
- `hasBlockingBetween()` - ブロック関係を確認（1クエリ）
- `isFollowingUser()` - フォロー関係を確認（1クエリ）

この関数がループ内で呼び出されると、投稿数×2のクエリが発生します。

| エンドポイント | ファイル | 影響 |
|--------------|---------|-----|
| `GET /api/bookmarks` | `bookmarks/route.ts:33-40` | ブックマーク数×2クエリ |
| `GET /api/users/[id]/posts` | `users/[id]/posts/route.ts:54-58` | 投稿数×2クエリ |
| `GET /api/search` (posts) | `search/route.ts:55-62` | 検索結果数×2クエリ |

**改善案:**

```typescript
// Before: ループ内でcanViewPost
for (const post of posts) {
  if (await canViewPost(post, viewerId)) {
    visiblePosts.push(post);
  }
}

// After: バッチ取得を使用（posts/route.tsと同様のパターン）
const authorIds = [...new Set(posts.map((p) => p.userId))];
const [blockedSet, followingSet] = viewerId
  ? await Promise.all([
      batchCheckBlocks(authorIds, viewerId),
      batchCheckFollowing(viewerId, authorIds),
    ])
  : [new Set<string>(), new Set<string>()];

for (const post of posts) {
  if (canAccessPostSync(post, viewerId, blockedSet, followingSet)) {
    visiblePosts.push(post);
  }
}
```

---

### 3. 不要なinclude / オーバーフェッチ（重大度: 中）

| エンドポイント | 問題 | 改善案 |
|--------------|------|-------|
| `GET /api/posts/[id]/comments` | `getPostById()` で `quotedPost` まで include しているが、コメント取得では不要 | コメント取得時は `post.id` と `post.visibility` のみで十分 |
| `GET /api/users/[id]/stats` | `findUserById()` でユーザー全情報を取得しているが、存在確認のみが目的 | `select: { id: true }` で十分 |
| `GET /api/follows/following` | `include: { following: true }` で全フィールド取得 | 必要なフィールドのみを `select` で指定 |

**改善例:**
```typescript
// Before
const targetUser = await findUserById(targetUserId);

// After: 存在確認のみの場合
const exists = await prisma.user.findUnique({
  where: { id: targetUserId },
  select: { id: true },
});
if (!exists) throw ERROR.NOT_FOUND("User not found");
```

---

### 4. 検索APIの効率性問題（重大度: 中）

#### `GET /api/search` - ハッシュタグ検索

`searchHashtags()` 関数（`search/route.ts:127-166`）では、生SQLでUNNESTとGROUP BYを使用しています。

```sql
SELECT tag, COUNT(*)::bigint AS usage
FROM (SELECT UNNEST("tags") AS tag FROM "Post" WHERE "visibility" = 'public') tags
WHERE LOWER(tag) LIKE '%..%'
GROUP BY tag
ORDER BY usage DESC, tag ASC
```

**潜在的問題:**
- 全投稿のタグを展開してから集計するため、投稿数が増えると重くなる
- インデックスが効かない

**改善案:**
- ハッシュタグ使用回数を別テーブルで管理（Hashtag テーブル追加）
- または、キャッシュを導入

---

## 良い実装パターン（参考）

以下は既に効率的に実装されている箇所です。

### 1. 投稿フィードのバッチ処理 (`posts/route.ts`)

```typescript
// N+1解消: 投稿作者のIDを収集し、一括でblock/follow判定を取得
const authorIds = [...new Set(posts.map((p) => p.userId))];
const [blockedSet, followingSet] = viewerId
  ? await Promise.all([
      batchCheckBlocks(authorIds, viewerId),
      batchCheckFollowing(viewerId, authorIds),
    ])
  : [new Set<string>(), new Set<string>()];
```

### 2. いいね・ブックマーク状態のバッチ取得 (`store.ts`)

```typescript
export async function batchGetPostInteractions(
  postIds: string[],
  viewerId?: string
): Promise<Map<string, { liked: boolean; bookmarked: boolean }>> {
  const [likes, bookmarks] = await Promise.all([
    prisma.like.findMany({ where: { postId: { in: postIds }, userId: viewerId } }),
    prisma.bookmark.findMany({ where: { postId: { in: postIds }, userId: viewerId } }),
  ]);
  // ...
}
```

### 3. コメントのいいね状態バッチ取得 (`store.ts:listComments`)

```typescript
if (viewerId && comments.length > 0) {
  const likes = await prisma.commentLike.findMany({
    where: { userId: viewerId, commentId: { in: comments.map((c) => c.id) } },
  });
  likedIds = new Set(likes.map((like) => like.commentId));
}
```

### 4. 単語帳のDBレベルページネーション (`wordbook/route.ts`)

```typescript
const [words, total] = await Promise.all([
  prisma.wordbook.findMany({
    where,
    orderBy: { createdAt: "desc" },
    ...(paginated ? { skip: offset, take: limit } : {}),
  }),
  prisma.wordbook.count({ where }),
]);
```

---

## 改善優先度

| 優先度 | 問題 | 影響範囲 | 改善難易度 |
|-------|------|---------|-----------|
| **高** | `canViewPost` のN+1問題 | ブックマーク、ユーザー投稿一覧、検索 | 中（既存のバッチ関数を活用可能） |
| **高** | フォロー/フォロワー一覧の全件取得 | フォロー数が多いユーザーで顕著 | 低（cursorベースのDB取得に変更） |
| **中** | ユーザー一覧の全件取得 | ユーザー数増加時に影響 | 低 |
| **中** | コメント一覧の全件取得 | コメント数が多い投稿で影響 | 低 |
| **低** | 不要なinclude | 軽微なオーバーヘッド | 低 |

---

## 推奨アクション

### 短期的改善（即時対応推奨）

1. **`canViewPost` のバッチ版を作成・適用**
   - `canViewPostBatch(posts, viewerId)` を作成
   - `/api/bookmarks`, `/api/users/[id]/posts`, `/api/search` に適用

2. **フォロー/フォロワー一覧のDBレベルページネーション**
   - `follows/following/route.ts`, `follows/followers/route.ts` を修正

### 中期的改善

3. **コメント一覧のDBレベルページネーション**
   - `store.ts:listComments` を修正

4. **不要なincludeの削減**
   - 各APIで必要なフィールドのみをselectするよう修正

### 長期的改善

5. **ハッシュタグのキャッシュ/テーブル化**
   - 検索パフォーマンス向上のため、Hashtagテーブルを導入

6. **クエリログの導入**
   - Prismaのクエリログを有効化し、本番環境での実際のクエリパターンを監視

---

## まとめ

現在のコードベースでは、投稿フィードなどの主要機能ではN+1問題が適切に解消されていますが、一部のエンドポイントでは全件取得後のメモリページネーションやループ内クエリが残っています。

特に **フォロー/フォロワー一覧** と **`canViewPost` のN+1問題** は、ユーザー数・投稿数の増加に伴い顕著なパフォーマンス劣化を引き起こす可能性があるため、優先的に対応することを推奨します。

---

## 検証結果（2024年12月17日追記）

本レポートの内容をコードベースと照合し、検証を行いました。

### 検証ステータス

| セクション | ステータス | 備考 |
|-----------|----------|------|
| 1. 全件取得後のメモリページネーション | ✅ 正確 | 6エンドポイント全て確認済み |
| 2. N+1問題（canViewPost） | ✅ 正確 | 3エンドポイント全て確認済み |
| 3. 不要なinclude/オーバーフェッチ | ✅ 正確 | 3エンドポイント全て確認済み |
| 4. 検索APIの効率性問題 | ✅ 正確 | searchHashtags関数を確認済み |

### 詳細検証結果

#### 1. 全件取得後のメモリページネーション
- `users/route.ts:39-45` - 確認済み。`paginateArray()`使用
- `follows/following/route.ts:22-38` - 確認済み。`paginateArray()`使用
- `follows/followers/route.ts:22-38` - 確認済み。`paginateArray()`使用
- `posts/[id]/comments/route.ts:34-40` - 確認済み。`listComments()`後に`paginateArray()`使用
- `users/[id]/posts/route.ts:47-64` - 確認済み。全件取得後フィルタ＆`paginateArray()`
- `lessons/route.ts:30-43` - 確認済み。`listLessons()`後に`paginateArray()`使用

#### 2. N+1問題
`canViewPost`関数（`store.ts:1400-1417`）の実装を確認:
```typescript
export async function canViewPost(post: PrismaPost, viewerId?: string) {
  if (await hasBlockingBetween(post.userId, viewerId)) {  // 1クエリ
    return false;
  }
  // ...
  if (post.visibility === "followers") {
    return isFollowingUser(viewerId, post.userId);  // 条件次第で追加1クエリ
  }
  // ...
}
```

ループ内呼び出し箇所:
- `bookmarks/route.ts:33-40` - for文内で`await canViewPost()`
- `users/[id]/posts/route.ts:54-58` - for文内で`await canViewPost()`
- `search/route.ts:55-62` - for文内で`await canViewPost()`

---

## 追加で発見された問題

### 5. ブロック一覧のページネーション未実装（重大度: 低〜中）

| エンドポイント | ファイル | 問題の詳細 |
|--------------|---------|-----------|
| `GET /api/blocks` | `blocks/route.ts:6-14` | `listBlocks()`で全件取得、ページネーション未実装 |

**該当コード（`store.ts:1340-1353`）:**
```typescript
export async function listBlocks(blockerId: string): Promise<BlockResponse[]> {
  const blocks = await prisma.block.findMany({
    where: { blockerId },
    include: { blocked: true },
    orderBy: { createdAt: "desc" },
  });
  // 全件をそのまま返却、ページネーションなし
  return blocks.map((block) => ({...}));
}
```

**影響:** ブロック数が多いユーザーでパフォーマンス劣化の可能性（通常のユースケースでは影響は限定的）

---

## 修正時の注意点（影響分析）

各関数・エンドポイントを修正する際の影響範囲を以下にまとめます。

### `getPostById` の影響範囲（6ファイル）

| ファイル | 用途 | `quotedPost`の必要性 |
|---------|-----|---------------------|
| `posts/[id]/route.ts` | 投稿詳細取得・更新・削除 | ✅ 必要（レスポンスに含める） |
| `posts/[id]/comments/route.ts` | コメント一覧取得・追加 | ❌ 不要（canViewPostのみ使用） |
| `posts/[id]/like/route.ts` | いいね追加・削除 | ❌ 不要（canViewPostのみ使用） |
| `posts/[id]/bookmark/route.ts` | ブックマーク追加・削除 | ❌ 不要（canViewPostのみ使用） |
| `comments/[id]/like/route.ts` | コメントいいね | ❌ 不要（canViewPostのみ使用） |

**推奨対応:**
```typescript
// 軽量版関数を新規作成
export function getPostForAccessCheck(postId: string) {
  return prisma.post.findUnique({
    where: { id: postId },
    select: { id: true, userId: true, visibility: true },
  });
}
```

### `findUserById` の影響範囲（7ファイル）

| ファイル | 用途 | 全フィールドの必要性 |
|---------|-----|---------------------|
| `users/[id]/route.ts` | ユーザー詳細取得 | ✅ 必要 |
| `users/[id]/posts/route.ts` | ユーザー投稿一覧 | ❌ 存在確認のみ |
| `users/[id]/stats/route.ts` | ユーザー統計 | ❌ 存在確認のみ |
| `follows/following/route.ts` | フォロー中一覧 | ❌ 存在確認のみ |
| `follows/followers/route.ts` | フォロワー一覧 | ❌ 存在確認のみ |
| `billing/verify/route.ts` | 課金検証 | 確認が必要 |

**推奨対応:** 存在確認のみの場合は直接`prisma.user.findUnique({ select: { id: true } })`を使用

### `canViewPost` の影響範囲（9ファイル）

| カテゴリ | ファイル | 修正方針 |
|---------|---------|---------|
| バッチ処理が必要 | `bookmarks/route.ts`, `users/[id]/posts/route.ts`, `search/route.ts` | `canAccessPostSync`パターンを適用 |
| 単一投稿のみ | `posts/[id]/route.ts`, `posts/[id]/comments/route.ts`, `posts/[id]/like/route.ts`, `posts/[id]/bookmark/route.ts`, `comments/[id]/like/route.ts` | 現状のcanViewPostを維持 |

**推奨対応:** 既存の`canViewPost`は維持し、`posts/route.ts`の`canAccessPostSync`パターンを他のバッチ処理箇所に展開

---

## 重要: リリース済みiOSアプリとの整合性

**本レポートの改善を実装する際は、既にリリースされているiOSアプリとの後方互換性を必ず維持すること。**

### API変更時の必須確認事項

| 項目 | 確認内容 |
|-----|---------|
| レスポンス形式 | 既存のフィールド名・型・構造を変更しない |
| ページネーション | `pageInfo`の形式（`nextCursor`, `hasNextPage`, `count`）を維持 |
| エラーレスポンス | エラーコード・メッセージ形式を維持 |
| HTTPステータスコード | 既存の成功・エラー時のステータスコードを維持 |

### 安全な改善パターン

```typescript
// ✅ 安全: 内部実装の最適化（レスポンス形式は同一）
// Before
const users = await prisma.user.findMany({ where });
const paginated = paginateArray(users, { cursor, limit, getCursor: (u) => u.id });

// After（レスポンス形式は変わらない）
const users = await prisma.user.findMany({
  where,
  take: limit + 1,
  ...(cursor ? { skip: 1, cursor: { id: cursor } } : {}),
});
```

### 避けるべき変更

```typescript
// ❌ 危険: レスポンス形式の変更
// Before
return { data, pageInfo: { nextCursor, hasNextPage, count } };

// After（形式が変わるとアプリが壊れる）
return { items: data, pagination: { cursor: nextCursor, more: hasNextPage } };
```

### 新規フィールド追加時

- 新しいフィールドの追加は許容される（iOSアプリは未知のフィールドを無視する）
- 既存フィールドの削除・型変更は不可

---

## 修正によるリグレッションリスク

### 低リスク
- フォロー/フォロワー一覧のDBレベルページネーション化
  - 影響: レスポンス形式は変わらない
  - テスト: ページネーションの動作確認のみ

### 中リスク
- `canViewPost`のバッチ化
  - 影響: 可視性判定ロジックの変更
  - テスト: public/followers/private投稿の閲覧権限を網羅的にテスト

### 高リスク（要注意）
- `getPostById`/`findUserById`の分離
  - 影響: 呼び出し元の変更が必要
  - テスト: 全使用箇所の動作確認

---

*作成日: 2024年12月17日*
*検証日: 2024年12月17日*
