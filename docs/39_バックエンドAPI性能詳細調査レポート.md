# バックエンドAPI性能詳細調査レポート

## 概要

本レポートでは、`backend/src/lib/store.ts` および `backend/src/app/api/` の全APIエンドポイントを詳細に調査し、N+1問題やインデックス不足による性能劣化箇所を特定した結果をまとめます。

**調査日**: 2025-12-18
**調査対象**:
- `backend/src/lib/store.ts`
- `backend/src/app/api/**/*.ts`
- `backend/prisma/schema.prisma`

---

## 調査結果サマリー

| カテゴリ | 状態 | 詳細 |
|----------|------|------|
| N+1問題 | **1件修正済み** | 通知一覧取得（`listNotificationsForUser`） |
| インデックス不足 | **4件修正済み** + 4件中優先度 | 詳細は下記 |
| バッチ処理 | **適切に実装済み** | 投稿一覧、検索、ブックマーク等 |

---

## 1. N+1問題の調査結果

### 1.1 修正済み: 通知一覧取得（高優先度）

**問題箇所**: `store.ts:listNotificationsForUser` → `toNotificationResponseInternal`

**修正前の問題**:
```typescript
// 各通知に対して個別にクエリが発生
const data = await Promise.all(
  nodes.map((notification) => toNotificationResponseInternal(notification))
);

// toNotificationResponseInternal内で
const post = notification.post
    ? await toPostResponse(notification.post, notification.userId)  // N+1
    : null;

// toPostResponse内で
const liked = await isPostLikedByUser(post.id, viewerId);      // N+1
const bookmarked = await isPostBookmarkedByUser(post.id, viewerId); // N+1
```

**影響**: 20件の通知取得で最大61回のクエリが発生

**修正内容**:
- `toNotificationResponseBatch` 関数を新規作成
- `batchGetPostInteractions` でいいね・ブックマーク状態を一括取得
- 修正後: **3回のクエリ**に削減

**修正ファイル**: `store.ts:880-970`, `store.ts:1258-1259`

---

### 1.2 適切に実装済みの箇所

以下のAPIは既にバッチ処理が適切に実装されています：

| API | 関数 | バッチ処理方法 |
|-----|------|---------------|
| `GET /api/posts` | `toPostResponseBatch` | `batchGetPostInteractions` |
| `GET /api/bookmarks` | `toPostResponseBatch` | `batchGetPostInteractions` |
| `GET /api/users/[id]/posts` | `toPostResponseBatch` | `batchGetPostInteractions` |
| `GET /api/search` | `toPostResponseBatch`, `batchCheckBlocks` | バッチ処理 |
| `GET /api/posts/[id]/comments` | `listComments` | `commentLike` 一括取得 |
| `GET /api/ranking-game/ranking` | `getRankingGameRanking` | ユーザー情報一括取得 |

**検証コード例** (`posts/route.ts:124-146`):
```typescript
// N+1解消: 投稿作者のIDを収集し、一括でblock/follow判定を取得
const authorIds = [...new Set(posts.map((p) => p.userId))];
const [blockedSet, followingSet] = viewerId
  ? await Promise.all([
      batchCheckBlocks(authorIds, viewerId),
      batchCheckFollowing(viewerId, authorIds),
    ])
  : [new Set<string>(), new Set<string>()];

// バッチ処理でレスポンス変換
const data = await toPostResponseBatch(nodes, viewerId);
```

---

## 2. インデックスの調査結果

### 2.1 修正済みインデックス（高優先度）

| モデル | 追加インデックス | 対象クエリ | 影響API |
|--------|-----------------|------------|---------|
| Comment | `[postId, createdAt]` | コメント一覧（日付順） | `GET /api/posts/[id]/comments` |
| Bookmark | `[userId, createdAt]` | ブックマーク一覧（日付順） | `GET /api/bookmarks` |
| LessonCompletion | `[userId, completedAt]` | 学習履歴（日付順） | `GET /api/lessons/stats` |
| LessonCompletion | `[userId, lessonId]` | 特定レッスン進捗 | `GET /api/lessons/[id]` |
| Wordbook | `[userId, status]` | ステータス別単語帳 | `GET /api/wordbook` |
| Wordbook | `[userId, category]` | カテゴリ別単語帳 | `GET /api/wordbook` |
| Notification | `[userId, createdAt]` | 通知一覧（日付順） | `GET /api/notifications` |

### 2.2 削除した冗長インデックス

| モデル | 削除インデックス | 理由 |
|--------|-----------------|------|
| User | `[username]`, `[email]`, `[auth0UserId]` | `@unique` で自動作成 |
| ExchangeRate | `[baseCurrency, targetCurrency]` | `@@unique` で自動作成 |
| Bookmark | `[userId]` | `[userId, createdAt]` で代替 |
| LessonCompletion | `[userId]` | `[userId, completedAt]` で代替 |
| Wordbook | `[userId]` | `[userId, status]` で代替 |

### 2.3 未対応インデックス（中優先度）

以下のインデックスは現時点では追加していません。パフォーマンス問題が発生した場合に検討してください：

| モデル | 推奨インデックス | 対象クエリ | 影響API |
|--------|-----------------|------------|---------|
| Follow | `[followerId, createdAt]` | フォロー一覧（日付順） | `GET /api/follows/following` |
| Follow | `[followingId, createdAt]` | フォロワー一覧（日付順） | `GET /api/follows/followers` |
| Block | `[blockerId, createdAt]` | ブロック一覧（日付順） | `GET /api/blocks` |
| RankingGameResult | `[userId, playedAt]` | 最近のプレイ結果 | `GET /api/ranking-game/my-stats` |
| PronunciationGameResult | `[userId, playedAt]` | 最近のプレイ結果 | `GET /api/pronunciation-game/my-stats` |

**追加しなかった理由**:
1. 過度なインデックス張りを避けるため
2. これらのAPIは使用頻度が相対的に低い
3. 現在のデータ量では顕著な性能問題が発生していない

---

## 3. APIエンドポイント別の性能状態

### 3.1 高頻度API（最適化済み）

| エンドポイント | 状態 | クエリ数 | 備考 |
|---------------|------|---------|------|
| `GET /api/posts` | **最適化済み** | 4-5回 | バッチ処理使用 |
| `GET /api/bookmarks` | **最適化済み** | 4-5回 | バッチ処理使用 |
| `GET /api/notifications` | **最適化済み** | 3回 | 今回修正 |
| `GET /api/posts/[id]/comments` | **最適化済み** | 2回 | バッチ処理使用 |
| `GET /api/search` | **最適化済み** | 4-5回 | バッチ処理使用 |

### 3.2 中頻度API（問題なし）

| エンドポイント | 状態 | クエリ数 | 備考 |
|---------------|------|---------|------|
| `GET /api/users/[id]/posts` | **最適化済み** | 4-5回 | バッチ処理使用 |
| `GET /api/follows/followers` | 良好 | 2回 | include使用 |
| `GET /api/follows/following` | 良好 | 2回 | include使用 |
| `GET /api/lessons` | 良好 | 1回 | シンプルなクエリ |
| `GET /api/wordbook` | 良好 | 2回 | count + findMany |

### 3.3 低頻度API（問題なし）

| エンドポイント | 状態 | 備考 |
|---------------|------|------|
| `GET /api/ranking-game/ranking` | 良好 | Raw SQLで最適化 |
| `GET /api/ranking-game/my-stats` | 良好 | - |
| `GET /api/pronunciation-game/*` | 良好 | - |
| `GET /api/stats/integrated` | 良好 | - |
| `GET /api/blocks` | 良好 | include使用 |

---

## 4. `toPostResponseBatch` の内部動作

投稿一覧系APIで使用される `toPostResponseBatch` 関数の動作を確認しました：

```typescript
export async function toPostResponseBatch(
  posts: PostWithOptionalUser[],
  viewerId?: string
): Promise<PostResponse[]> {
  // 1. いいね・ブックマーク状態を一括取得（2クエリのみ）
  const interactions = await batchGetPostInteractions(postIds, viewerId);

  // 2. 各投稿をレスポンスに変換
  return Promise.all(
    posts.map(async (post) => {
      // post.user は include で取得済み（追加クエリなし）
      const author = post.user ?? ...;

      // interactions から取得（追加クエリなし）
      const interaction = interactions.get(post.id);

      // post.quotedPost は include で取得済み（追加クエリなし）
      const quotedPost = await resolveQuotedPost(post);

      return { ...toPostRecord(post), user, liked, bookmarked, quotedPost };
    })
  );
}
```

**結論**: 適切にバッチ処理が実装されており、N+1問題は発生しない

---

## 5. 推奨アクション

### 即時対応（完了）

1. ~~通知一覧取得のN+1問題を修正~~ **完了**
2. ~~高優先度インデックスを追加~~ **完了**

### 今後の監視項目

1. **クエリ実行時間の監視**
   - PostgreSQL の `pg_stat_statements` で遅いクエリを特定
   - 100ms以上のクエリが頻発する場合は対応を検討

2. **中優先度インデックスの追加タイミング**
   - フォロー/フォロワー一覧が遅い場合: `Follow` に複合インデックス追加
   - ランキングゲーム統計が遅い場合: `RankingGameResult` に複合インデックス追加

3. **データ量の増加に伴う対応**
   - ユーザー数が10,000人を超えた場合、中優先度インデックスの追加を検討
   - 投稿数が100,000件を超えた場合、検索クエリの最適化を検討

---

## 6. 変更履歴

| 日付 | 変更内容 |
|------|---------|
| 2025-12-18 | 初版作成、通知一覧N+1問題修正、インデックス最適化 |

---

*作成日: 2025-12-18*
*調査対象: backend/src/lib/store.ts, backend/src/app/api/**, backend/prisma/schema.prisma*
