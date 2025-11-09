// jest.config.ts
import type { Config } from 'jest';
import nextJest from 'next/jest';

const createJestConfig = nextJest({
  // Next.js アプリのルートディレクトリを指定
  dir: './',
});

const config: Config = {
  // カバレッジプロバイダー
  coverageProvider: 'v8',

  // テスト環境（Node.js環境でAPIをテスト）
  testEnvironment: 'node',

  // セットアップファイル
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],

  // モジュールパスのマッピング（@/ を src/ にマップ）
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },

  // テストファイルのパターン
  testMatch: [
    '**/__tests__/**/*.test.ts',
    '**/__tests__/**/*.test.tsx',
    '**/*.test.ts',
    '**/*.test.tsx',
  ],

  // カバレッジ対象ファイル
  collectCoverageFrom: [
    'src/app/api/**/*.ts',
    'src/lib/**/*.ts',
    '!src/lib/test-utils/**/*.ts',
    '!**/*.d.ts',
    '!**/*.config.ts',
    '!**/node_modules/**',
  ],

  // カバレッジ閾値
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },

  // TypeScript のトランスパイル設定
  transform: {
    '^.+\\.(ts|tsx)$': ['ts-jest', {
      tsconfig: {
        jsx: 'react',
      },
    }],
  },

  // 無視するパス
  testPathIgnorePatterns: [
    '/node_modules/',
    '/.next/',
  ],

  // モジュール拡張子
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json'],
};

// Next.js の設定を適用してエクスポート
export default createJestConfig(config);
