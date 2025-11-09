// jest.setup.ts

/**
 * Jest グローバルセットアップファイル
 *
 * すべてのテストファイルが実行される前に一度だけ実行されます。
 */

// Authモジュールをテスト用にモック
jest.mock('@/lib/auth', () => {
  const actual = jest.requireActual('@/lib/auth');
  return {
    __esModule: true,
    ...actual,
    getAuthUser: jest.fn(actual.getAuthUser),
    requireAuthUser: jest.fn(actual.requireAuthUser),
  };
});

// 環境変数の設定
process.env.AUTH0_ISSUER_BASE_URL = 'https://test-tenant.auth0.com';
process.env.AUTH0_AUDIENCE = 'https://api.korean-typing.app';
process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/test';

// タイムゾーンの設定（統一性のため）
process.env.TZ = 'UTC';

// テストタイムアウトの設定（デフォルト5秒）
jest.setTimeout(10000);

// グローバルなモック設定
// Prisma の $transaction をグローバルにモック
// トランザクション内のコールバックを直接実行し、prismaMock を tx として渡す
import { prismaMock } from './src/lib/test-utils/prisma-mock';

beforeEach(() => {
  // $transaction のデフォルト実装
  // @ts-ignore
  prismaMock.$transaction.mockImplementation(async (callback: any) => {
    // コールバックを prismaMock をトランザクションクライアントとして実行
    return await callback(prismaMock);
  });
});

// 各テスト後にすべてのspyをクリーンアップ
afterEach(() => {
  jest.restoreAllMocks();
});
