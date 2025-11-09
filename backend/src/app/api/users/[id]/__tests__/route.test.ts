// app/api/users/[id]/__tests__/route.test.ts
import { NextRequest } from 'next/server';
import { GET, PUT } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import { createMockUser } from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  createUnauthRequest,
  mockAuthUser,
  clearAuthMock,
  createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

/**
 * GET /api/users/[id] のテスト
 *
 * テストケース:
 * - ユーザー詳細取得（正常系）
 * - ユーザーが存在しない（404）
 */
describe('GET /api/users/[id]', () => {
  beforeEach(() => {
    resetPrismaMock();
  });

  describe('正常系', () => {
    it('should return user detail by id', async () => {
      const mockUser = createMockUser({ id: 'usr_123', username: 'testuser' });
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      const request = new NextRequest('http://localhost:3000/api/users/usr_123');
      const response = await GET(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.id).toBe('usr_123');
      expect(data.username).toBe('testuser');
      expect(data).toHaveProperty('displayName');
      expect(data).toHaveProperty('email');
      expect(data).toHaveProperty('learningLevel');

      // PrismaのfindUniqueが呼ばれたことを確認
      expect(prismaMock.user.findUnique).toHaveBeenCalledWith({
        where: { id: 'usr_123' },
      });
    });

    it('should return full user details including stats', async () => {
      const mockUser = createMockUser({
        id: 'usr_456',
        totalLessonsCompleted: 10,
        maxWPM: 250,
        maxAccuracy: 0.98,
      });
      prismaMock.user.findUnique.mockResolvedValue(mockUser);

      const request = new NextRequest('http://localhost:3000/api/users/usr_456');
      const response = await GET(request, { params: { id: 'usr_456' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.totalLessonsCompleted).toBe(10);
      expect(data.maxWPM).toBe(250);
      expect(data.maxAccuracy).toBe(0.98);
    });
  });

  describe('エラー系', () => {
    it('should return 404 when user not found', async () => {
      prismaMock.user.findUnique.mockResolvedValue(null);

      const request = new NextRequest('http://localhost:3000/api/users/nonexistent');
      const response = await GET(request, { params: { id: 'nonexistent' } });
      const data = await response.json();

      expect(response.status).toBe(404);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('NOT_FOUND');
      expect(data.error.message).toBe('User not found');
    });

    it('should handle database errors', async () => {
      prismaMock.user.findUnique.mockRejectedValue(new Error('Database error'));

      const request = new NextRequest('http://localhost:3000/api/users/usr_123');
      const response = await GET(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(500);
      expect(data.error).toBeDefined();
    });
  });
});

/**
 * PUT /api/users/[id] のテスト
 *
 * テストケース:
 * - プロフィール更新（正常系）
 * - 認証エラー（401）
 * - 権限エラー（403: 他人のプロフィール）
 * - バリデーションエラー（400）
 * - ユーザーが存在しない（404）
 */
describe('PUT /api/users/[id]', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('正常系', () => {
    it('should update user profile successfully', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const mockUser = createMockUser({
        id: 'usr_123',
        displayName: 'Updated Name',
        bio: 'Updated bio',
      });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            displayName: 'Updated Name',
            bio: 'Updated bio',
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.displayName).toBe('Updated Name');
      expect(data.bio).toBe('Updated bio');

      expect(prismaMock.user.update).toHaveBeenCalledWith({
        where: { id: 'usr_123' },
        data: expect.objectContaining({
          displayName: 'Updated Name',
          bio: 'Updated bio',
        }),
      });
    });

    it('should update learning level', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const mockUser = createMockUser({ id: 'usr_123', learningLevel: 'intermediate' });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            learningLevel: 'intermediate',
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.learningLevel).toBe('intermediate');
    });

    it('should update user settings', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const updatedSettings = {
        theme: 'dark',
        fontSize: 'large',
        soundEnabled: false,
      };

      const mockUser = createMockUser({
        id: 'usr_123',
        settings: updatedSettings,
      });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            settings: updatedSettings,
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.settings).toMatchObject(updatedSettings);
    });

    it('should allow clearing bio with null', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const mockUser = createMockUser({ id: 'usr_123', bio: null });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ bio: null }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.bio).toBeNull();
    });
  });

  describe('認証エラー', () => {
    it('should return 401 when not authenticated', async () => {
      mockAuthUser(null); // 未認証

      const request = createUnauthRequest('http://localhost:3000/api/users/usr_123', {
        method: 'PUT',
        body: JSON.stringify({ displayName: 'New Name' }),
      });

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(401);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('UNAUTHORIZED');
    });
  });

  describe('権限エラー', () => {
    it('should return 403 when updating another user profile', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_456', // 別のユーザーID
        {
          method: 'PUT',
          body: JSON.stringify({ displayName: 'New Name' }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_456' } });
      const data = await response.json();

      expect(response.status).toBe(403);
      expect(data.error).toBeDefined();
      expect(data.error.code).toBe('FORBIDDEN');
    });
  });

  describe('バリデーションエラー', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should return 400 for empty displayName', async () => {
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ displayName: '' }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('displayName');
    });

    it('should return 400 for displayName too long', async () => {
      const longName = 'a'.repeat(41);
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ displayName: longName }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('40 characters');
    });

    it('should return 400 for bio too long', async () => {
      const longBio = 'a'.repeat(281);
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ bio: longBio }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('280 characters');
    });

    it('should return 400 for invalid learningLevel', async () => {
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ learningLevel: 'invalid' }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('beginner|intermediate|advanced');
    });

    it('should return 400 for invalid theme in settings', async () => {
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            settings: { theme: 'invalid' },
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('light|dark|auto');
    });

    it('should return 400 for invalid fontSize in settings', async () => {
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            settings: { fontSize: 'huge' },
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('small|medium|large');
    });

    it('should return 400 for invalid boolean in settings', async () => {
      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            settings: { soundEnabled: 'yes' }, // should be boolean
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('boolean');
    });
  });

  describe('部分更新', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should allow updating only displayName', async () => {
      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const mockUser = createMockUser({ id: 'usr_123', displayName: 'Only Name' });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({ displayName: 'Only Name' }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.displayName).toBe('Only Name');
    });

    it('should allow updating only settings', async () => {
      const currentUser = createMockUser({ id: 'usr_123' });
      prismaMock.user.findUnique.mockResolvedValue(currentUser);

      const mockUser = createMockUser({
        id: 'usr_123',
        settings: { theme: 'dark' },
      });
      prismaMock.user.update.mockResolvedValue(mockUser);

      const request = createAuthRequest(
        'http://localhost:3000/api/users/usr_123',
        {
          method: 'PUT',
          body: JSON.stringify({
            settings: { theme: 'dark' },
          }),
        }
      );

      const response = await PUT(request, { params: { id: 'usr_123' } });
      await response.json();

      expect(response.status).toBe(200);
    });
  });
});
