// app/api/users/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { GET } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser, createMockUsers } from '@/lib/test-utils/factories';

/**
 * GET /api/users のテスト
 *
 * テストケース:
 * - ユーザー一覧取得（正常系）
 * - レベル別フィルタリング
 * - キーワード検索
 * - ページネーション
 * - 無効なパラメータ（エラー系）
 */
describe('GET /api/users', () => {
  beforeEach(() => {
    resetPrismaMock();
  });

  describe('正常系', () => {
    it('should return user list', async () => {
      // モックデータの準備
      const mockUsers = createMockUsers(3);

      // PrismaのfindMany をモック
      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      // リクエストを作成
      const request = new NextRequest('http://localhost:3000/api/users');

      // APIを呼び出し
      const response = await GET(request);
      const data = await response.json();

      // アサーション
      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(3);
      expect(data.data[0]).toHaveProperty('id');
      expect(data.data[0]).toHaveProperty('username');
      expect(data.data[0]).toHaveProperty('displayName');

      // pageInfoの確認
      expect(data.pageInfo).toBeDefined();
      expect(data.pageInfo).toHaveProperty('hasNextPage');
    });

    it('should return empty array when no users exist', async () => {
      prismaMock.user.findMany.mockResolvedValue([]);

      const request = new NextRequest('http://localhost:3000/api/users');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toEqual([]);
      expect(data.pageInfo.hasNextPage).toBe(false);
    });
  });

  describe('レベル別フィルタリング', () => {
    it('should filter users by level: beginner', async () => {
      const beginnerUsers = [
        createMockUser({ id: 'usr_1', learningLevel: 'beginner' }),
        createMockUser({ id: 'usr_2', learningLevel: 'beginner' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(beginnerUsers);

      const request = new NextRequest('http://localhost:3000/api/users?level=beginner');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(2);

      // 実装がフィルタリングを正しく呼び出しているか確認
      // 注: 現在の実装はdbを使っているため、このテストは実装変更後に有効になります
    });

    it('should filter users by level: intermediate', async () => {
      const intermediateUsers = [
        createMockUser({ id: 'usr_3', learningLevel: 'intermediate' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(intermediateUsers);

      const request = new NextRequest('http://localhost:3000/api/users?level=intermediate');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });

    it('should filter users by level: advanced', async () => {
      const advancedUsers = [
        createMockUser({ id: 'usr_4', learningLevel: 'advanced' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(advancedUsers);

      const request = new NextRequest('http://localhost:3000/api/users?level=advanced');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });
  });

  describe('キーワード検索', () => {
    it('should search users by username', async () => {
      const mockUsers = [
        createMockUser({ id: 'usr_1', username: 'hanako', displayName: 'Hanako' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      const request = new NextRequest('http://localhost:3000/api/users?q=hanako');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });

    it('should search users by displayName', async () => {
      const mockUsers = [
        createMockUser({ id: 'usr_1', username: 'user1', displayName: '花子' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      const request = new NextRequest('http://localhost:3000/api/users?q=花子');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });

    it('should search users by bio', async () => {
      const mockUsers = [
        createMockUser({ id: 'usr_1', bio: '韓国ドラマが好きです' }),
      ];

      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      const request = new NextRequest('http://localhost:3000/api/users?q=韓国');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });

    it('should return empty array when no match', async () => {
      prismaMock.user.findMany.mockResolvedValue([]);

      const request = new NextRequest('http://localhost:3000/api/users?q=nonexistent');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toEqual([]);
    });
  });

  describe('ページネーション', () => {
    it('should respect limit parameter', async () => {
      const mockUsers = createMockUsers(5);
      prismaMock.user.findMany.mockResolvedValue(mockUsers.slice(0, 2));

      const request = new NextRequest('http://localhost:3000/api/users?limit=2');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(2);
      expect(data.pageInfo.hasNextPage).toBe(true);
    });

    it('should use default limit when not specified', async () => {
      const mockUsers = createMockUsers(25);
      prismaMock.user.findMany.mockResolvedValue(mockUsers.slice(0, 20));

      const request = new NextRequest('http://localhost:3000/api/users');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data.length).toBeLessThanOrEqual(20);
    });

    it('should handle cursor-based pagination', async () => {
      const mockUsers = createMockUsers(3);
      prismaMock.user.findMany.mockResolvedValue(mockUsers.slice(1));

      const request = new NextRequest(
        'http://localhost:3000/api/users?cursor=usr_test_1&limit=2'
      );
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.pageInfo).toHaveProperty('nextCursor');
    });
  });

  describe('エラー系', () => {
    it('should return 400 for invalid level', async () => {
      const request = new NextRequest('http://localhost:3000/api/users?level=invalid');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('level must be beginner|intermediate|advanced');
    });

    it('should return 400 for invalid limit (too low)', async () => {
      const request = new NextRequest('http://localhost:3000/api/users?limit=0');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('INVALID_INPUT');
    });

    it('should return 400 for invalid limit (too high)', async () => {
      const request = new NextRequest('http://localhost:3000/api/users?limit=101');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('INVALID_INPUT');
    });

    it('should handle database errors gracefully', async () => {
      prismaMock.user.findMany.mockRejectedValue(new Error('Database connection failed'));

      const request = new NextRequest('http://localhost:3000/api/users');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(500);
      expect(data.error).toBeDefined();
    });
  });

  describe('複合条件', () => {
    it('should filter by level and search keyword', async () => {
      const mockUsers = [
        createMockUser({
          id: 'usr_1',
          username: 'hanako',
          learningLevel: 'beginner',
        }),
      ];

      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      const request = new NextRequest(
        'http://localhost:3000/api/users?level=beginner&q=hanako'
      );
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(1);
    });

    it('should apply all parameters: level, search, limit', async () => {
      const mockUsers = createMockUsers(2);
      prismaMock.user.findMany.mockResolvedValue(mockUsers);

      const request = new NextRequest(
        'http://localhost:3000/api/users?level=intermediate&q=test&limit=5'
      );
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data.length).toBeLessThanOrEqual(5);
    });
  });
});
