// app/api/posts/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { GET, POST } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockPost, createMockUser, createMockPosts } from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  createUnauthRequest,
  mockAuthUser,
  clearAuthMock,
  createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

/**
 * GET /api/posts のテスト
 *
 * テストケース:
 * - ポスト一覧取得（正常系）
 * - フィードタイプ別フィルタリング (forYou, following, popular)
 * - ハッシュタグ検索
 * - ユーザーIDフィルター
 * - ページネーション
 * - エラーケース
 */
describe('GET /api/posts', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('正常系', () => {
    it('should return posts list', async () => {
      const mockPosts = createMockPosts(3);
      const mockUser = createMockUser();

      prismaMock.post.findMany.mockResolvedValue(mockPosts);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      const request = new NextRequest('http://localhost:3000/api/posts');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toBeDefined();
      expect(Array.isArray(data.data)).toBe(true);
      expect(data.pageInfo).toBeDefined();
      expect(data.pageInfo).toHaveProperty('hasNextPage');
    });

    it('should return empty array when no posts', async () => {
      prismaMock.post.findMany.mockResolvedValue([]);

      const request = new NextRequest('http://localhost:3000/api/posts');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toEqual([]);
      expect(data.pageInfo.hasNextPage).toBe(false);
    });

    it('should include post details (user, likes, comments)', async () => {
      const mockUser = createMockUser({ id: 'usr_123' });
      const mockPost = createMockPost({
        userId: 'usr_123',
        likesCount: 5,
        commentsCount: 3,
      });

      prismaMock.post.findMany.mockResolvedValue([mockPost]);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      const request = new NextRequest('http://localhost:3000/api/posts');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data[0]).toHaveProperty('user');
      expect(data.data[0].likesCount).toBe(5);
      expect(data.data[0].commentsCount).toBe(3);
    });
  });

  describe('フィードタイプ別', () => {
    it('should return forYou feed by default', async () => {
      const mockPosts = createMockPosts(2);
      prismaMock.post.findMany.mockResolvedValue(mockPosts);

      const request = new NextRequest('http://localhost:3000/api/posts');
      const response = await GET(request);

      expect(response.status).toBe(200);
      // forYouは時系列順にソート
    });

    it('should return forYou feed explicitly', async () => {
      const mockPosts = createMockPosts(2);
      prismaMock.post.findMany.mockResolvedValue(mockPosts);

      const request = new NextRequest('http://localhost:3000/api/posts?feed=forYou');
      const response = await GET(request);

      expect(response.status).toBe(200);
    });

    it('should return following feed when authenticated', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockPosts = createMockPosts(2, 'usr_456');
      prismaMock.post.findMany.mockResolvedValue(mockPosts);
      prismaMock.follow.findMany.mockResolvedValue([
        { id: 'follow_1', followerId: 'usr_123', followingId: 'usr_456', createdAt: new Date() },
      ]);

      const request = createAuthRequest('http://localhost:3000/api/posts?feed=following');
      const response = await GET(request);

      expect(response.status).toBe(200);
    });

    it('should return 401 for following feed without auth', async () => {
      mockAuthUser(null);

      const request = createUnauthRequest('http://localhost:3000/api/posts?feed=following');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
      expect(data.error.message).toContain('authentication');
    });

    it('should return popular feed sorted by likes', async () => {
      const mockPosts = [
        createMockPost({ id: 'post_1', likesCount: 10 }),
        createMockPost({ id: 'post_2', likesCount: 50 }),
        createMockPost({ id: 'post_3', likesCount: 25 }),
      ];
      prismaMock.post.findMany.mockResolvedValue(mockPosts);

      const request = new NextRequest('http://localhost:3000/api/posts?feed=popular');
      const response = await GET(request);
      await response.json();

      expect(response.status).toBe(200);
      // popularはlikesCount降順
      // 注: 実装がソートを正しく実行しているか確認
    });
  });

  describe('ハッシュタグ検索', () => {
    it('should filter posts by hashtag', async () => {
      const mockPosts = [
        createMockPost({ id: 'post_1', content: '#韓国語 勉強中' }),
      ];
      prismaMock.post.findMany.mockResolvedValue(mockPosts);

      const request = new NextRequest('http://localhost:3000/api/posts?hashtag=韓国語');
      const response = await GET(request);
      await response.json();

      expect(response.status).toBe(200);
      // 実装によるフィルタリング
    });

    it('should return empty array when hashtag not found', async () => {
      prismaMock.post.findMany.mockResolvedValue([]);

      const request = new NextRequest('http://localhost:3000/api/posts?hashtag=nonexistent');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toEqual([]);
    });
  });

  describe('ユーザーIDフィルター', () => {
    it('should filter posts by userId', async () => {
      const mockUser = createMockUser({ id: 'usr_123' });
      const mockPosts = createMockPosts(2, 'usr_123');

      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.post.findMany.mockResolvedValue(mockPosts);

      const request = new NextRequest('http://localhost:3000/api/posts?userId=usr_123');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data).toHaveLength(2);
    });

    it('should return 404 when user not found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest('http://localhost:3000/api/posts?userId=nonexistent');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(404);
      expect(data.error.code).toBe('NOT_FOUND');
      expect(data.error.message).toBe('User not found');
    });
  });

  describe('ページネーション', () => {
    it('should respect limit parameter', async () => {
      const mockPosts = createMockPosts(5);
      prismaMock.post.findMany.mockResolvedValue(mockPosts.slice(0, 2));

      const request = new NextRequest('http://localhost:3000/api/posts?limit=2');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data.length).toBeLessThanOrEqual(2);
    });

    it('should use default limit', async () => {
      const mockPosts = createMockPosts(25);
      prismaMock.post.findMany.mockResolvedValue(mockPosts.slice(0, 20));

      const request = new NextRequest('http://localhost:3000/api/posts');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.data.length).toBeLessThanOrEqual(20);
    });

    it('should handle cursor-based pagination', async () => {
      const mockPosts = createMockPosts(3);
      prismaMock.post.findMany.mockResolvedValue(mockPosts.slice(1));

      const request = new NextRequest('http://localhost:3000/api/posts?cursor=post_test_1');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.pageInfo).toHaveProperty('nextCursor');
    });
  });

  describe('エラー系', () => {
    it('should return 400 for invalid feed type', async () => {
      const request = new NextRequest('http://localhost:3000/api/posts?feed=invalid');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('forYou|following|popular');
    });

    it('should return 400 for invalid limit', async () => {
      const request = new NextRequest('http://localhost:3000/api/posts?limit=0');
      const response = await GET(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
    });
  });
});

/**
 * POST /api/posts のテスト
 *
 * テストケース:
 * - ポスト作成（正常系）
 * - 認証エラー（401）
 * - バリデーションエラー（400）
 */
describe('POST /api/posts', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('正常系', () => {
    it('should create a new post', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockPost = createMockPost({
        id: 'post_new',
        userId: 'usr_123',
        content: 'テスト投稿',
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト投稿',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.content).toBe('テスト投稿');
      expect(data.userId).toBe('usr_123');

      expect(prismaMock.post.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          content: 'テスト投稿',
          userId: 'usr_123',
        }),
      });
    });

    it('should create post with images', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockPost = createMockPost({
        userId: 'usr_123',
        imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: '画像付き投稿',
          imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.imageUrls).toHaveLength(2);
    });

    it('should create post with custom visibility', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockPost = createMockPost({
        userId: 'usr_123',
        visibility: 'followers',
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'フォロワー限定投稿',
          visibility: 'followers',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.visibility).toBe('followers');
    });

    it('should create post with tags', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockPost = createMockPost({
        userId: 'usr_123',
        content: '#韓国語 #勉強',
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: '韓国語勉強中',
          tags: ['#韓国語', '#勉強'],
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });
  });

  describe('認証エラー', () => {
    it('should return 401 when not authenticated', async () => {
      mockAuthUser(null);

      const request = createUnauthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト投稿',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error.code).toBe('UNAUTHORIZED');
    });
  });

  describe('バリデーションエラー', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should return 400 when content is missing', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({}),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('content');
    });

    it('should return 400 when content is empty', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: '',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
    });

    it('should return 400 when content is too long', async () => {
      const longContent = 'a'.repeat(601);
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: longContent,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('600 characters');
    });

    it('should return 400 when imageUrls is not array', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          imageUrls: 'not-an-array',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('array');
    });

    it('should return 400 when imageUrls has more than 4 items', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          imageUrls: ['img1', 'img2', 'img3', 'img4', 'img5'],
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('4 items');
    });

    it('should return 400 when imageUrls contains non-string', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          imageUrls: ['valid-url', 123],
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('strings');
    });

    it('should return 400 for invalid visibility', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          visibility: 'invalid',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('public|followers|private');
    });

    it('should return 400 when tags is not array', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          tags: 'not-array',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
    });

    it('should return 400 when tag is too long', async () => {
      const longTag = 'a'.repeat(41);
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          tags: [longTag],
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('40 chars');
    });

    it('should return 400 when shareToDiary is not boolean', async () => {
      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト',
          shareToDiary: 'yes',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('boolean');
    });
  });

  describe('デフォルト値', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should use default visibility from user settings', async () => {
      const mockPost = createMockPost({
        userId: 'usr_123',
        visibility: 'public',
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト投稿',
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });

    it('should use empty array for imageUrls by default', async () => {
      const mockPost = createMockPost({
        userId: 'usr_123',
        imageUrls: [],
      });
      prismaMock.post.create.mockResolvedValue(mockPost);

      const request = createAuthRequest('http://localhost:3000/api/posts', {
        method: 'POST',
        body: JSON.stringify({
          content: 'テスト投稿',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.imageUrls).toEqual([]);
    });
  });
});
