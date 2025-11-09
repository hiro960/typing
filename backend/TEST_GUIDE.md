# テスト実装ガイド

このガイドでは、残りのAPIエンドポイントのテスト実装方法を説明します。

---

## 実装済みテスト

以下のエンドポイントはテストが完了しています：

### ユーザーAPI
- ✅ `GET /api/users` - ユーザー一覧取得
- ✅ `GET /api/users/[id]` - ユーザー詳細取得
- ✅ `PUT /api/users/[id]` - ユーザー更新

### ポストAPI
- ✅ `GET /api/posts` - ポスト一覧取得
- ✅ `POST /api/posts` - ポスト作成

### レッスンAPI
- ✅ `POST /api/lessons/complete` - レッスン完了記録

---

## 未実装エンドポイント（13個）

以下のエンドポイントのテストが未実装です。優先度順に記載します。

### 優先度: 高

#### 1. GET /api/users/me
**ファイル**: `src/app/api/users/me/__tests__/route.test.ts`

**テストケース**:
- ✅ 認証済みユーザーの情報取得（200）
- ✅ 未認証（401）

**実装例**:
```typescript
import { GET } from '../route';
import { createAuthRequest, mockAuthUser, createMockAuthUser } from '@/lib/test-utils/auth-mock';

describe('GET /api/users/me', () => {
  it('should return authenticated user info', async () => {
    const authUser = createMockAuthUser({ id: 'usr_123' });
    mockAuthUser(authUser);

    const request = createAuthRequest('http://localhost:3000/api/users/me');
    const response = await GET(request);
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(data.id).toBe('usr_123');
  });

  it('should return 401 when not authenticated', async () => {
    mockAuthUser(null);

    const request = createUnauthRequest('http://localhost:3000/api/users/me');
    const response = await GET(request);

    expect(response.status).toBe(401);
  });
});
```

---

#### 2. GET /api/users/[id]/stats
**ファイル**: `src/app/api/users/[id]/stats/__tests__/route.test.ts`

**テストケース**:
- ✅ 統計情報取得（200）
- ✅ rangeパラメータ（weekly/monthly/all）
- ✅ ユーザーが存在しない（404）

---

#### 3. GET /api/users/[id]/posts
**ファイル**: `src/app/api/users/[id]/posts/__tests__/route.test.ts`

**テストケース**:
- ✅ ユーザーのポスト一覧取得（200）
- ✅ ページネーション
- ✅ visibility制御（自分以外はpublicのみ）
- ✅ ユーザーが存在しない（404）

---

#### 4. GET /api/posts/[id]
**ファイル**: `src/app/api/posts/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ ポスト詳細取得（200）
- ✅ visibility制御（private投稿は作成者のみ閲覧可）
- ✅ ポストが存在しない（404）

---

#### 5. PUT /api/posts/[id]
**ファイル**: `src/app/api/posts/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ ポスト更新（200）
- ✅ 認証エラー（401）
- ✅ 権限エラー（403: 他人のポスト）
- ✅ バリデーションエラー（400）
- ✅ ポストが存在しない（404）

---

#### 6. DELETE /api/posts/[id]
**ファイル**: `src/app/api/posts/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ ポスト削除（204）
- ✅ 認証エラー（401）
- ✅ 権限エラー（403: 他人のポスト）
- ✅ ポストが存在しない（404）

---

### 優先度: 中

#### 7. POST /api/posts/[id]/like
**ファイル**: `src/app/api/posts/[id]/like/__tests__/route.test.ts`

**テストケース**:
- ✅ いいね追加（200）
- ✅ 認証エラー（401）
- ✅ 重複いいね（409）
- ✅ ポストが存在しない（404）

---

#### 8. DELETE /api/posts/[id]/like
**ファイル**: `src/app/api/posts/[id]/like/__tests__/route.test.ts`

**テストケース**:
- ✅ いいね削除（200）
- ✅ 認証エラー（401）
- ✅ いいねしていない（404）

---

#### 9. GET /api/posts/[id]/comments
**ファイル**: `src/app/api/posts/[id]/comments/__tests__/route.test.ts`

**テストケース**:
- ✅ コメント一覧取得（200）
- ✅ ページネーション
- ✅ ポストが存在しない（404）

---

#### 10. POST /api/posts/[id]/comments
**ファイル**: `src/app/api/posts/[id]/comments/__tests__/route.test.ts`

**テストケース**:
- ✅ コメント追加（201）
- ✅ 認証エラー（401）
- ✅ バリデーションエラー（400: 空コメント、長すぎる）
- ✅ ポストが存在しない（404）

---

#### 11. DELETE /api/comments/[id]
**ファイル**: `src/app/api/comments/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ コメント削除（204）
- ✅ 認証エラー（401）
- ✅ 権限エラー（403: 他人のコメント）
- ✅ コメントが存在しない（404）
- ✅ 特例: ポスト作成者は任意のコメントを削除可能

---

### 優先度: 低

#### 12. POST /api/follows
**ファイル**: `src/app/api/follows/__tests__/route.test.ts`

**テストケース**:
- ✅ フォロー追加（201）
- ✅ 認証エラー（401）
- ✅ 重複フォロー（409）
- ✅ 自分自身をフォロー（400）
- ✅ ユーザーが存在しない（404）

---

#### 13. DELETE /api/follows/[id]
**ファイル**: `src/app/api/follows/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ フォロー解除（204）
- ✅ 認証エラー（401）
- ✅ フォローしていない（404）

---

#### 14. GET /api/follows/followers
**ファイル**: `src/app/api/follows/followers/__tests__/route.test.ts`

**テストケース**:
- ✅ フォロワー一覧取得（200）
- ✅ ページネーション
- ✅ userIdパラメータでフィルター

---

#### 15. GET /api/follows/following
**ファイル**: `src/app/api/follows/following/__tests__/route.test.ts`

**テストケース**:
- ✅ フォロー中一覧取得（200）
- ✅ ページネーション
- ✅ userIdパラメータでフィルター

---

#### 16. GET /api/lessons
**ファイル**: `src/app/api/lessons/__tests__/route.test.ts`

**テストケース**:
- ✅ レッスン一覧取得（200）
- ✅ levelフィルター（beginner/intermediate/advanced）
- ✅ orderパラメータ（asc/desc）
- ✅ ページネーション

---

#### 17. GET /api/lessons/[id]
**ファイル**: `src/app/api/lessons/[id]/__tests__/route.test.ts`

**テストケース**:
- ✅ レッスン詳細取得（200）
- ✅ contentフィールドを含む
- ✅ レッスンが存在しない（404）

---

#### 18. GET /api/lessons/stats
**ファイル**: `src/app/api/lessons/stats/__tests__/route.test.ts`

**テストケース**:
- ✅ 学習統計取得（200）
- ✅ 認証必須（401）
- ✅ rangeパラメータ（daily/weekly/monthly）
- ✅ levelフィルター

---

#### 19. GET /api/health
**ファイル**: `src/app/api/health/__tests__/route.test.ts`

**テストケース**:
- ✅ ヘルスチェック（200）
- ✅ timestampを含む

**実装例**:
```typescript
import { GET } from '../route';

describe('GET /api/health', () => {
  it('should return 200 with timestamp', async () => {
    const request = new NextRequest('http://localhost:3000/api/health');
    const response = await GET(request);
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(data).toHaveProperty('timestamp');
    expect(data.status).toBe('ok');
  });
});
```

---

## テスト実装のベストプラクティス

### 1. テストファイルの構造

```typescript
// app/api/[resource]/__tests__/route.test.ts
import { GET, POST } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMock[Resource] } from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  mockAuthUser,
  clearAuthMock,
} from '@/lib/test-utils/auth-mock';

describe('[HTTP_METHOD] /api/[resource]', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('正常系', () => {
    // ハッピーパステスト
  });

  describe('認証エラー', () => {
    // 401テスト
  });

  describe('権限エラー', () => {
    // 403テスト
  });

  describe('バリデーションエラー', () => {
    // 400テスト
  });

  describe('エラー系', () => {
    // 404, 409, 422, 500テスト
  });
});
```

---

### 2. Prisma Mockの使い方

```typescript
// データ取得のモック
prismaMock.user.findUnique.mockResolvedValue(mockUser);

// データ作成のモック
prismaMock.post.create.mockResolvedValue(mockPost);

// データ更新のモック
prismaMock.user.update.mockResolvedValue(updatedUser);

// データ削除のモック
prismaMock.post.delete.mockResolvedValue(deletedPost);

// リスト取得のモック
prismaMock.post.findMany.mockResolvedValue(mockPosts);

// エラーのモック
prismaMock.user.findUnique.mockRejectedValue(new Error('DB error'));
```

---

### 3. 認証のモック

```typescript
// 認証済みユーザー
const authUser = createMockAuthUser({ id: 'usr_123' });
mockAuthUser(authUser);

// 未認証
mockAuthUser(null);

// リクエスト作成
const request = createAuthRequest('http://localhost:3000/api/users', {
  method: 'POST',
  body: JSON.stringify({ content: 'test' }),
});
```

---

### 4. アサーションのパターン

```typescript
// ステータスコード
expect(response.status).toBe(200);

// レスポンスボディ
expect(data.id).toBe('usr_123');
expect(data).toHaveProperty('username');

// エラーレスポンス
expect(data.error).toBeDefined();
expect(data.error.code).toBe('INVALID_INPUT');
expect(data.error.message).toContain('required');

// Prismaの呼び出し確認
expect(prismaMock.user.create).toHaveBeenCalledWith({
  data: expect.objectContaining({
    username: 'testuser',
  }),
});

// 呼び出し回数
expect(prismaMock.user.findMany).toHaveBeenCalledTimes(1);
```

---

### 5. テストデータの作成

```typescript
// ファクトリー関数を使用
const mockUser = createMockUser({
  id: 'usr_123',
  username: 'testuser',
});

// 複数データの一括生成
const mockUsers = createMockUsers(5);
const mockPosts = createMockPosts(10, 'usr_123');
```

---

## テストの実行

### 全テスト実行
```bash
npm test
```

### 特定ファイルのみ実行
```bash
npm test -- users/route.test.ts
```

### Watch モード
```bash
npm run test:watch
```

### カバレッジ確認
```bash
npm run test:coverage
```

---

## カバレッジ目標

| カテゴリ | 目標 |
|---------|------|
| 主要API | 80%+ |
| ユーティリティ | 70%+ |
| 全体 | 70%+ |

---

## トラブルシューティング

### Prismaモックが動作しない

**原因**: モックのリセットを忘れている

**解決策**:
```typescript
beforeEach(() => {
  resetPrismaMock();
});
```

### 認証モックが動作しない

**原因**: モックのクリアを忘れている

**解決策**:
```typescript
beforeEach(() => {
  clearAuthMock();
});
```

### テストが依存し合っている

**原因**: グローバル状態が共有されている

**解決策**:
- 各テストで独立したモックデータを使用
- beforeEach で状態をリセット

---

## 参考リンク

- [Jest公式ドキュメント](https://jestjs.io/)
- [jest-mock-extended](https://github.com/marchaos/jest-mock-extended)
- [Next.js Testing](https://nextjs.org/docs/app/building-your-application/testing/jest)

---

## 次のステップ

1. 優先度の高いエンドポイントから順にテストを実装
2. 各テストファイルで同じパターンを使用
3. テストカバレッジを確認し、70%以上を目指す
4. CI/CDパイプラインに統合
