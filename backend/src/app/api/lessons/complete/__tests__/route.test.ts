// app/api/lessons/complete/__tests__/route.test.ts
import { POST } from '../route';
import { prismaMock, resetPrismaMock } from '@/lib/test-utils/prisma-mock';
import {
  createMockLessonCompletion,
  createMockLesson,
  createMockUser,
} from '@/lib/test-utils/factories';
import {
  createAuthRequest,
  createUnauthRequest,
  mockAuthUser,
  clearAuthMock,
  createMockAuthUser,
} from '@/lib/test-utils/auth-mock';

/**
 * POST /api/lessons/complete のテスト
 *
 * テストケース:
 * - レッスン完了記録（正常系）
 * - 認証エラー（401）
 * - バリデーションエラー（400）
 * - レッスンが存在しない（404）
 */
describe('POST /api/lessons/complete', () => {
  beforeEach(() => {
    resetPrismaMock();
    clearAuthMock();
  });

  describe('正常系', () => {
    it('should record lesson completion successfully', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockUser = createMockUser({ id: 'usr_123', maxWPM: 150, maxAccuracy: 0.9 });
      const mockCompletion = createMockLessonCompletion({
        lessonId: 'lesson_1',
        userId: 'usr_123',
        wpm: 200,
        accuracy: 0.95,
        timeSpent: 180,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.user.update.mockResolvedValue(mockUser);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.lessonId).toBe('lesson_1');
      expect(data.userId).toBe('usr_123');
      expect(data.wpm).toBe(200);
      expect(data.accuracy).toBe(0.95);
      expect(data.timeSpent).toBe(180);

      expect(prismaMock.lessonCompletion.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          lessonId: 'lesson_1',
          userId: 'usr_123',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });
    });

    it('should record completion with device and mode', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockUser = createMockUser({ id: 'usr_123', maxWPM: 200, maxAccuracy: 0.95 });
      const mockCompletion = createMockLessonCompletion({
        lessonId: 'lesson_1',
        userId: 'usr_123',
        wpm: 250,
        accuracy: 0.98,
        timeSpent: 150,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.user.update.mockResolvedValue(mockUser);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 250,
          accuracy: 0.98,
          timeSpent: 150,
          device: 'android',
          mode: 'challenge',
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });

    it('should use default values for device and mode', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockUser = createMockUser({ id: 'usr_123' });
      const mockCompletion = createMockLessonCompletion({
        lessonId: 'lesson_1',
        userId: 'usr_123',
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.user.update.mockResolvedValue(mockUser);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
      // device: ios, mode: standard がデフォルト
    });

    it('should record high WPM achievement', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockUser = createMockUser({ id: 'usr_123', maxWPM: 300 });
      const mockCompletion = createMockLessonCompletion({
        userId: 'usr_123',
        wpm: 500,
        accuracy: 0.99,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.user.update.mockResolvedValue(mockUser);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 500,
          accuracy: 0.99,
          timeSpent: 60,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.wpm).toBe(500);
    });

    it('should accept perfect accuracy (1.0)', async () => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);

      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockUser = createMockUser({ id: 'usr_123' });
      const mockCompletion = createMockLessonCompletion({
        accuracy: 1.0,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.user.findUnique.mockResolvedValue(mockUser);
      prismaMock.user.update.mockResolvedValue(mockUser);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 1.0,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(201);
      expect(data.accuracy).toBe(1.0);
    });
  });

  describe('認証エラー', () => {
    it('should return 401 when not authenticated', async () => {
      mockAuthUser(null);

      const request = createUnauthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
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

    it('should return 400 when lessonId is missing', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('lessonId');
    });

    it('should return 400 when wpm is not a number', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 'fast',
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('wpm');
    });

    it('should return 400 when wpm is negative', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: -10,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('positive');
    });

    it('should return 400 when wpm is zero', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 0,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
    });

    it('should return 400 when accuracy is not a number', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 'high',
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('accuracy');
    });

    it('should return 400 when accuracy is less than 0', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: -0.1,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('between 0 and 1');
    });

    it('should return 400 when accuracy is greater than 1', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 1.5,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('between 0 and 1');
    });

    it('should return 400 when timeSpent is not a number', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: '180',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('timeSpent');
    });

    it('should return 400 when timeSpent is not an integer', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180.5,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('integer');
    });

    it('should return 400 when timeSpent is negative', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: -10,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('positive');
    });

    it('should return 400 for invalid device', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
          device: 'windows',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('ios|android|web');
    });

    it('should return 400 for invalid mode', async () => {
      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
          mode: 'expert',
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(400);
      expect(data.error.code).toBe('INVALID_INPUT');
      expect(data.error.message).toContain('standard|challenge');
    });
  });

  describe('レッスンが存在しない（404）', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should return 404 when lesson does not exist', async () => {
      prismaMock.lesson.findUnique.mockResolvedValue(null);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'nonexistent',
          wpm: 200,
          accuracy: 0.95,
          timeSpent: 180,
        }),
      });

      const response = await POST(request);
      const data = await response.json();

      expect(response.status).toBe(404);
      expect(data.error.code).toBe('NOT_FOUND');
    });
  });

  describe('エッジケース', () => {
    beforeEach(() => {
      const authUser = createMockAuthUser({ id: 'usr_123' });
      mockAuthUser(authUser);
    });

    it('should handle very high WPM values', async () => {
      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockCompletion = createMockLessonCompletion({
        wpm: 1000,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 1000,
          accuracy: 0.95,
          timeSpent: 60,
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });

    it('should handle very long timeSpent', async () => {
      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockCompletion = createMockLessonCompletion({
        timeSpent: 3600, // 1時間
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 100,
          accuracy: 0.80,
          timeSpent: 3600,
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });

    it('should handle zero accuracy (0.0)', async () => {
      const mockLesson = createMockLesson({ id: 'lesson_1' });
      const mockCompletion = createMockLessonCompletion({
        accuracy: 0.0,
      });

      prismaMock.lesson.findUnique.mockResolvedValue(mockLesson);
      prismaMock.lessonCompletion.create.mockResolvedValue(mockCompletion);

      const request = createAuthRequest('http://localhost:3000/api/lessons/complete', {
        method: 'POST',
        body: JSON.stringify({
          lessonId: 'lesson_1',
          wpm: 50,
          accuracy: 0.0,
          timeSpent: 300,
        }),
      });

      const response = await POST(request);

      expect(response.status).toBe(201);
    });
  });
});
