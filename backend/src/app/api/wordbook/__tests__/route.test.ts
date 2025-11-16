import { GET as listWordbook, POST } from '../route';
import { PUT, DELETE } from '../[id]/route';
import { GET as stats } from '../stats/route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import {
  createAuthRequest,
  createUnauthRequest,
  mockAuthUser,
  clearAuthMock,
  createMockAuthUser,
} from '@/lib/test-utils/auth-mock';
import { createMockWordbook } from '@/lib/test-utils/factories';

describe('Wordbook API', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('GET /api/wordbook', () => {
    it('should return wordbook entries for the authenticated user', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const entries = [
        createMockWordbook({ id: 'word_1', userId: 'usr_123' }),
        createMockWordbook({ id: 'word_2', userId: 'usr_123', word: '설레다' }),
      ];

      prismaMock.wordbook.findMany.mockResolvedValue(entries);
      prismaMock.wordbook.count.mockResolvedValue(entries.length);

      const request = createAuthRequest('http://localhost:3000/api/wordbook');
      const response = await listWordbook(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.total).toBe(2);
      expect(data.data).toHaveLength(2);
      expect(prismaMock.wordbook.findMany).toHaveBeenCalledWith({
        where: { userId: 'usr_123' },
        orderBy: { createdAt: 'desc' },
      });
    });

    it('should respect category filter and pagination', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      prismaMock.wordbook.findMany.mockResolvedValue([createMockWordbook()]);
      prismaMock.wordbook.count.mockResolvedValue(1);

      const request = createAuthRequest(
        'http://localhost:3000/api/wordbook?category=WORDS&limit=10&offset=20',
      );
      const response = await listWordbook(request);
      expect(response.status).toBe(200);
      expect(prismaMock.wordbook.findMany).toHaveBeenCalledWith({
        where: { userId: 'usr_123', category: 'WORDS' },
        orderBy: { createdAt: 'desc' },
        skip: 20,
        take: 10,
      });
    });

    it('should return 401 when unauthenticated', async () => {
      mockAuthUser(null);
      const request = createUnauthRequest('http://localhost:3000/api/wordbook');
      const response = await listWordbook(request);
      expect(response.status).toBe(401);
    });
  });

  describe('POST /api/wordbook', () => {
    it('should create a new word entry', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const created = createMockWordbook({ userId: 'usr_123' });
      prismaMock.wordbook.findFirst.mockResolvedValue(null);
      prismaMock.wordbook.create.mockResolvedValue(created);

      const request = createAuthRequest('http://localhost:3000/api/wordbook', {
        method: 'POST',
        body: JSON.stringify({
          word: '안녕하세요',
          meaning: 'こんにちは',
          category: 'WORDS',
          status: 'REVIEWING',
          tags: ['挨拶'],
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.word).toBe('안녕하세요');
      expect(prismaMock.wordbook.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          userId: 'usr_123',
          word: '안녕하세요',
        }),
      });
    });

    it('should reject duplicates', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      prismaMock.wordbook.findFirst.mockResolvedValue(createMockWordbook());

      const request = createAuthRequest('http://localhost:3000/api/wordbook', {
        method: 'POST',
        body: JSON.stringify({
          word: '안녕하세요',
          meaning: 'こんにちは',
          category: 'WORDS',
          status: 'REVIEWING',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(409);
      expect(data.error.code).toBe('CONFLICT');
    });
  });

  describe('PUT /api/wordbook/:id', () => {
    it('should update a word entry', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const existing = createMockWordbook({ id: 'word_1', userId: 'usr_123' });
      const updated = createMockWordbook({ id: 'word_1', userId: 'usr_123', status: 'MASTERED' });

      prismaMock.wordbook.findUnique.mockResolvedValue(existing);
      prismaMock.wordbook.findFirst.mockResolvedValue(null);
      prismaMock.wordbook.update.mockResolvedValue(updated);

      const request = createAuthRequest('http://localhost:3000/api/wordbook/word_1', {
        method: 'PUT',
        body: JSON.stringify({ status: 'MASTERED' }),
      });

      const response = await PUT(request, { params: { id: 'word_1' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.status).toBe('MASTERED');
      expect(prismaMock.wordbook.update).toHaveBeenCalledWith({
        where: { id: 'word_1' },
        data: expect.objectContaining({ status: 'MASTERED' }),
      });
    });
  });

  describe('DELETE /api/wordbook/:id', () => {
    it('should delete a word entry', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const existing = createMockWordbook({ id: 'word_1', userId: 'usr_123' });
      prismaMock.wordbook.findUnique.mockResolvedValue(existing);
      prismaMock.wordbook.delete.mockResolvedValue(existing);

      const request = createAuthRequest('http://localhost:3000/api/wordbook/word_1', {
        method: 'DELETE',
      });

      const response = await DELETE(request, { params: { id: 'word_1' } });
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.message).toBe('Word deleted successfully');
      expect(prismaMock.wordbook.delete).toHaveBeenCalledWith({ where: { id: 'word_1' } });
    });
  });

  describe('GET /api/wordbook/stats', () => {
    it('should return stats for the current user', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      prismaMock.wordbook.groupBy.mockResolvedValueOnce([
        { category: 'WORDS', _count: { _all: 5 } },
      ] as any);
      prismaMock.wordbook.groupBy.mockResolvedValueOnce([
        { status: 'REVIEWING', _count: { _all: 3 } },
      ] as any);
      prismaMock.wordbook.aggregate.mockResolvedValue({
        _avg: { successRate: 0.8 },
        _sum: { reviewCount: 10 },
      } as any);
      prismaMock.wordbook.count.mockResolvedValue(5);

      const request = createAuthRequest('http://localhost:3000/api/wordbook/stats');
      const response = await stats(request);
      const data = await response.json();

      expect(response.status).toBe(200);
      expect(data.totalWords).toBe(5);
      expect(data.byCategory.WORDS).toBe(5);
      expect(data.byStatus.REVIEWING).toBe(3);
      expect(data.averageSuccessRate).toBe(0.8);
      expect(data.totalReviewCount).toBe(10);
    });
  });
});
