// lib/test-utils/factories.ts
import { User, Post, Comment, Lesson, LessonCompletion, Follow, Like, Wordbook } from '@prisma/client';

/**
 * テストデータファクトリー
 *
 * 各モデルのテストデータを簡単に生成するためのヘルパー関数集。
 * 部分的な上書きが可能で、テストごとに必要なフィールドだけを指定できます。
 */

/**
 * User のテストデータを生成
 */
export function createMockUser(overrides?: Partial<User>): User {
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
    settings: null,
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    lastLoginAt: new Date('2024-01-01T00:00:00Z'),
    isActive: true,
    isBanned: false,
    ...overrides,
  };
}

/**
 * Post のテストデータを生成
 */
export function createMockPost(overrides?: Partial<Post>): Post {
  return {
    id: 'post_test_123',
    content: 'テスト投稿です',
    imageUrls: [],
    tags: [],
    shareToDiary: true,
    visibility: 'public',
    userId: 'usr_test_123',
    likesCount: 0,
    commentsCount: 0,
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * Comment のテストデータを生成
 */
export function createMockComment(overrides?: Partial<Comment>): Comment {
  return {
    id: 'cmt_test_123',
    content: 'テストコメントです',
    postId: 'post_test_123',
    userId: 'usr_test_123',
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * Like のテストデータを生成
 */
export function createMockLike(overrides?: Partial<Like>): Like {
  return {
    id: 'like_test_123',
    postId: 'post_test_123',
    userId: 'usr_test_123',
    createdAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * Follow のテストデータを生成
 */
export function createMockFollow(overrides?: Partial<Follow>): Follow {
  return {
    id: 'follow_test_123',
    followerId: 'usr_test_123',
    followingId: 'usr_test_456',
    createdAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * Lesson のテストデータを生成
 */
export function createMockLesson(overrides?: Partial<Lesson>): Lesson {
  return {
    id: 'lesson_test_123',
    title: 'テストレッスン',
    description: 'テスト用のレッスンです',
    level: 'beginner',
    order: 1,
    content: {
      blocks: [
        { type: 'text', content: 'テストコンテンツ' },
      ],
    },
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * LessonCompletion のテストデータを生成
 */
export function createMockLessonCompletion(
  overrides?: Partial<LessonCompletion>
): LessonCompletion {
  return {
    id: 'completion_test_123',
    lessonId: 'lesson_test_123',
    userId: 'usr_test_123',
    wpm: 200,
    accuracy: 0.95,
    timeSpent: 180,
    completedAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}

/**
 * 複数ユーザーのテストデータを一括生成
 */
export function createMockUsers(count: number): User[] {
  return Array.from({ length: count }, (_, i) =>
    createMockUser({
      id: `usr_test_${i + 1}`,
      auth0UserId: `auth0|test-user-${i + 1}`,
      username: `testuser${i + 1}`,
      email: `test${i + 1}@example.com`,
    })
  );
}

/**
 * 複数ポストのテストデータを一括生成
 */
export function createMockPosts(count: number, userId: string = 'usr_test_123'): Post[] {
  return Array.from({ length: count }, (_, i) =>
    createMockPost({
      id: `post_test_${i + 1}`,
      content: `テスト投稿 ${i + 1}`,
      userId,
      createdAt: new Date(`2024-01-${String(i + 1).padStart(2, '0')}T00:00:00Z`),
    })
  );
}

/**
 * Wordbook のテストデータを生成
 */
export function createMockWordbook(overrides?: Partial<Wordbook>): Wordbook {
  return {
    id: 'word_test_123',
    userId: 'usr_test_123',
    word: '안녕하세요',
    meaning: 'こんにちは',
    example: '안녕하세요? 오늘도 열공해요!',
    status: 'REVIEWING',
    category: 'WORDS',
    lastReviewedAt: null,
    reviewCount: 0,
    successRate: 0,
    tags: [],
    createdAt: new Date('2024-01-01T00:00:00Z'),
    updatedAt: new Date('2024-01-01T00:00:00Z'),
    ...overrides,
  };
}
