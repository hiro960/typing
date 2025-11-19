// lib/test-utils/auth-mock.ts
import { NextRequest } from 'next/server';
import { JWTPayload } from 'jose';
import { ERROR } from '../errors';
import { UserDetail } from '../types';

const actualAuthModule = jest.requireActual('../auth') as typeof import('../auth');
import * as authModule from '../auth';

let auth0PayloadSpy:
  | jest.SpiedFunction<typeof actualAuthModule.getAuth0Payload>
  | null = null;

/**
 * 認証テストユーティリティ
 *
 * テスト環境で認証をモック化するためのヘルパー関数集。
 */

/**
 * テスト用の認証済みユーザーを作成
 */
export function createMockAuthUser(overrides?: Partial<UserDetail>): UserDetail {
  return {
    id: 'usr_test_123',
    auth0UserId: 'auth0|test-user-123',
    username: 'testuser',
    displayName: 'Test User',
    email: 'test@example.com',
    profileImageUrl: null,
    bio: null,
    type: 'NORMAL',
    totalLessonsCompleted: 0,
    maxWPM: 0,
    maxAccuracy: 0,
    followersCount: 0,
    followingCount: 0,
    postsCount: 0,
    settings: {
      notifications: {
        push: true,
        email: true,
        comment: true,
        like: true,
        follow: true,
      },
      theme: 'auto',
      fontSize: 'medium',
      language: 'ja',
      soundEnabled: true,
      hapticEnabled: true,
      strictMode: true,
      profileVisibility: 'public',
      postDefaultVisibility: 'public',
    },
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    lastLoginAt: new Date('2024-01-01T00:00:00Z'),
    isActive: true,
    isBanned: false,
    ...overrides,
  };
}

/**
 * 認証ヘッダー付きの NextRequest を作成
 *
 * @param url - リクエストURL
 * @param options - リクエストオプション
 * @param token - 認証トークン（デフォルト: "demo-token-hanako"）
 *
 * @example
 * ```typescript
 * const request = createAuthRequest('http://localhost:3000/api/users/usr_123');
 * const response = await GET(request, { params: { id: 'usr_123' } });
 * ```
 */
type NextRequestOptions = Omit<RequestInit, 'signal'> & { signal?: AbortSignal };

export function createAuthRequest(
  url: string,
  options: RequestInit = {},
  token: string = 'demo-token-hanako'
): NextRequest {
  const headers = new Headers(options.headers);
  headers.set('Authorization', `Bearer ${token}`);

  const { signal, ...rest } = options;
  const init: NextRequestOptions = {
    ...rest,
    headers,
  };
  if (signal instanceof AbortSignal) {
    init.signal = signal;
  }

  return new NextRequest(url, init);
}

/**
 * 認証ヘッダーなしの NextRequest を作成
 *
 * @param url - リクエストURL
 * @param options - リクエストオプション
 *
 * @example
 * ```typescript
 * const request = createUnauthRequest('http://localhost:3000/api/posts');
 * const response = await GET(request);
 * // 401 Unauthorized が返却される
 * ```
 */
export function createUnauthRequest(
  url: string,
  options: RequestInit = {}
): NextRequest {
  const { signal, ...rest } = options;
  const init: NextRequestOptions = { ...rest };
  if (signal instanceof AbortSignal) {
    init.signal = signal;
  }
  return new NextRequest(url, init);
}

// spyの参照を保持
/**
 * auth モジュールの getAuthUser をモック化
 */
export function mockAuthUser(user: UserDetail | null) {
  clearAuthMock();

  const getAuthUserMock = authModule.getAuthUser as jest.MockedFunction<
    typeof authModule.getAuthUser
  >;
  const requireAuthUserMock = authModule.requireAuthUser as jest.MockedFunction<
    typeof authModule.requireAuthUser
  >;

  getAuthUserMock.mockResolvedValue(user);
  requireAuthUserMock.mockImplementation(async () => {
    if (!user) {
      throw ERROR.UNAUTHORIZED();
    }
    return user;
  });
}

export function clearAuthMock() {
  const getAuthUserMock = authModule.getAuthUser as jest.MockedFunction<
    typeof authModule.getAuthUser
  >;
  const requireAuthUserMock = authModule.requireAuthUser as jest.MockedFunction<
    typeof authModule.requireAuthUser
  >;

  getAuthUserMock.mockReset();
  getAuthUserMock.mockImplementation(actualAuthModule.getAuthUser);

  requireAuthUserMock.mockReset();
  requireAuthUserMock.mockImplementation(actualAuthModule.requireAuthUser);
}

/**
 * Auth0 JWTペイロードをモック化（初回登録用エンドポイント向け）
 */
export function mockAuth0Payload(payload: JWTPayload) {
  if (!auth0PayloadSpy) {
    auth0PayloadSpy = jest.spyOn(authModule, 'getAuth0Payload');
  }
  auth0PayloadSpy.mockResolvedValue(payload);
}

/**
 * Auth0ペイロードのモックをクリア
 */
export function clearAuth0PayloadMock() {
  if (auth0PayloadSpy) {
    auth0PayloadSpy.mockRestore();
    auth0PayloadSpy = null;
  }
}

/**
 * テスト用のAuth0ペイロードを作成
 */
export function createMockAuth0Payload(overrides?: Partial<JWTPayload>): JWTPayload {
  return {
    sub: 'auth0|test-user-123',
    email: 'test@example.com',
    name: 'Test User',
    iss: 'https://test.auth0.com/',
    aud: 'https://api.korean-typing.app',
    iat: Math.floor(Date.now() / 1000),
    exp: Math.floor(Date.now() / 1000) + 3600, // 1時間後
    ...overrides,
  };
}

/**
 * テスト用のトークン定数
 */
export const TEST_TOKENS = {
  HANAKO: 'demo-token-hanako',
  GENTA: 'demo-token-genta',
  MINA: 'demo-token-mina',
  INVALID: 'invalid-token',
  EXPIRED: 'expired-token',
} as const;
