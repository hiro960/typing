import { randomUUID } from "crypto";
import {
  CommentRecord,
  CommentResponse,
  DeviceType,
  Follow,
  LearningLevel,
  Lesson,
  LessonCompletion,
  LessonMode,
  LessonStatsRange,
  Like,
  PostRecord,
  PostResponse,
  UserDetail,
  UserSettings,
  UserStatsRange,
  UserStatsResponse,
  UserSummary,
  Visibility,
  LessonStatsResponse,
} from "./types";
import { ERROR } from "./errors";

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

function buildSettings(overrides?: Partial<UserSettings>): UserSettings {
  const base: UserSettings = {
    ...defaultSettings,
    notifications: { ...defaultSettings.notifications },
  };

  if (!overrides) {
    return base;
  }

  return {
    ...base,
    ...overrides,
    notifications: {
      ...base.notifications,
      ...(overrides.notifications ?? {}),
    },
  };
}

const users: UserDetail[] = [
  {
    id: "usr_hanako",
    auth0UserId: "auth0|usr_hanako",
    username: "hanako",
    displayName: "花子",
    email: "hanako@example.com",
    profileImageUrl: "https://img.example.com/u/hanako.png",
    bio: "韓ドラ好きのタイピング勢",
    learningLevel: "intermediate",
    followersCount: 2,
    followingCount: 2,
    postsCount: 2,
    settings: buildSettings(),
    totalLessonsCompleted: 42,
    totalPracticeTime: 3600,
    maxWPM: 230,
    maxAccuracy: 0.97,
    lastLoginAt: "2024-03-14T10:00:00Z",
    createdAt: "2023-12-28T00:00:00Z",
    updatedAt: "2024-03-14T09:00:00Z",
    isActive: true,
    isBanned: false,
  },
  {
    id: "usr_genta",
    auth0UserId: "auth0|usr_genta",
    username: "genta",
    displayName: "玄太",
    email: "genta@example.com",
    profileImageUrl: "https://img.example.com/u/genta.png",
    bio: "釜山カフェ巡りを韓国語で記録中",
    learningLevel: "beginner",
    followersCount: 1,
    followingCount: 1,
    postsCount: 1,
    settings: buildSettings({
      theme: "light",
      notifications: { email: false },
    }),
    totalLessonsCompleted: 12,
    totalPracticeTime: 1200,
    maxWPM: 180,
    maxAccuracy: 0.9,
    lastLoginAt: "2024-03-13T14:00:00Z",
    createdAt: "2024-01-10T00:00:00Z",
    updatedAt: "2024-03-13T14:00:00Z",
    isActive: true,
    isBanned: false,
  },
  {
    id: "usr_mina",
    auth0UserId: "auth0|usr_mina",
    username: "mina",
    displayName: "美奈",
    email: "mina@example.com",
    profileImageUrl: "https://img.example.com/u/mina.png",
    bio: "K-POP追いながら日記を書いてます",
    learningLevel: "advanced",
    followersCount: 1,
    followingCount: 1,
    postsCount: 1,
    settings: buildSettings({
      theme: "dark",
      language: "ko",
      notifications: { push: false },
    }),
    totalLessonsCompleted: 54,
    totalPracticeTime: 5400,
    maxWPM: 260,
    maxAccuracy: 0.99,
    lastLoginAt: "2024-03-12T21:00:00Z",
    createdAt: "2023-11-05T00:00:00Z",
    updatedAt: "2024-03-12T21:00:00Z",
    isActive: true,
    isBanned: false,
  },
];

const posts: PostRecord[] = [
  {
    id: "post_1",
    content: "오늘은 좋아하는 아이ドルのVLIVEを書き起こしてタイピング練習しました ✍️",
    imageUrls: ["https://img.example.com/p/1.png"],
    visibility: "public",
    userId: "usr_hanako",
    createdAt: "2024-03-12T12:00:00Z",
    updatedAt: "2024-03-12T12:00:00Z",
    likesCount: 3,
    commentsCount: 2,
    tags: ["#日記", "#推し活"],
    shareToDiary: true,
  },
  {
    id: "post_2",
    content: "부산カフェで覚えたフレーズまとめ。추천해주세요!",
    imageUrls: [],
    visibility: "public",
    userId: "usr_genta",
    createdAt: "2024-03-11T09:00:00Z",
    updatedAt: "2024-03-11T09:00:00Z",
    likesCount: 1,
    commentsCount: 1,
    tags: ["#カフェ", "#学習記録"],
    shareToDiary: true,
  },
  {
    id: "post_3",
    content: "문법ノートの復習メモ。間違えやすい表現を整理中。",
    imageUrls: [],
    visibility: "private",
    userId: "usr_hanako",
    createdAt: "2024-03-10T07:00:00Z",
    updatedAt: "2024-03-10T07:00:00Z",
    likesCount: 0,
    commentsCount: 0,
    tags: ["#study"],
    shareToDiary: false,
  },
  {
    id: "post_4",
    content: "오늘도 최애에게 편지 작성 완료💌",
    imageUrls: ["https://img.example.com/p/4.png"],
    visibility: "followers",
    userId: "usr_mina",
    createdAt: "2024-03-09T20:00:00Z",
    updatedAt: "2024-03-09T20:00:00Z",
    likesCount: 2,
    commentsCount: 0,
    tags: ["#fanletter"],
    shareToDiary: true,
  },
];

const comments: CommentRecord[] = [
  {
    id: "cmt_1",
    content: "저도 같은VLIVE見ました！",
    postId: "post_1",
    userId: "usr_genta",
    createdAt: "2024-03-12T12:05:00Z",
    updatedAt: "2024-03-12T12:05:00Z",
  },
  {
    id: "cmt_2",
    content: "필기共有ありがとうございます🙏",
    postId: "post_1",
    userId: "usr_mina",
    createdAt: "2024-03-12T12:06:00Z",
    updatedAt: "2024-03-12T12:06:00Z",
  },
  {
    id: "cmt_3",
    content: "카페情報助かる！",
    postId: "post_2",
    userId: "usr_hanako",
    createdAt: "2024-03-11T09:30:00Z",
    updatedAt: "2024-03-11T09:30:00Z",
  },
];

const likes: Like[] = [
  {
    id: "like_1",
    postId: "post_1",
    userId: "usr_genta",
    createdAt: "2024-03-12T12:01:00Z",
  },
  {
    id: "like_2",
    postId: "post_1",
    userId: "usr_mina",
    createdAt: "2024-03-12T12:02:00Z",
  },
  {
    id: "like_3",
    postId: "post_1",
    userId: "usr_hanako",
    createdAt: "2024-03-12T12:03:00Z",
  },
  {
    id: "like_4",
    postId: "post_2",
    userId: "usr_hanako",
    createdAt: "2024-03-11T10:00:00Z",
  },
  {
    id: "like_5",
    postId: "post_4",
    userId: "usr_hanako",
    createdAt: "2024-03-09T21:00:00Z",
  },
  {
    id: "like_6",
    postId: "post_4",
    userId: "usr_genta",
    createdAt: "2024-03-09T21:05:00Z",
  },
];

const follows: Follow[] = [
  {
    id: "fol_1",
    followerId: "usr_hanako",
    followingId: "usr_genta",
    createdAt: "2024-02-01T00:00:00Z",
  },
  {
    id: "fol_2",
    followerId: "usr_hanako",
    followingId: "usr_mina",
    createdAt: "2024-02-05T00:00:00Z",
  },
  {
    id: "fol_3",
    followerId: "usr_genta",
    followingId: "usr_hanako",
    createdAt: "2024-02-10T00:00:00Z",
  },
  {
    id: "fol_4",
    followerId: "usr_mina",
    followingId: "usr_hanako",
    createdAt: "2024-02-12T00:00:00Z",
  },
];

const lessons: Lesson[] = [
  {
    id: "les_1",
    title: "子音 基礎",
    description: "基本の子音配置を覚える",
    level: "beginner",
    order: 1,
    content: { blocks: ["ㄱ", "ㄴ", "ㄷ"] },
    createdAt: "2024-02-01T00:00:00Z",
    updatedAt: "2024-02-01T00:00:00Z",
  },
  {
    id: "les_2",
    title: "母音の組み合わせ",
    description: "複合母音の練習",
    level: "beginner",
    order: 2,
    content: { blocks: ["ㅘ", "ㅝ", "ㅢ"] },
    createdAt: "2024-02-02T00:00:00Z",
    updatedAt: "2024-02-02T00:00:00Z",
  },
  {
    id: "les_3",
    title: "パッチム攻略",
    description: "終声の打ち分け",
    level: "intermediate",
    order: 10,
    content: { blocks: ["받침", "연음"] },
    createdAt: "2024-02-10T00:00:00Z",
    updatedAt: "2024-02-10T00:00:00Z",
  },
  {
    id: "les_4",
    title: "会話フレーズ実践",
    description: "日常会話の文章",
    level: "intermediate",
    order: 12,
    content: { blocks: ["안녕하세요", "오늘 날씨 어때요?"] },
    createdAt: "2024-02-12T00:00:00Z",
    updatedAt: "2024-02-12T00:00:00Z",
  },
  {
    id: "les_5",
    title: "アイドル応援メッセージ",
    description: "推し活で使う表現",
    level: "advanced",
    order: 18,
    content: { blocks: ["사랑해요", "최고예요"] },
    createdAt: "2024-02-18T00:00:00Z",
    updatedAt: "2024-02-18T00:00:00Z",
  },
];

const lessonCompletions: LessonCompletion[] = [
  {
    id: "lc_1",
    lessonId: "les_1",
    userId: "usr_hanako",
    wpm: 210,
    accuracy: 0.95,
    timeSpent: 180,
    device: "ios",
    mode: "standard",
    completedAt: "2024-03-12T08:00:00Z",
  },
  {
    id: "lc_2",
    lessonId: "les_3",
    userId: "usr_hanako",
    wpm: 220,
    accuracy: 0.92,
    timeSpent: 210,
    device: "ios",
    mode: "challenge",
    completedAt: "2024-03-13T08:30:00Z",
  },
  {
    id: "lc_3",
    lessonId: "les_4",
    userId: "usr_hanako",
    wpm: 215,
    accuracy: 0.93,
    timeSpent: 200,
    device: "ios",
    mode: "standard",
    completedAt: "2024-03-10T07:30:00Z",
  },
  {
    id: "lc_4",
    lessonId: "les_2",
    userId: "usr_hanako",
    wpm: 225,
    accuracy: 0.96,
    timeSpent: 190,
    device: "ios",
    mode: "standard",
    completedAt: "2024-03-14T07:30:00Z",
  },
  {
    id: "lc_5",
    lessonId: "les_1",
    userId: "usr_genta",
    wpm: 150,
    accuracy: 0.85,
    timeSpent: 300,
    device: "android",
    mode: "standard",
    completedAt: "2024-03-11T06:00:00Z",
  },
  {
    id: "lc_6",
    lessonId: "les_2",
    userId: "usr_genta",
    wpm: 160,
    accuracy: 0.88,
    timeSpent: 280,
    device: "android",
    mode: "standard",
    completedAt: "2024-03-13T06:30:00Z",
  },
  {
    id: "lc_7",
    lessonId: "les_5",
    userId: "usr_mina",
    wpm: 250,
    accuracy: 0.98,
    timeSpent: 150,
    device: "ios",
    mode: "challenge",
    completedAt: "2024-03-09T05:00:00Z",
  },
];

export const db = {
  users,
  posts,
  comments,
  likes,
  follows,
  lessons,
  lessonCompletions,
};

export function toUserSummary(user: UserDetail): UserSummary {
  return {
    id: user.id,
    username: user.username,
    displayName: user.displayName,
    profileImageUrl: user.profileImageUrl,
    learningLevel: user.learningLevel,
    followersCount: user.followersCount,
    followingCount: user.followingCount,
    postsCount: user.postsCount,
    settings: null,
  };
}

export function findUserById(userId: string) {
  return db.users.find((user) => user.id === userId);
}

export function updateUserProfile(
  userId: string,
  updates: {
    displayName?: string;
    bio?: string | null;
    learningLevel?: UserDetail["learningLevel"];
    settings?: Partial<UserSettings>;
  }
) {
  const user = findUserById(userId);
  if (!user) {
    throw ERROR.NOT_FOUND("User not found");
  }

  if (updates.displayName) {
    user.displayName = updates.displayName;
  }

  if (typeof updates.bio !== "undefined") {
    user.bio = updates.bio;
  }

  if (updates.learningLevel) {
    user.learningLevel = updates.learningLevel;
  }

  if (updates.settings) {
    user.settings = {
      ...user.settings,
      ...updates.settings,
      notifications: {
        ...user.settings.notifications,
        ...(updates.settings.notifications ?? {}),
      },
    };
  }

  user.updatedAt = new Date().toISOString();
  return user;
}

export function toPostResponse(
  post: PostRecord,
  currentUserId?: string
): PostResponse {
  const author = findUserById(post.userId);
  if (!author) {
    throw ERROR.NOT_FOUND("Author not found");
  }

  const liked = currentUserId
    ? db.likes.some(
        (like) => like.postId === post.id && like.userId === currentUserId
      )
    : false;

  return {
    ...post,
    user: toUserSummary(author),
    liked,
    bookmarked: false,
  };
}

export function getPostById(postId: string) {
  return db.posts.find((post) => post.id === postId);
}

export function createPost(params: {
  userId: string;
  content: string;
  imageUrls: string[];
  visibility: Visibility;
  tags: string[];
  shareToDiary: boolean;
}) {
  const post: PostRecord = {
    id: `post_${randomUUID()}`,
    userId: params.userId,
    content: params.content,
    imageUrls: params.imageUrls,
    visibility: params.visibility,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    likesCount: 0,
    commentsCount: 0,
    tags: params.tags,
    shareToDiary: params.shareToDiary,
  };
  db.posts.unshift(post);

  const user = findUserById(params.userId);
  if (user) {
    user.postsCount += 1;
    user.updatedAt = new Date().toISOString();
  }

  return post;
}

export function updatePost(postId: string, updates: Partial<PostRecord>) {
  const post = getPostById(postId);
  if (!post) {
    throw ERROR.NOT_FOUND("Post not found");
  }

  Object.assign(post, updates, { updatedAt: new Date().toISOString() });
  return post;
}

export function deletePost(postId: string) {
  const index = db.posts.findIndex((post) => post.id === postId);
  if (index === -1) {
    throw ERROR.NOT_FOUND("Post not found");
  }

  const [removed] = db.posts.splice(index, 1);

  // delete likes
  for (let i = db.likes.length - 1; i >= 0; i -= 1) {
    if (db.likes[i].postId === postId) {
      db.likes.splice(i, 1);
    }
  }

  // delete comments
  for (let i = db.comments.length - 1; i >= 0; i -= 1) {
    if (db.comments[i].postId === postId) {
      db.comments.splice(i, 1);
    }
  }

  const user = findUserById(removed.userId);
  if (user && user.postsCount > 0) {
    user.postsCount -= 1;
  }
}

export function addLike(postId: string, userId: string) {
  const post = getPostById(postId);
  if (!post) {
    throw ERROR.NOT_FOUND("Post not found");
  }

  const already = db.likes.find(
    (like) => like.postId === postId && like.userId === userId
  );
  if (already) {
    throw ERROR.CONFLICT("Already liked");
  }

  db.likes.push({
    id: `like_${randomUUID()}`,
    postId,
    userId,
    createdAt: new Date().toISOString(),
  });
  post.likesCount += 1;

  return post;
}

export function removeLike(postId: string, userId: string) {
  const post = getPostById(postId);
  if (!post) {
    throw ERROR.NOT_FOUND("Post not found");
  }

  const index = db.likes.findIndex(
    (like) => like.postId === postId && like.userId === userId
  );
  if (index === -1) {
    throw ERROR.NOT_FOUND("Like not found");
  }

  db.likes.splice(index, 1);
  if (post.likesCount > 0) {
    post.likesCount -= 1;
  }

  return post;
}

export function listComments(postId: string) {
  return db.comments.filter((comment) => comment.postId === postId);
}

export function findCommentById(commentId: string) {
  return db.comments.find((comment) => comment.id === commentId);
}

export function addComment(postId: string, userId: string, content: string) {
  const post = getPostById(postId);
  if (!post) {
    throw ERROR.NOT_FOUND("Post not found");
  }

  const comment: CommentRecord = {
    id: `cmt_${randomUUID()}`,
    postId,
    userId,
    content,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  db.comments.unshift(comment);
  post.commentsCount += 1;
  return comment;
}

export function removeComment(commentId: string) {
  const index = db.comments.findIndex((comment) => comment.id === commentId);
  if (index === -1) {
    throw ERROR.NOT_FOUND("Comment not found");
  }

  const [comment] = db.comments.splice(index, 1);
  const post = getPostById(comment.postId);
  if (post && post.commentsCount > 0) {
    post.commentsCount -= 1;
  }
  return comment;
}

export function toCommentResponse(comment: CommentRecord): CommentResponse {
  const user = findUserById(comment.userId);
  if (!user) {
    throw ERROR.NOT_FOUND("User not found");
  }

  return {
    ...comment,
    user: toUserSummary(user),
    likesCount: 0,
  };
}

export function addFollow(followerId: string, followingId: string) {
  if (followerId === followingId) {
    throw ERROR.INVALID_INPUT("Cannot follow yourself");
  }

  const follower = findUserById(followerId);
  const target = findUserById(followingId);
  if (!follower || !target) {
    throw ERROR.NOT_FOUND("User not found");
  }

  const exists = db.follows.find(
    (follow) =>
      follow.followerId === followerId && follow.followingId === followingId
  );
  if (exists) {
    throw ERROR.CONFLICT("Already following");
  }

  const follow: Follow = {
    id: `fol_${randomUUID()}`,
    followerId,
    followingId,
    createdAt: new Date().toISOString(),
  };
  db.follows.push(follow);

  follower.followingCount += 1;
  target.followersCount += 1;
  return follow;
}

export function removeFollow(followerId: string, followingId: string) {
  const index = db.follows.findIndex(
    (follow) =>
      follow.followerId === followerId && follow.followingId === followingId
  );
  if (index === -1) {
    throw ERROR.NOT_FOUND("Follow relationship not found");
  }

  db.follows.splice(index, 1);

  const follower = findUserById(followerId);
  if (follower && follower.followingCount > 0) {
    follower.followingCount -= 1;
  }

  const target = findUserById(followingId);
  if (target && target.followersCount > 0) {
    target.followersCount -= 1;
  }
}

export function listFollowers(userId: string) {
  return db.follows
    .filter((follow) => follow.followingId === userId)
    .map((follow) => {
      const user = findUserById(follow.followerId);
      return user ? toUserSummary(user) : null;
    })
    .filter((user): user is UserSummary => !!user);
}

export function listFollowing(userId: string) {
  return db.follows
    .filter((follow) => follow.followerId === userId)
    .map((follow) => {
      const user = findUserById(follow.followingId);
      return user ? toUserSummary(user) : null;
    })
    .filter((user): user is UserSummary => !!user);
}

export function isFollowingUser(followerId: string, followingId: string) {
  return db.follows.some(
    (follow) =>
      follow.followerId === followerId && follow.followingId === followingId
  );
}

export function canViewPost(post: PostRecord, viewerId?: string) {
  if (post.visibility === "public") return true;
  if (!viewerId) return false;
  if (post.visibility === "private") {
    return post.userId === viewerId;
  }
  if (post.visibility === "followers") {
    return post.userId === viewerId || isFollowingUser(viewerId, post.userId);
  }
  return false;
}

export function getLessonById(lessonId: string) {
  return db.lessons.find((lesson) => lesson.id === lessonId);
}

export function listLessons() {
  return db.lessons.slice();
}

export function recordLessonCompletion(params: {
  lessonId: string;
  userId: string;
  wpm: number;
  accuracy: number;
  timeSpent: number;
  device: DeviceType;
  mode: LessonMode;
}) {
  const lesson = getLessonById(params.lessonId);
  if (!lesson) {
    throw ERROR.NOT_FOUND("Lesson not found");
  }

  const completion: LessonCompletion = {
    id: `lc_${randomUUID()}`,
    lessonId: params.lessonId,
    userId: params.userId,
    wpm: params.wpm,
    accuracy: params.accuracy,
    timeSpent: params.timeSpent,
    device: params.device,
    mode: params.mode,
    completedAt: new Date().toISOString(),
  };

  db.lessonCompletions.push(completion);

  const user = findUserById(params.userId);
  if (user) {
    user.totalLessonsCompleted += 1;
    user.totalPracticeTime += params.timeSpent;
    user.maxWPM = Math.max(user.maxWPM, params.wpm);
    user.maxAccuracy = Math.max(user.maxAccuracy, params.accuracy);
  }

  return completion;
}

export function getUserStats(
  userId: string,
  range: UserStatsRange
): UserStatsResponse {
  const completions = db.lessonCompletions
    .filter((completion) => completion.userId === userId)
    .filter((completion) => {
      if (range === "all") return true;
      const days = range === "weekly" ? 7 : 30;
      const since = Date.now() - days * 24 * 60 * 60 * 1000;
      return new Date(completion.completedAt).getTime() >= since;
    })
    .sort(
      (a, b) =>
        new Date(a.completedAt).getTime() - new Date(b.completedAt).getTime()
    );

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
    completions.reduce((sum, item) => sum + item.accuracy, 0) /
    completions.length;

  const grouped = completions.reduce<Record<string, { wpm: number[]; accuracy: number[] }>>(
    (acc, item) => {
      const date = item.completedAt.substring(0, 10);
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
      wpm:
        values.wpm.reduce((sum, value) => sum + value, 0) / values.wpm.length,
      accuracy:
        values.accuracy.reduce((sum, value) => sum + value, 0) /
        values.accuracy.length,
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

function calculateStreak(completions: LessonCompletion[]) {
  if (completions.length === 0) return 0;

  const dateStrings = Array.from(
    new Set(completions.map((item) => item.completedAt.substring(0, 10)))
  ).sort((a, b) => (a > b ? -1 : 1));

  let streak = 0;
  let previousDate: Date | null = null;

  for (const dateStr of dateStrings) {
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

export function getLessonStats(
  userId: string,
  range: LessonStatsRange,
  level?: LearningLevel
): LessonStatsResponse {
  const days =
    range === "daily" ? 1 : range === "weekly" ? 7 : range === "monthly" ? 30 : 7;
  const since = Date.now() - days * 24 * 60 * 60 * 1000;
  const completions = db.lessonCompletions.filter(
    (completion) =>
      completion.userId === userId &&
      new Date(completion.completedAt).getTime() >= since
  );

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
    const date = completion.completedAt.substring(0, 10);
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
      wpmAvg:
        values.wpm.reduce((sum, value) => sum + value, 0) / values.wpm.length,
      accuracyAvg:
        values.accuracy.reduce((sum, value) => sum + value, 0) /
        values.accuracy.length,
    }));

  const weakCharacters = ["ㅂ", "ㅍ", "ㅎ"].slice(
    0,
    Math.max(1, Math.min(3, completions.length))
  );

  const recommendedLessons = db.lessons.filter((lesson) => {
    if (!level) return true;
    return lesson.level === level;
  });

  return {
    totals,
    trend,
    weakCharacters,
    recommendedLessons: recommendedLessons.slice(0, 3),
  };
}

export function getLessonCompletionsForUser(userId: string) {
  return db.lessonCompletions.filter(
    (completion) => completion.userId === userId
  );
}

export function getLatestLessonCompletion(
  userId: string,
  lessonId: string
): LessonCompletion | undefined {
  return db.lessonCompletions
    .filter(
      (completion) =>
        completion.userId === userId && completion.lessonId === lessonId
    )
    .sort(
      (a, b) =>
        new Date(b.completedAt).getTime() - new Date(a.completedAt).getTime()
    )[0];
}
