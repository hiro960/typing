// lib/test-utils/prisma-mock.ts
import { PrismaClient } from '@prisma/client';
import { mockDeep, mockReset, DeepMockProxy } from 'jest-mock-extended';

/**
 * Prisma Client のモック
 *
 * jest-mock-extended を使用して PrismaClient 全体をモックします。
 * 各テストで独立したモック状態を保つため、beforeEach で mockReset を呼び出してください。
 */

// prisma モジュール全体をモック
jest.mock('../prisma', () => ({
  __esModule: true,
  default: mockDeep<PrismaClient>(),
  prisma: mockDeep<PrismaClient>(),
}));

// モック化された prisma インスタンスをインポート
import prisma from '../prisma';

/**
 * 型安全な Prisma モック
 *
 * @example
 * ```typescript
 * import { prismaMock } from '@/lib/test-utils/prisma-mock';
 *
 * prismaMock.user.findUnique.mockResolvedValue({
 *   id: 'usr_123',
 *   username: 'testuser',
 *   // ...
 * });
 * ```
 */
export const prismaMock = prisma as unknown as DeepMockProxy<PrismaClient>;

/**
 * すべてのモックをリセット
 *
 * 各テストの beforeEach で呼び出して、モック状態をクリーンにします。
 *
 * @example
 * ```typescript
 * beforeEach(() => {
 *   resetPrismaMock();
 * });
 * ```
 */
export function resetPrismaMock() {
  mockReset(prismaMock);
  prismaMock.$transaction.mockImplementation(async (callback: unknown) => {
    if (typeof callback === "function") {
      return callback(prismaMock);
    }
    if (Array.isArray(callback)) {
      return Promise.all(callback);
    }
    return callback;
  });
}

// 初期化時にも$transactionのデフォルト実装を設定
resetPrismaMock();
