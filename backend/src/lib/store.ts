import {
  Prisma,
  User,
  Post as PrismaPost,
  Lesson as PrismaLesson,
  LessonCompletion as PrismaLessonCompletion,
} from "@prisma/client";
import prisma from "@/lib/prisma";
import { ERROR } from "@/lib/errors";
import {
  CommentResponse,
  DeviceType,
  Lesson,
  LessonMode,
  LessonStatsRange,
  LessonStatsResponse,
  LearningLevel,
  PostRecord,
  PostResponse,
  UserDetail,
  UserSettings,
  UserStatsRange,
  UserStatsResponse,
  UserSummary,
  Visibility,
} from "@/lib/types";

const defaultSettings: UserSettings = {
  notifications: {
    push: true,
    email: true,
    comment: true,
    like: true,
    follow: true,
  },
  theme: "auto",
  fontSize: "medium",
  language: "ja",
  soundEnabled: true,
  hapticEnabled: true,
  strictMode: true,
  profileVisibility: "public",
  postDefaultVisibility: "public",
};

type UserSummarySource = Pick<
  User,
  | "id"
  | "username"
  | "displayName"
  | "profileImageUrl"
  | "type"
  | "followersCount"
  | "followingCount"
  | "postsCount"
>;

type PostWithUser = Prisma.PostGetPayload<{
  include: { user: true };
}>;

type PostWithOptionalUser = PrismaPost & { user?: User | null };

type CommentWithUser = Prisma.CommentGetPayload<{
  include: { user: true };
}>;

function cloneDefaultSettings(): UserSettings {
  return {
    ...defaultSettings,
    notifications: { ...defaultSettings.notifications },
  };
}

function isJsonObject(value: Prisma.JsonValue | null): value is Prisma.JsonObject {
  return !!value && typeof value === "object" && !Array.isArray(value);
}

function parseUserSettings(value: Prisma.JsonValue | null): UserSettings {
  if (!isJsonObject(value)) {
    return cloneDefaultSettings();
  }
  const parsed = value as Partial<UserSettings>;
  return {
    ...cloneDefaultSettings(),
    ...parsed,
    notifications: {
      ...cloneDefaultSettings().notifications,
      ...(parsed.notifications ?? {}),
    },
  };
}

function mergeSettings(
  current: Prisma.JsonValue | null,
  updates?: Partial<UserSettings>
): UserSettings {
  if (!updates) {
    return parseUserSettings(current);
  }

  const base = parseUserSettings(current);
  return {
    ...base,
    ...updates,
    notifications: {
      ...base.notifications,
      ...(updates.notifications ?? {}),
    },
  };
}

function serializeSettings(settings: UserSettings): Prisma.JsonObject {
  return {
    ...settings,
    notifications: { ...settings.notifications },
  } as Prisma.JsonObject;
}

export function toUserSummary(user: UserSummarySource): UserSummary {
  return {
    id: user.id,
    username: user.username,
    displayName: user.displayName,
    profileImageUrl: user.profileImageUrl,
    type: user.type,
    followersCount: user.followersCount,
    followingCount: user.followingCount,
    postsCount: user.postsCount,
    settings: null,
  };
}

function toUserDetail(user: User): UserDetail {
  return {
    ...toUserSummary(user),
    auth0UserId: user.auth0UserId,
    email: user.email,
    bio: user.bio,
    totalLessonsCompleted: user.totalLessonsCompleted,
    maxWPM: user.maxWPM,
    maxAccuracy: user.maxAccuracy,
    lastLoginAt: user.lastLoginAt ?? null,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
    isActive: user.isActive,
    isBanned: user.isBanned,
    settings: parseUserSettings(user.settings),
  };
}

export async function findUserById(userId: string): Promise<UserDetail | null> {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  return user ? toUserDetail(user) : null;
}

/**
 * Auth0ユーザーIDでユーザーを検索
 */
export async function findUserByAuth0Id(auth0UserId: string): Promise<UserDetail | null> {
  const user = await prisma.user.findUnique({ where: { auth0UserId } });
  return user ? toUserDetail(user) : null;
}

/**
 * usernameが利用可能かチェック
 * @returns true: 利用可能, false: 既に使用中
 */
export async function checkUsernameAvailability(username: string): Promise<boolean> {
  const existing = await prisma.user.findUnique({ where: { username } });
  return !existing;
}

/**
 * Auth0認証後の初回ユーザー登録
 */
export async function createUserFromAuth0(params: {
  auth0UserId: string;
  username: string;
  displayName: string;
  email: string;
  bio?: string;
  profileImageUrl?: string;
}): Promise<UserDetail> {
  // auth0UserIdの重複チェック
  const existingAuth0 = await prisma.user.findUnique({
    where: { auth0UserId: params.auth0UserId },
  });
  if (existingAuth0) {
    throw ERROR.CONFLICT("User already registered");
  }

  // usernameの重複チェック
  const existingUsername = await prisma.user.findUnique({
    where: { username: params.username },
  });
  if (existingUsername) {
    throw ERROR.CONFLICT("Username already taken");
  }

  // emailの重複チェック
  const existingEmail = await prisma.user.findUnique({
    where: { email: params.email },
  });
  if (existingEmail) {
    throw ERROR.CONFLICT("Email already registered");
  }

  // ユーザー作成
  const user = await prisma.user.create({
    data: {
      auth0UserId: params.auth0UserId,
      username: params.username,
      displayName: params.displayName,
      email: params.email,
      bio: params.bio ?? null,
      profileImageUrl: params.profileImageUrl ?? null,
      settings: serializeSettings(cloneDefaultSettings()),
    },
  });

  return toUserDetail(user);
}

export async function updateUserProfile(
  userId: string,
  updates: {
    displayName?: string;
    bio?: string | null;
    settings?: Partial<UserSettings>;
  }
): Promise<UserDetail> {
  const current = await prisma.user.findUnique({ where: { id: userId } });
  if (!current) {
    throw ERROR.NOT_FOUND("User not found");
  }

  const mergedSettings = updates.settings
    ? mergeSettings(current.settings, updates.settings)
    : null;

  const updated = await prisma.user.update({
    where: { id: userId },
    data: {
      displayName: typeof updates.displayName === "undefined" ? undefined : updates.displayName,
      bio: typeof updates.bio === "undefined" ? undefined : updates.bio,
      settings: mergedSettings ? serializeSettings(mergedSettings) : undefined,
    },
  });

  return toUserDetail(updated);
}

function toPostRecord(post: PrismaPost): PostRecord {
  return {
    id: post.id,
    content: post.content,
    imageUrls: post.imageUrls,
    tags: post.tags ?? [],
    shareToDiary: post.shareToDiary ?? true,
    visibility: post.visibility as Visibility,
    userId: post.userId,
    createdAt: post.createdAt,
    updatedAt: post.updatedAt,
    likesCount: post.likesCount,
    commentsCount: post.commentsCount,
  };
}

async function isPostLikedByUser(postId: string, userId?: string) {
  if (!userId) return false;
  const like = await prisma.like.findUnique({
    where: { postId_userId: { postId, userId } },
    select: { id: true },
  });
  return !!like;
}

export async function toPostResponse(
  post: PostWithOptionalUser,
  viewerId?: string
): Promise<PostResponse> {
  const author =
    post.user ?? (await prisma.user.findUnique({ where: { id: post.userId } })) ?? null;
  const userSummary = author
    ? toUserSummary(author)
    : {
        id: post.userId,
        username: "unknown",
        displayName: "Unknown",
        profileImageUrl: null,
        type: "NORMAL" as const,
        followersCount: 0,
        followingCount: 0,
        postsCount: 0,
        settings: null,
      };
  const liked = await isPostLikedByUser(post.id, viewerId);
  return {
    ...toPostRecord(post),
    user: userSummary,
    liked,
    bookmarked: false,
  };
}

export function getPostById(postId: string) {
  return prisma.post.findUnique({
    where: { id: postId },
    include: { user: true },
  });
}

export function createPost(params: {
  userId: string;
  content: string;
  imageUrls: string[];
  visibility: Visibility;
  tags: string[];
  shareToDiary: boolean;
}) {
  return prisma.post.create({
    data: {
      userId: params.userId,
      content: params.content,
      imageUrls: params.imageUrls,
      visibility: params.visibility,
      tags: params.tags,
      shareToDiary: params.shareToDiary,
    },
  });
}

export function updatePost(postId: string, updates: Partial<PostRecord>) {
  return prisma.post.update({
    where: { id: postId },
    data: {
      content: updates.content,
      imageUrls: updates.imageUrls,
      visibility: updates.visibility,
      tags: updates.tags,
      shareToDiary: updates.shareToDiary,
    },
    include: { user: true },
  });
}

export async function deletePost(postId: string) {
  await prisma.post.delete({ where: { id: postId } });
}

export function addLike(postId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.like.findUnique({
      where: { postId_userId: { postId, userId } },
    });
    if (existing) {
      throw ERROR.CONFLICT("Already liked");
    }

    await tx.like.create({ data: { postId, userId } });
    return tx.post.update({
      where: { id: postId },
      data: { likesCount: { increment: 1 } },
      include: { user: true },
    });
  });
}

export function removeLike(postId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.like.findUnique({
      where: { postId_userId: { postId, userId } },
    });
    if (!existing) {
      throw ERROR.NOT_FOUND("Like not found");
    }

    await tx.like.delete({ where: { id: existing.id } });
    return tx.post.update({
      where: { id: postId },
      data: { likesCount: { decrement: 1 } },
      include: { user: true },
    });
  });
}

function toCommentResponseInternal(comment: CommentWithUser): CommentResponse {
  return {
    id: comment.id,
    content: comment.content,
    postId: comment.postId,
    createdAt: comment.createdAt,
    updatedAt: comment.updatedAt,
    user: toUserSummary(comment.user),
    likesCount: 0,
  };
}

export async function listComments(postId: string): Promise<CommentResponse[]> {
  const comments = await prisma.comment.findMany({
    where: { postId },
    include: { user: true },
    orderBy: { createdAt: "asc" },
  });
  return comments.map(toCommentResponseInternal);
}

export function findCommentById(commentId: string) {
  return prisma.comment.findUnique({ where: { id: commentId } });
}

export async function addComment(
  postId: string,
  userId: string,
  content: string
): Promise<CommentResponse> {
  const comment = await prisma.$transaction(async (tx) => {
    const created = await tx.comment.create({
      data: { postId, userId, content },
      include: { user: true },
    });
    await tx.post.update({
      where: { id: postId },
      data: { commentsCount: { increment: 1 } },
    });
    return created;
  });
  return toCommentResponseInternal(comment);
}

export async function removeComment(commentId: string) {
  await prisma.$transaction(async (tx) => {
    const comment = await tx.comment.findUnique({ where: { id: commentId } });
    if (!comment) {
      throw ERROR.NOT_FOUND("Comment not found");
    }
    await tx.comment.delete({ where: { id: commentId } });
    await tx.post.update({
      where: { id: comment.postId },
      data: { commentsCount: { decrement: 1 } },
    });
  });
}

export function toCommentResponse(comment: CommentResponse) {
  return comment;
}

export function addFollow(followerId: string, followingId: string) {
  if (followerId === followingId) {
    throw ERROR.INVALID_INPUT("Cannot follow yourself");
  }

  return prisma.$transaction(async (tx) => {
    const target = await tx.user.findUnique({ where: { id: followingId } });
    if (!target) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const existing = await tx.follow.findUnique({
      where: { followerId_followingId: { followerId, followingId } },
    });
    if (existing) {
      throw ERROR.CONFLICT("Already following");
    }

    const follow = await tx.follow.create({
      data: { followerId, followingId },
    });

    await tx.user.update({
      where: { id: followerId },
      data: { followingCount: { increment: 1 } },
    });

    await tx.user.update({
      where: { id: followingId },
      data: { followersCount: { increment: 1 } },
    });

    return follow;
  });
}

export function removeFollow(followerId: string, followingId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.follow.findUnique({
      where: { followerId_followingId: { followerId, followingId } },
    });
    if (!existing) {
      throw ERROR.NOT_FOUND("Follow relationship not found");
    }

    await tx.follow.delete({ where: { id: existing.id } });

    await tx.user.update({
      where: { id: followerId },
      data: { followingCount: { decrement: 1 } },
    });

    await tx.user.update({
      where: { id: followingId },
      data: { followersCount: { decrement: 1 } },
    });
  });
}

export async function listFollowers(userId: string): Promise<UserSummary[]> {
  const follows = await prisma.follow.findMany({
    where: { followingId: userId },
    include: { follower: true },
    orderBy: { createdAt: "desc" },
  });
  return follows.map((follow) => toUserSummary(follow.follower));
}

export async function listFollowing(userId: string): Promise<UserSummary[]> {
  const follows = await prisma.follow.findMany({
    where: { followerId: userId },
    include: { following: true },
    orderBy: { createdAt: "desc" },
  });
  return follows.map((follow) => toUserSummary(follow.following));
}

export async function isFollowingUser(followerId: string, followingId: string) {
  const follow = await prisma.follow.findUnique({
    where: { followerId_followingId: { followerId, followingId } },
    select: { id: true },
  });
  return !!follow;
}

export async function canViewPost(post: PrismaPost, viewerId?: string) {
  if (post.visibility === "public") {
    return true;
  }
  if (!viewerId) {
    return false;
  }
  if (post.userId === viewerId) {
    return true;
  }
  if (post.visibility === "followers") {
    return isFollowingUser(viewerId, post.userId);
  }
  return false;
}

export async function getLessonById(lessonId: string) {
  const lesson = await prisma.lesson.findUnique({ where: { id: lessonId } });
  return lesson ? toLesson(lesson) : null;
}

export async function listLessons() {
  const lessons = await prisma.lesson.findMany();
  return lessons.map(toLesson);
}

export async function recordLessonCompletion(params: {
  lessonId: string;
  userId: string;
  wpm: number;
  accuracy: number;
  timeSpent: number;
  device: DeviceType;
  mode: LessonMode;
}) {
  const lesson = await prisma.lesson.findUnique({ where: { id: params.lessonId } });
  if (!lesson) {
    throw ERROR.NOT_FOUND("Lesson not found");
  }

  const user = await prisma.user.findUnique({ where: { id: params.userId } });

  const completion = await prisma.lessonCompletion.create({
    data: {
      lessonId: params.lessonId,
      userId: params.userId,
      wpm: params.wpm,
      accuracy: params.accuracy,
      timeSpent: params.timeSpent,
      device: params.device,
      mode: params.mode,
    },
  });

  if (user) {
    await prisma.user.update({
      where: { id: params.userId },
      data: {
        totalLessonsCompleted: { increment: 1 },
        maxWPM: params.wpm > user.maxWPM ? params.wpm : user.maxWPM,
        maxAccuracy: params.accuracy > user.maxAccuracy ? params.accuracy : user.maxAccuracy,
      },
    });
  }

  return completion;
}

export async function getUserStats(
  userId: string,
  range: UserStatsRange
): Promise<UserStatsResponse> {
  const days = range === "weekly" ? 7 : range === "monthly" ? 30 : undefined;
  const since = days ? new Date(Date.now() - days * 24 * 60 * 60 * 1000) : undefined;

  const completions = await prisma.lessonCompletion.findMany({
    where: {
      userId,
      ...(since ? { completedAt: { gte: since } } : {}),
    },
    orderBy: { completedAt: "asc" },
  });

  if (completions.length === 0) {
    return {
      wpmAvg: 0,
      accuracyAvg: 0,
      lessonsCompleted: 0,
      streakDays: 0,
      histories: [],
    };
  }

  const wpmAvg =
    completions.reduce((sum, item) => sum + item.wpm, 0) / completions.length;
  const accuracyAvg =
    completions.reduce((sum, item) => sum + item.accuracy, 0) / completions.length;

  const grouped = completions.reduce<Record<string, { wpm: number[]; accuracy: number[] }>>(
    (acc, item) => {
      const date = item.completedAt.toISOString().substring(0, 10);
      if (!acc[date]) {
        acc[date] = { wpm: [], accuracy: [] };
      }
      acc[date].wpm.push(item.wpm);
      acc[date].accuracy.push(item.accuracy);
      return acc;
    },
    {}
  );

  const histories = Object.entries(grouped)
    .sort(([a], [b]) => (a > b ? 1 : -1))
    .map(([date, values]) => ({
      date,
      wpm: values.wpm.reduce((sum, value) => sum + value, 0) / values.wpm.length,
      accuracy:
        values.accuracy.reduce((sum, value) => sum + value, 0) / values.accuracy.length,
    }));

  const streakDays = calculateStreak(completions);

  return {
    wpmAvg: Number(wpmAvg.toFixed(2)),
    accuracyAvg: Number(accuracyAvg.toFixed(2)),
    lessonsCompleted: completions.length,
    streakDays,
    histories,
  };
}

function calculateStreak(completions: PrismaLessonCompletion[]) {
  if (completions.length === 0) return 0;

  const uniqueDates = Array.from(
    new Set(completions.map((item) => item.completedAt.toISOString().substring(0, 10)))
  ).sort((a, b) => (a > b ? -1 : 1));

  let streak = 0;
  let previousDate: Date | null = null;

  for (const dateStr of uniqueDates) {
    const date = new Date(dateStr);
    if (!previousDate) {
      streak = 1;
      previousDate = date;
      continue;
    }

    const expected = new Date(previousDate);
    expected.setDate(expected.getDate() - 1);
    if (date.toISOString().substring(0, 10) === expected.toISOString().substring(0, 10)) {
      streak += 1;
      previousDate = date;
    } else {
      break;
    }
  }

  return streak;
}

export async function getLessonStats(
  userId: string,
  range: LessonStatsRange,
  level?: LearningLevel
): Promise<LessonStatsResponse> {
  const days =
    range === "daily" ? 1 : range === "weekly" ? 7 : range === "monthly" ? 30 : 7;
  const since = new Date(Date.now() - days * 24 * 60 * 60 * 1000);

  const completions = await prisma.lessonCompletion.findMany({
    where: { userId, completedAt: { gte: since } },
    orderBy: { completedAt: "asc" },
  });

  const totals = completions.reduce(
    (acc, completion) => {
      acc.lessons += 1;
      acc.timeSpent += completion.timeSpent;
      return acc;
    },
    { lessons: 0, timeSpent: 0 }
  );

  const trendMap = completions.reduce<
    Record<string, { wpm: number[]; accuracy: number[] }>
  >((acc, completion) => {
    const date = completion.completedAt.toISOString().substring(0, 10);
    if (!acc[date]) {
      acc[date] = { wpm: [], accuracy: [] };
    }
    acc[date].wpm.push(completion.wpm);
    acc[date].accuracy.push(completion.accuracy);
    return acc;
  }, {});

  const trend = Object.entries(trendMap)
    .sort(([a], [b]) => (a > b ? 1 : -1))
    .map(([date, values]) => ({
      date,
      wpmAvg: values.wpm.reduce((sum, value) => sum + value, 0) / values.wpm.length,
      accuracyAvg:
        values.accuracy.reduce((sum, value) => sum + value, 0) / values.accuracy.length,
    }));

  const weakCharacters = ["ㅂ", "ㅍ", "ㅎ"].slice(
    0,
    Math.max(1, Math.min(3, completions.length))
  );

  const lessons = await prisma.lesson.findMany({
    where: level ? { level } : {},
    orderBy: { order: "asc" },
    take: 3,
  });

  return {
    totals,
    trend,
    weakCharacters,
    recommendedLessons: lessons.map(toLesson),
  };
}

function toLesson(lesson: PrismaLesson): Lesson {
  return {
    id: lesson.id,
    title: lesson.title,
    description: lesson.description,
    level: lesson.level as LearningLevel,
    order: lesson.order,
    assetPath: lesson.assetPath,
    assetVersion: lesson.assetVersion,
    estimatedMinutes: lesson.estimatedMinutes,
    createdAt: lesson.createdAt,
    updatedAt: lesson.updatedAt,
  };
}

export function getLessonCompletionsForUser(userId: string) {
  return prisma.lessonCompletion.findMany({
    where: { userId },
    orderBy: { completedAt: "desc" },
  });
}

export function getLatestLessonCompletion(userId: string, lessonId: string) {
  return prisma.lessonCompletion.findFirst({
    where: { userId, lessonId },
    orderBy: { completedAt: "desc" },
  });
}
