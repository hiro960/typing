// app/api/users/check-username/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { GET } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser } from '@/lib/test-utils/factories';

/**
 * GET /api/users/check-username のテスト
 *
 * テストケース:
 * - usernameが利用可能（正常系）
 * - usernameが既に使用中（正常系）
 * - username未指定（バリデーションエラー）
 * - username不正フォーマット（バリデーションエラー）
 */
describe('GET /api/users/check-username', () => {
  beforeEach(() => {
    resetPrismaMock();
  });

  describe('正常系', () => {
    it('should return available: true when username is available', async () => {
      // usernameが存在しないことをモック
      prismaMock.user.findUnique.mockResolvedValue(null);

      // リクエストを作成
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=newuser123'
      );

      // APIを呼び出し
      const response = await GET(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(200);
      expect(data.available).toBe(true);

      // Prismaの呼び出し確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({
        where: { username: 'newuser123' },
      });
    });

    it('should return available: false when username already exists', async () => {
      // usernameが既に存在することをモック
      const existingUser = createMockUser({ username: 'existinguser' });
      prismaMock.user.findUnique.mockResolvedValue(existingUser);

      // リクエストを作成
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=existinguser'
      );

      // APIを呼び出し
      const response = await GET(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(200);
      expect(data.available).toBe(false);

      // Prismaの呼び出し確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({
        where: { username: 'existinguser' },
      });
    });
  });

  describe('バリデーションエラー', () => {
    it('should return 400 if username is missing', async () => {
      // usernameパラメータなし
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username'
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('Username is required');
    });

    it('should return 400 if username is too short', async () => {
      // 2文字（最小は3文字）
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=ab'
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('3-20 characters');
    });

    it('should return 400 if username is too long', async () => {
      // 21文字（最大は20文字）
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=' + 'a'.repeat(21)
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('3-20 characters');
    });

    it('should return 400 if username contains invalid characters', async () => {
      // 記号を含む
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=user@name'
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('3-20 characters');
    });

    it('should return 400 if username contains spaces', async () => {
      // スペースを含む
      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=user%20name'
      );

      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
    });
  });

  describe('有効なusername形式', () => {
    it('should accept username with only letters', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=abc'
      );

      const response = await GET(request);
      expect(response.status).toBe(200);
    });

    it('should accept username with only numbers', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=123'
      );

      const response = await GET(request);
      expect(response.status).toBe(200);
    });

    it('should accept username with letters and numbers', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=user123'
      );

      const response = await GET(request);
      expect(response.status).toBe(200);
    });

    it('should accept username with underscores', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=user_name_123'
      );

      const response = await GET(request);
      expect(response.status).toBe(200);
    });

    it('should accept username with exactly 20 characters', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest(
        'http://localhost:3000/api/users/check-username?username=' + 'a'.repeat(20)
      );

      const response = await GET(request);
      expect(response.status).toBe(200);
    });
  });
});
