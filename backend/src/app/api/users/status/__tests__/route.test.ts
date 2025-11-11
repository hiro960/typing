// app/api/users/status/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { GET } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser } from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  createUnauthRequest,
  mockAuth0Payload,
  clearAuth0PayloadMock,
  createMockAuth0Payload,
} from '@/lib/test-utils/auth-mock';

/**
 * GET /api/users/status のテスト
 *
 * テストケース:
 * - 登録済みユーザー（正常系）
 * - 未登録ユーザー（正常系）
 * - 認証エラー
 */
describe('GET /api/users/status', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuth0PayloadMock();
  });

  describe('正常系', () => {
    it('should return registered: true with user data for registered users', async () => {
      // Auth0ペイロードをモック
      const auth0Payload = createMockAuth0Payload({
        sub: 'auth0|registered-user-123',
        email: 'registered@example.com',
      });
      mockAuth0Payload(auth0Payload);

      // ユーザーが存在することをモック
      const mockUser = createMockUser({
        id: 'usr_registered_123',
        auth0UserId: 'auth0|registered-user-123',
        username: 'registereduser',
        displayName: 'Registered User',
        email: 'registered@example.com',
      });
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      // リクエストを作成
      const request = createAuthRequest('http://localhost:3000/api/users/status');

      // APIを呼び出し
      const response = await GET(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(200);
      expect(data.registered).toBe(true);
      expect(data.user).toBeDefined();
      expect(data.user.id).toBe('usr_registered_123');
      expect(data.user.username).toBe('registereduser');
      expect(data.user.auth0UserId).toBe('auth0|registered-user-123');
      expect(data.user.email).toBe('registered@example.com');

      // Prismaの呼び出し確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({
        where: { auth0UserId: 'auth0|registered-user-123' },
      });
    });

    it('should return registered: false for unregistered users', async () => {
      // Auth0ペイロードをモック（認証は成功）
      const auth0Payload = createMockAuth0Payload({
        sub: 'auth0|unregistered-user-123',
        email: 'unregistered@example.com',
      });
      mockAuth0Payload(auth0Payload);

      // ユーザーが存在しないことをモック
      prismaMock.user.findUnique.mockResolvedValue(null);

      // リクエストを作成
      const request = createAuthRequest('http://localhost:3000/api/users/status');

      // APIを呼び出し
      const response = await GET(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(200);
      expect(data.registered).toBe(false);
      expect(data.user).toBeUndefined();

      // Prismaの呼び出し確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({
        where: { auth0UserId: 'auth0|unregistered-user-123' },
      });
    });
  });

  describe('認証エラー', () => {
    it('should return 401 if authorization header is missing', async () => {
      // 認証ヘッダーなしのリクエスト
      const request = createUnauthRequest('http://localhost:3000/api/users/status');

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
      expect(data.error.message).toContain('authorization header');
    });

    it('should return 401 if token is invalid', async () => {
      // Auth0ペイロードをモックせず、実際の検証を試みる（失敗する）
      clearAuth0PayloadMock();

      const request = createAuthRequest(
        'http://localhost:3000/api/users/status',
        {},
        'invalid-token'
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
    });

    it('should return 401 if token is missing sub claim', async () => {
      // subが欠けているペイロードをモック
      const auth0Payload = createMockAuth0Payload({ sub: undefined });
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest('http://localhost:3000/api/users/status');

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
      expect(data.error.message).toContain('missing sub claim');
    });
  });

  describe('ユーザー情報の完全性', () => {
    it('should return complete user details including settings', async () => {
      const auth0Payload = createMockAuth0Payload({ sub: 'auth0|complete-user' });
      mockAuth0Payload(auth0Payload);

      const mockUser = createMockUser({
        auth0UserId: 'auth0|complete-user',
        bio: 'Test bio',
        totalLessonsCompleted: 10,
        maxWPM: 50,
        maxAccuracy: 95.5,
      });
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      const request = createAuthRequest('http://localhost:3000/api/users/status');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.registered).toBe(true);
      expect(data.user.bio).toBe('Test bio');
      expect(data.user.totalLessonsCompleted).toBe(10);
      expect(data.user.maxWPM).toBe(50);
      expect(data.user.maxAccuracy).toBe(95.5);
      expect(data.user.settings).toBeDefined();
      expect(data.user.settings.theme).toBe('auto');
    });
  });
});
