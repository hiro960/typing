# Prisma インデックス最適化分析レポート

## 概要

本レポートでは、現在の `backend/prisma/schema.prisma` のインデックス設定を分析し、パフォーマンス改善のための提案を行います。

**分析方法**: 実際のAPI実装（`src/app/api/`）および `src/lib/store.ts` のクエリパターンを詳細に調査し、頻繁に実行されるクエリに基づいてインデックスの必要性を評価しました。

---

## 分析結果サマリー

| 優先度 | モデル | 問題数 | 影響度 | 関連API |
|--------|--------|--------|--------|---------|
| 高 | Comment | 2 | 投稿のコメント一覧取得 | `POST /api/posts/[id]/comments` |
| 高 | Wordbook | 4 | 単語帳機能全般 | `GET /api/wordbook` |
| 高 | LessonCompletion | 3 | 学習履歴・ランキング | `GET /api/lessons/stats` |
| 高 | Bookmark | 2 | ブックマーク一覧 | `GET /api/bookmarks` |
| 中 | Follow | 2 | フォロー/フォロワー一覧 | `GET /api/follows/followers` |
| 中 | RankingGameResult | 2 | ランキング・最近の結果 | `GET /api/ranking-game/my-stats` |
| 中 | PronunciationGameResult | 2 | 発音ゲーム統計 | `GET /api/pronunciation-game/my-stats` |
| 中 | Block | 1 | ブロック一覧 | `GET /api/blocks` |
| 低 | User | 1 | 冗長インデックス削除 | - |
| 低 | Like | 1 | いいね履歴 | - |
| 低 | Lesson | 1 | レッスン一覧 | `GET /api/lessons` |
| 低 | ExchangeRate | 1 | 冗長インデックス削除 | - |

---

## 詳細分析

### 1. User モデル（69-117行）

#### 現在のインデックス
```prisma
@@index([username])
@@index([email])
@@index([auth0UserId])
```

#### 問題点

**問題1: 冗長なインデックス（低優先度）**

`@unique` 制約を持つフィールドには PostgreSQL が自動的にユニークインデックスを作成します。そのため、以下の3つの `@@index` は冗長です：

- `auth0UserId` → `@unique` で自動インデックス作成済み
- `username` → `@unique` で自動インデックス作成済み
- `email` → `@unique` で自動インデックス作成済み

**問題2: 欠落しているインデックス**

| フィールド | 影響を受けるクエリ |
|------------|-------------------|
| `createdAt` | 新規ユーザー一覧の日付ソート |

#### 推奨変更

```prisma
model User {
  // ... fields ...

  // 削除推奨（冗長）
  // @@index([username])  // @uniqueで自動作成
  // @@index([email])     // @uniqueで自動作成
  // @@index([auth0UserId]) // @uniqueで自動作成

  // 追加推奨
  @@index([createdAt])               // 新規ユーザー一覧
}
```

---

### 2. Comment モデル（151-167行）

#### 現在のインデックス
```prisma
@@index([postId])
@@index([userId])
```

#### 問題点

**問題1: コメント一覧取得の非効率**

投稿のコメント一覧を日付順で取得する際、以下のようなクエリが発行されます：

```sql
SELECT * FROM comments WHERE post_id = ? ORDER BY created_at DESC
```

現在は `postId` 単独のインデックスしかないため、`ORDER BY created_at` で追加のソートが発生します。

**問題2: `createdAt` の単独インデックス欠落**

全コメントの最新順取得や、管理画面でのコメント一覧表示に影響があります。

#### 推奨変更

```prisma
model Comment {
  // ... fields ...

  @@index([postId])
  @@index([userId])
  @@index([createdAt])               // 追加：最新コメント取得
  @@index([postId, createdAt])       // 追加：投稿のコメント一覧（日付順）
}
```

#### 影響度: 高
投稿のコメント一覧はソーシャル機能の中核であり、頻繁に実行されるクエリです。

---

### 3. Like モデル（169-180行）

#### 現在のインデックス
```prisma
@@unique([postId, userId])
@@index([userId])
```

#### 問題点

ユーザーの「いいね」履歴を日付順で取得する場合に非効率：

```sql
SELECT * FROM likes WHERE user_id = ? ORDER BY created_at DESC
```

#### 推奨変更

```prisma
model Like {
  // ... fields ...

  @@unique([postId, userId])
  @@index([userId])
  @@index([userId, createdAt])       // 追加：いいね履歴（日付順）
}
```

---

### 4. Bookmark モデル（196-207行）

#### 現在のインデックス
```prisma
@@unique([userId, postId])
@@index([userId])
```

#### 問題点

**問題1: ブックマーク一覧の日付ソートが非効率**

```sql
SELECT * FROM bookmarks WHERE user_id = ? ORDER BY created_at DESC
```

**問題2: `postId` の単独インデックス欠落**

投稿のブックマーク数を集計する際に影響：

```sql
SELECT COUNT(*) FROM bookmarks WHERE post_id = ?
```

#### 推奨変更

```prisma
model Bookmark {
  // ... fields ...

  @@unique([userId, postId])
  @@index([userId])
  @@index([postId])                  // 追加：投稿のブックマーク集計
  @@index([userId, createdAt])       // 追加：ブックマーク一覧（日付順）
}
```

#### 影響度: 高
`GET /api/bookmarks` で `orderBy: { createdAt: "desc" }` が使用されています。

---

### 5. Block モデル（246-258行）

#### 現在のインデックス
```prisma
@@unique([blockerId, blockedId])
@@index([blockerId])
@@index([blockedId])
```

#### 問題点

**ブロック一覧の日付ソートが非効率**

`store.ts:1367行目 listBlocks` で以下のクエリが実行されています：

```typescript
prisma.block.findMany({
  where: { blockerId },
  orderBy: { createdAt: "desc" },
})
```

```sql
SELECT * FROM blocks WHERE blocker_id = ? ORDER BY created_at DESC
```

#### 推奨変更

```prisma
model Block {
  // ... fields ...

  @@unique([blockerId, blockedId])
  @@index([blockerId])
  @@index([blockedId])
  @@index([blockerId, createdAt])    // 追加：ブロック一覧（日付順）
}
```

---

### 6. Follow モデル（260-272行）

#### 現在のインデックス
```prisma
@@unique([followerId, followingId])
@@index([followerId])
@@index([followingId])
```

#### 問題点

フォロー一覧を日付順で表示する際に非効率：

```sql
SELECT * FROM follows WHERE follower_id = ? ORDER BY created_at DESC
```

#### 推奨変更

```prisma
model Follow {
  // ... fields ...

  @@unique([followerId, followingId])
  @@index([followerId])
  @@index([followingId])
  @@index([followerId, createdAt])   // 追加：フォロー一覧（日付順）
  @@index([followingId, createdAt])  // 追加：フォロワー一覧（日付順）
}
```

---

### 7. Lesson モデル（274-290行）

#### 現在のインデックス
```prisma
@@index([level])
@@index([order])
```

#### 問題点

レベル別のレッスン一覧を順番で取得する際、2つのインデックスを組み合わせる必要があります：

```sql
SELECT * FROM lessons WHERE level = 'beginner' ORDER BY "order"
```

#### 推奨変更

```prisma
model Lesson {
  // ... fields ...

  @@index([level])
  @@index([order])
  @@index([level, order])            // 追加：レベル別レッスン一覧（順番順）
}
```

---

### 8. LessonCompletion モデル（292-310行）

#### 現在のインデックス
```prisma
@@index([lessonId])
@@index([userId])
@@index([completedAt])
```

#### 問題点

**問題1: ユーザーの学習履歴取得が非効率**

```sql
SELECT * FROM lesson_completions WHERE user_id = ? ORDER BY completed_at DESC
```

**問題2: レッスンのランキング取得が非効率**

```sql
SELECT * FROM lesson_completions WHERE lesson_id = ? ORDER BY wpm DESC LIMIT 10
```

**問題3: ユーザーの特定レッスン進捗確認が非効率**

```sql
SELECT * FROM lesson_completions WHERE user_id = ? AND lesson_id = ?
```

#### 推奨変更

```prisma
model LessonCompletion {
  // ... fields ...

  @@index([lessonId])
  @@index([userId])
  @@index([completedAt])
  @@index([userId, completedAt])     // 追加：ユーザーの学習履歴（日付順）
  @@index([userId, lessonId])        // 追加：ユーザーの特定レッスン進捗
  @@index([lessonId, wpm])           // 追加：レッスンのWPMランキング
  @@index([lessonId, accuracy])      // 追加：レッスンの精度ランキング
}
```

#### 影響度: 高
学習履歴とランキングはアプリの主要機能です。

---

### 9. Wordbook モデル（312-333行）

#### 現在のインデックス
```prisma
@@index([userId])
@@index([category])
@@index([status])
```

#### 問題点

**問題1: ユーザーのステータス別単語帳取得が非効率**

```sql
SELECT * FROM wordbooks WHERE user_id = ? AND status = 'NEEDS_REVIEW'
```

**問題2: ユーザーのカテゴリ別単語帳取得が非効率**

```sql
SELECT * FROM wordbooks WHERE user_id = ? AND category = 'WORDS'
```

**問題3: 復習対象の単語取得が非効率**

```sql
SELECT * FROM wordbooks
WHERE user_id = ? AND status = 'NEEDS_REVIEW'
ORDER BY last_reviewed_at ASC
```

**問題4: 単語帳一覧の日付ソートが非効率**

```sql
SELECT * FROM wordbooks WHERE user_id = ? ORDER BY created_at DESC
```

#### 推奨変更

```prisma
model Wordbook {
  // ... fields ...

  @@index([userId])
  @@index([category])
  @@index([status])
  @@index([userId, status])           // 追加：ステータス別単語帳
  @@index([userId, category])         // 追加：カテゴリ別単語帳
  @@index([userId, createdAt])        // 追加：単語帳一覧（日付順）
  @@index([userId, status, lastReviewedAt])  // 追加：復習対象の取得
}
```

#### 影響度: 高
単語帳は学習機能の中核であり、複数の条件で頻繁にフィルタリングされます。

---

### 10. RankingGameResult モデル（342-363行）

#### 現在のインデックス
```prisma
@@index([userId])
@@index([difficulty])
@@index([score])
@@index([playedAt])
@@index([difficulty, playedAt, score])
```

#### 問題点

**問題1: ユーザーの難易度別成績取得が非効率**

`store.ts:1871行目` で以下のクエリが実行されています：

```typescript
prisma.rankingGameResult.findFirst({
  where: { userId, difficulty },
  orderBy: { score: "desc" },
})
```

```sql
SELECT * FROM ranking_game_results
WHERE user_id = ? AND difficulty = 'beginner'
ORDER BY score DESC
```

**問題2: 最近のプレイ結果取得が非効率**

`store.ts:2243行目 recentResults` で以下のクエリが実行されています：

```typescript
prisma.rankingGameResult.findMany({
  where: { userId },
  orderBy: { playedAt: "desc" },
  take: 10,
})
```

```sql
SELECT * FROM ranking_game_results
WHERE user_id = ?
ORDER BY played_at DESC
LIMIT 10
```

#### 推奨変更

```prisma
model RankingGameResult {
  // ... fields ...

  @@index([userId])
  @@index([difficulty])
  @@index([score])
  @@index([playedAt])
  @@index([difficulty, playedAt, score])
  @@index([userId, difficulty, score])  // 追加：ユーザーの難易度別ベストスコア
  @@index([userId, playedAt])           // 追加：ユーザーの最近のプレイ結果
}
```

#### 影響度: 中
`GET /api/ranking-game/my-stats` で使用されています。

---

### 11. ActivityLog モデル（365-380行）

#### 現在のインデックス
```prisma
@@index([userId])
@@index([userId, completedAt])
@@index([activityType])
```

#### 問題点

**問題1: ユーザーのアクティビティタイプ別履歴取得が非効率**

```sql
SELECT * FROM activity_logs
WHERE user_id = ? AND activity_type = 'lesson'
ORDER BY completed_at DESC
```

#### 推奨変更

```prisma
model ActivityLog {
  // ... fields ...

  @@index([userId])
  @@index([userId, completedAt])
  @@index([activityType])
  @@index([userId, activityType])              // 追加：タイプ別履歴
  @@index([userId, activityType, completedAt]) // 追加：タイプ別履歴（日付順）
}
```

---

### 12. PronunciationGameResult モデル（383-403行）

#### 現在のインデックス
```prisma
@@index([userId])
@@index([difficulty])
@@index([score])
@@index([playedAt])
@@index([difficulty, playedAt, score])
```

#### 問題点

RankingGameResult と同様のクエリパターンがあります：

**問題1: ユーザーの難易度別成績取得が非効率**

```sql
SELECT * FROM pronunciation_game_results
WHERE user_id = ? AND difficulty = ?
ORDER BY score DESC
```

**問題2: 最近のプレイ結果取得が非効率**

```sql
SELECT * FROM pronunciation_game_results
WHERE user_id = ?
ORDER BY played_at DESC
```

#### 推奨変更

```prisma
model PronunciationGameResult {
  // ... fields ...

  @@index([userId])
  @@index([difficulty])
  @@index([score])
  @@index([playedAt])
  @@index([difficulty, playedAt, score])
  @@index([userId, difficulty, score])  // 追加：ユーザーの難易度別ベストスコア
  @@index([userId, playedAt])           // 追加：ユーザーの最近のプレイ結果
}
```

#### 影響度: 中
`GET /api/pronunciation-game/my-stats` で使用されています。

---

### 13. ExchangeRate モデル（406-415行）

#### 現在のインデックス
```prisma
@@unique([baseCurrency, targetCurrency])
@@index([baseCurrency, targetCurrency])
```

#### 問題点

**冗長なインデックス**

`@@unique` 制約により自動的にユニークインデックスが作成されるため、`@@index([baseCurrency, targetCurrency])` は完全に冗長です。

#### 推奨変更

```prisma
model ExchangeRate {
  // ... fields ...

  @@unique([baseCurrency, targetCurrency])
  // @@index([baseCurrency, targetCurrency])  // 削除推奨（冗長）
}
```

---

## 実装優先度

### 高優先度（即時対応推奨）

実際のAPI使用頻度に基づき、以下のインデックスを優先的に追加することを推奨します。

| モデル | 追加インデックス | 理由 | 関連コード |
|--------|-----------------|------|------------|
| Comment | `[postId, createdAt]` | コメント一覧は頻繁に利用される | `store.ts:1015` |
| Bookmark | `[userId, createdAt]` | ブックマーク一覧の日付ソート | `bookmarks/route.ts:17` |
| LessonCompletion | `[userId, completedAt]` | 学習履歴表示の高速化 | `store.ts:1659` |
| LessonCompletion | `[userId, lessonId]` | 特定レッスンの進捗確認 | `store.ts:1753` |
| Wordbook | `[userId, status]` | 復習機能の高速化 | `wordbook/route.ts:38` |
| Wordbook | `[userId, category]` | カテゴリ別フィルタリング | `wordbook/route.ts:38` |
| Wordbook | `[userId, createdAt]` | 単語帳一覧の日付ソート | `wordbook/route.ts:40` |

### 中優先度

| モデル | 追加インデックス | 理由 | 関連コード |
|--------|-----------------|------|------------|
| Follow | `[followerId, createdAt]` | フォロー一覧（日付順） | `store.ts:1292` |
| Follow | `[followingId, createdAt]` | フォロワー一覧（日付順） | `follows/followers/route.ts:27` |
| Block | `[blockerId, createdAt]` | ブロック一覧（日付順） | `store.ts:1367` |
| RankingGameResult | `[userId, difficulty, score]` | 難易度別ベストスコア | `store.ts:1871` |
| RankingGameResult | `[userId, playedAt]` | 最近のプレイ結果 | `store.ts:2243` |
| PronunciationGameResult | `[userId, difficulty, score]` | 難易度別ベストスコア | 同様のパターン |
| PronunciationGameResult | `[userId, playedAt]` | 最近のプレイ結果 | 同様のパターン |

### 低優先度（パフォーマンス問題発生時）

| モデル | 追加インデックス | 理由 |
|--------|-----------------|------|
| Like | `[userId, createdAt]` | いいね履歴（現在未使用） |
| Lesson | `[level, order]` | レベル別レッスン一覧 |
| LessonCompletion | `[lessonId, wpm]` | WPMランキング（管理機能） |
| ActivityLog | `[userId, activityType, completedAt]` | タイプ別アクティビティ統計 |

### 削除推奨（冗長）

| モデル | 削除対象インデックス | 理由 |
|--------|---------------------|------|
| User | `[username]`, `[email]`, `[auth0UserId]` | @unique で自動作成 |
| ExchangeRate | `[baseCurrency, targetCurrency]` | @@unique で自動作成 |

---

## インデックス追加時の注意点

### 1. Write性能への影響

インデックスを追加すると INSERT/UPDATE/DELETE の性能が低下します。過度なインデックス追加は避けてください。

### 2. ストレージ使用量

各インデックスはディスク容量を消費します。特に複合インデックスは単一カラムインデックスより大きくなります。

### 3. マイグレーション時のロック

本番環境で大きなテーブルにインデックスを追加する場合、`CREATE INDEX CONCURRENTLY` の使用を検討してください。Prisma では raw SQL マイグレーションで対応できます。

### 4. 段階的な適用

すべてのインデックスを一度に追加せず、高優先度から順番に適用し、パフォーマンスを監視することを推奨します。

---

## 推奨される完全なスキーマ変更

以下に、推奨されるインデックス変更を反映したスキーマの差分を示します：

```diff
model User {
  // ... fields ...

- @@index([username])
- @@index([email])
- @@index([auth0UserId])
  // 上記3つは @unique で自動作成されるため削除推奨
}

model Comment {
  // ... fields ...

  @@index([postId])
  @@index([userId])
+ @@index([createdAt])
+ @@index([postId, createdAt])
}

model Bookmark {
  // ... fields ...

  @@unique([userId, postId])
  @@index([userId])
+ @@index([postId])
+ @@index([userId, createdAt])
}

model Block {
  // ... fields ...

  @@unique([blockerId, blockedId])
  @@index([blockerId])
  @@index([blockedId])
+ @@index([blockerId, createdAt])
}

model Follow {
  // ... fields ...

  @@unique([followerId, followingId])
  @@index([followerId])
  @@index([followingId])
+ @@index([followerId, createdAt])
+ @@index([followingId, createdAt])
}

model LessonCompletion {
  // ... fields ...

  @@index([lessonId])
  @@index([userId])
  @@index([completedAt])
+ @@index([userId, completedAt])
+ @@index([userId, lessonId])
}

model Wordbook {
  // ... fields ...

  @@index([userId])
  @@index([category])
  @@index([status])
+ @@index([userId, status])
+ @@index([userId, category])
+ @@index([userId, createdAt])
}

model RankingGameResult {
  // ... fields ...

  @@index([userId])
  @@index([difficulty])
  @@index([score])
  @@index([playedAt])
  @@index([difficulty, playedAt, score])
+ @@index([userId, difficulty, score])
+ @@index([userId, playedAt])
}

model PronunciationGameResult {
  // ... fields ...

  @@index([userId])
  @@index([difficulty])
  @@index([score])
  @@index([playedAt])
  @@index([difficulty, playedAt, score])
+ @@index([userId, difficulty, score])
+ @@index([userId, playedAt])
}

model ExchangeRate {
  // ... fields ...

  @@unique([baseCurrency, targetCurrency])
- @@index([baseCurrency, targetCurrency])
  // @@unique で自動作成されるため削除推奨
}
```

---

## 結論

実際のAPI実装（`src/app/api/`および`src/lib/store.ts`）を詳細に分析した結果、以下の主要な改善点が特定されました：

### 重要な発見

1. **日付ソート用の複合インデックス不足**
   - `Comment`, `Bookmark`, `Follow`, `Block` など、日付順でソートされるクエリに対応する複合インデックスが欠落
   - これらは頻繁に実行されるクエリであり、パフォーマンスへの影響が大きい

2. **ユーザー×条件の複合インデックス不足**
   - `Wordbook`, `LessonCompletion`, `RankingGameResult` など、ユーザーIDと他の条件を組み合わせた検索が多い
   - 単独インデックスでは効率的なクエリ実行ができない

3. **冗長なインデックスの存在**
   - `@unique`/`@@unique` 制約があるフィールドに追加で `@@index` を定義している箇所が複数存在
   - これらは削除してストレージを節約可能

### 推奨アクション

1. **高優先度インデックス（7件）を段階的に追加**
   - まず `Comment`, `Bookmark`, `Wordbook` のインデックスを追加
   - 次に `LessonCompletion` のインデックスを追加

2. **冗長インデックス（4件）を削除**
   - `User` モデルの3つの `@@index` を削除
   - `ExchangeRate` モデルの `@@index` を削除

3. **パフォーマンス監視**
   - インデックス追加後、クエリの実行時間を監視
   - PostgreSQL の `pg_stat_user_indexes` を使用してインデックス使用状況を確認

---

*作成日: 2025-12-18*
*分析対象: backend/prisma/schema.prisma, src/app/api/**, src/lib/store.ts*