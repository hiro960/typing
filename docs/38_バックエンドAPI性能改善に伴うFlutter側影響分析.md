# バックエンドAPI性能改善に伴うFlutter側影響分析

## 概要

バックエンドAPI性能改善（docs/36_バックエンドAPI性能分析レポート.md参照）の実装に伴い、Flutter側（application）への影響を分析したレポートです。

**結論: Flutter側では基本的に変更が不要です。**

バックエンド側のページネーション改善（全件取得→DBレベルページネーション）を行っても、既存のFlutter実装はそのまま機能します。

---

## 1. バックエンド側で実施した変更

### 1.1 N+1問題の解消
- `canAccessPostSync`関数を追加し、ループ内クエリを排除
- 影響エンドポイント: `/api/bookmarks`, `/api/users/[id]/posts`, `/api/search`

### 1.2 DBレベルページネーション化

| エンドポイント | 変更内容 |
|--------------|---------|
| `/api/follows/following` | メモリページネーション → DBレベルページネーション |
| `/api/follows/followers` | メモリページネーション → DBレベルページネーション |
| `/api/users` | メモリページネーション → DBレベルページネーション |
| `/api/posts/[id]/comments` | メモリページネーション → DBレベルページネーション |
| `/api/lessons` | メモリページネーション → DBレベルページネーション |
| `/api/users/[id]/posts` | メモリページネーション → DBレベルページネーション |

### 1.3 不要なincludeの削減
- ユーザー存在確認のみの箇所で軽量クエリを使用
- `getPostForAccessCheck`関数を追加

---

## 2. Flutter側への影響分析

### 2.1 カーソル処理 - 問題なし

Flutter側はカーソルを**不透明な文字列**として扱っており、カーソルを解析・パースするコードは存在しません。

**現在の実装パターン（推奨される方法）:**
```dart
// diary_repository.dart
final response = await _apiClient.dio.get(
  '/api/posts',
  queryParameters: {
    'cursor': cursor,  // そのまま送信
    'limit': limit,
  },
);
```

バックエンド側でカーソル形式が変更されても（例: `createdAt:id` → `cuid`）、Flutter側は影響を受けません。

### 2.2 pageInfo構造 - 問題なし

Flutter側の`DiaryPageInfo`モデルは、バックエンドのレスポンス形式と完全に一致しています。

**Flutter側の型定義:**
```dart
// diary_post.dart
@freezed
abstract class DiaryPageInfo with _$DiaryPageInfo {
  const factory DiaryPageInfo({
    String? nextCursor,
    @Default(false) bool hasNextPage,
    @Default(0) int count,
  }) = _DiaryPageInfo;
}
```

**バックエンドのレスポンス形式（維持）:**
```json
{
  "data": [...],
  "pageInfo": {
    "nextCursor": "...",
    "hasNextPage": true,
    "count": 20
  }
}
```

### 2.3 状態管理 - 問題なし

Riverpodの各Stateクラスで`nextCursor`と`hasMore`を適切に管理しています。

```dart
// diary_providers.dart
class DiaryFeedData {
  final String? nextCursor;
  final bool hasMore;
  // ...
}
```

---

## 3. 現在のFlutter実装の課題（機能強化の機会）

### 3.1 ProfileRepositoryのページネーション未対応

現在、フォロー/フォロワー一覧はカーソルパラメータに対応していません。

**現状（profile_repository.dart）:**
```dart
Future<List<UserModel>> fetchFollowers(
  String userId, {
  int limit = 20,  // cursorパラメータなし
}) async {
  final response = await _apiClient.dio.get(
    '/api/follows/followers',
    queryParameters: {
      'userId': userId,
      'limit': limit,
    },
  );
  // ...
}
```

**推奨改善:**
```dart
Future<FollowersPage> fetchFollowers(
  String userId, {
  String? cursor,
  int limit = 20,
}) async {
  final response = await _apiClient.dio.get(
    '/api/follows/followers',
    queryParameters: {
      'userId': userId,
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    },
  );
  // pageInfo付きで返却
}

class FollowersPage {
  final List<UserModel> users;
  final DiaryPageInfo pageInfo;
}
```

### 3.2 ページネーション未対応のエンドポイント

| API | Flutter側の現状 | 推奨対応 |
|-----|----------------|---------|
| `/api/follows/followers` | `List<UserModel>`を返却、全件ロード | cursorパラメータ追加、無限スクロール対応 |
| `/api/follows/following` | `List<UserModel>`を返却、全件ロード | cursorパラメータ追加、無限スクロール対応 |
| `/api/users/[id]/posts` | DiaryFeedPageで対応済み | 対応不要 |
| `/api/lessons` | 全件取得（レッスン数が少ないため問題なし） | 優先度低 |

---

## 4. 推奨アクション

### 即時対応（必須）

**なし** - バックエンド側の変更のみでFlutter側は自動的に恩恵を受けます。

### 機能強化（推奨）

フォロー/フォロワー一覧の無限スクロール対応を実装すると、フォロー数が多いユーザーでのUXが向上します。

**対象ファイル:**
- `lib/features/profile/data/repositories/profile_repository.dart`
- `lib/features/profile/domain/providers/profile_providers.dart`

**実装内容:**
1. `fetchFollowers()`と`fetchFollowing()`にcursorパラメータを追加
2. `FollowersPage`/`FollowingPage`モデルを作成（pageInfo付き）
3. Providerで`nextCursor`と`hasMore`を管理
4. UI側で無限スクロールリスト実装

---

## 5. 検証チェックリスト

バックエンド改善後の動作確認項目:

- [ ] 投稿フィード - ページネーションが正常に動作するか
- [ ] ブックマーク一覧 - ページネーションが正常に動作するか
- [ ] コメント一覧 - ページネーションが正常に動作するか
- [ ] フォロー一覧 - 最初のページが正常に取得できるか
- [ ] フォロワー一覧 - 最初のページが正常に取得できるか
- [ ] ユーザー検索 - ページネーションが正常に動作するか
- [ ] レッスン一覧 - 正常に取得できるか

---

## 6. まとめ

| 項目 | 状況 |
|-----|------|
| カーソル処理 | 問題なし（不透明文字列として処理） |
| pageInfo型定義 | 問題なし（完全互換） |
| 状態管理 | 問題なし（適切に実装済み） |
| 必須の変更 | **なし** |
| 推奨の機能強化 | ProfileRepositoryのページネーション対応 |

**バックエンド側の性能改善により、Flutter側のコード変更なしで以下の恩恵を受けられます:**
- APIレスポンス時間の短縮（N+1問題解消）
- サーバーメモリ使用量の削減（DBレベルページネーション）
- 大量データ時の安定性向上

---

*作成日: 2024年12月18日*
*関連ドキュメント: docs/36_バックエンドAPI性能分析レポート.md*
