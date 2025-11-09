// lib/prisma.ts
import { PrismaClient } from '@prisma/client';

/**
 * Prisma Client のシングルトンインスタンス
 *
 * 開発環境では Hot Reload により PrismaClient が複数回インスタンス化されるのを防ぐため、
 * グローバル変数にキャッシュします。
 */
const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  });

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

export default prisma;
