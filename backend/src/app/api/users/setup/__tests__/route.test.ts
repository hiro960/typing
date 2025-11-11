// app/api/users/setup/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { POST } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser } from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  mockAuth0Payload,
  clearAuth0PayloadMock,
  createMockAuth0Payload,
} from '@/lib/test-utils/auth-mock';

/**
 * POST /api/users/setup のテスト
 *
 * テストケース:
 * - 初回ユーザー登録（正常系）
 * - バリデーションエラー（username不正、displayName不正等）
 * - 重複エラー（username, email, auth0UserId）
 * - 認証エラー
 */
describe('POST /api/users/setup', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuth0PayloadMock();
  });

  describe('正常系', () => {
    it('should create a new user successfully', async () => {
      // Auth0ペイロードをモック
      const auth0Payload = createMockAuth0Payload({
        sub: 'auth0|new-user-123',
        email: 'newuser@example.com',
      });
      mockAuth0Payload(auth0Payload);

      // 重複チェック用のモック（存在しない）
      prismaMock.user.findUnique.mockResolvedValue(null);

      // ユーザー作成のモック
      const mockUser = createMockUser({
        id: 'usr_new_123',
        auth0UserId: 'auth0|new-user-123',
        username: 'newuser123',
        displayName: 'New User',
        email: 'newuser@example.com',
      });
      prismaMock.user.create.mockResolvedValue(mockUser);

      // リクエストを作成
      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'newuser123',
            displayName: 'New User',
            bio: 'Hello, I am a new user!',
            profileImageUrl: 'https://example.com/avatar.jpg',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      // APIを呼び出し
      const response = await POST(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(201);
      expect(data.id).toBe('usr_new_123');
      expect(data.username).toBe('newuser123');
      expect(data.displayName).toBe('New User');
      expect(data.auth0UserId).toBe('auth0|new-user-123');
      expect(data.email).toBe('newuser@example.com');

      // Prismaの呼び出し確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledTimes(3); // auth0UserId, username, email
      expect(prismaMock.user.create).toHaveBeenCalledTimes(1);
    });

    it('should create a user without optional fields', async () => {
      // Auth0ペイロードをモック
      const auth0Payload = createMockAuth0Payload({
        sub: 'auth0|minimal-user-123',
        email: 'minimal@example.com',
      });
      mockAuth0Payload(auth0Payload);

      // 重複チェック用のモック
      prismaMock.user.findUnique.mockResolvedValue(null);

      // ユーザー作成のモック
      const mockUser = createMockUser({
        id: 'usr_minimal_123',
        auth0UserId: 'auth0|minimal-user-123',
        username: 'minimal123',
        displayName: 'Minimal User',
        email: 'minimal@example.com',
        bio: null,
        profileImageUrl: null,
      });
      prismaMock.user.create.mockResolvedValue(mockUser);

      // リクエストを作成（bio, profileImageUrlなし）
      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'minimal123',
            displayName: 'Minimal User',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      // APIを呼び出し
      const response = await POST(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(201);
      expect(data.username).toBe('minimal123');
      expect(data.bio).toBeNull();
      expect(data.profileImageUrl).toBeNull();
    });
  });

  describe('バリデーションエラー', () => {
    it('should return 400 if username is missing', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            displayName: 'Test User',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('Username');
    });

    it('should return 400 if displayName is missing', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'testuser',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('Display name');
    });

    it('should return 400 if username format is invalid', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'a!', // 短すぎる＆記号を含む
            displayName: 'Test User',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('3-20 characters');
    });

    it('should return 400 if displayName is too long', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'testuser',
            displayName: 'a'.repeat(51), // 51文字
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('1-50 characters');
    });

    it('should return 400 if bio is too long', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'testuser',
            displayName: 'Test User',
            bio: 'a'.repeat(161), // 161文字
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('160 characters');
    });
  });

  describe('重複エラー', () => {
    it('should return 409 if username already exists', async () => {
      const auth0Payload = createMockAuth0Payload();
      mockAuth0Payload(auth0Payload);

      // auth0UserIdのチェック: 存在しない
      prismaMock.user.findUnique.mockResolvedValueOnce(null);
      // usernameのチェック: 存在する
      prismaMock.user.findUnique.mockResolvedValueOnce(
        createMockUser({ username: 'duplicateuser' })
      );

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'duplicateuser',
            displayName: 'Test User',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(409);
      expect(data.error.code).toBe('CONFLICT');
      expect(data.error.message).toContain('Username already taken');
    });

    it('should return 409 if auth0UserId already registered', async () => {
      const auth0Payload = createMockAuth0Payload({ sub: 'auth0|existing-user' });
      mockAuth0Payload(auth0Payload);

      // auth0UserIdのチェック: 存在する
      prismaMock.user.findUnique.mockResolvedValueOnce(
        createMockUser({ auth0UserId: 'auth0|existing-user' })
      );

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'newuser',
            displayName: 'Test User',
          }),
          headers: { 'Content-Type': 'application/json' },
        }
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(409);
      expect(data.error.code).toBe('CONFLICT');
      expect(data.error.message).toContain('User already registered');
    });
  });

  describe('認証エラー', () => {
    it('should return 401 if token is invalid', async () => {
      // Auth0ペイロードをモックせず、実際の検証を試みる（失敗する）
      clearAuth0PayloadMock();

      const request = createAuthRequest(
        'http://localhost:3000/api/users/setup',
        {
          method: 'POST',
          body: JSON.stringify({
            username: 'testuser',
            displayName: 'Test User',
          }),
          headers: { 'Content-Type': 'application/json' },
        },
        'invalid-token'
      );

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
    });
  });
});
