export type LearningLevel = "beginner" | "intermediate" | "advanced";
export type UserType = "NORMAL" | "PREMIUM" | "OFFICIAL";
export type Visibility = "public" | "followers" | "private";
export type LessonMode = "standard" | "challenge";
export type DeviceType = "ios" | "android" | "web";
export type FeedType = "forYou" | "following" | "popular";
export type UserStatsRange = "weekly" | "monthly" | "all";
export type LessonStatsRange = "daily" | "weekly" | "monthly" | "all";
export type WordStatus = "MASTERED" | "REVIEWING" | "NEEDS_REVIEW";
export type WordCategory = "WORDS" | "SENTENCES";
export type ISODateTime = string | Date;

export interface UserSettings {
  notifications: {
    push: boolean;
    email: boolean;
    comment: boolean;
    like: boolean;
    follow: boolean;
  };
  theme: "light" | "dark" | "auto";
  fontSize: "small" | "medium" | "large";
  language: "ja" | "ko" | "en";
  soundEnabled: boolean;
  hapticEnabled: boolean;
  strictMode: boolean;
  profileVisibility: "public" | "followers";
  postDefaultVisibility: Visibility;
}

export interface UserSummary {
  id: string;
  username: string;
  displayName: string;
  profileImageUrl?: string | null;
  type: UserType;
  followersCount: number;
  followingCount: number;
  postsCount: number;
  settings: UserSettings | null;
}

export interface UserDetail extends Omit<UserSummary, "settings"> {
  auth0UserId: string;
  email: string;
  bio?: string | null;
  totalLessonsCompleted: number;
  maxWPM: number;
  maxAccuracy: number;
  lastLoginAt?: ISODateTime | null;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
  isActive: boolean;
  isBanned: boolean;
  settings: UserSettings;
}

export interface PostRecord {
  id: string;
  content: string;
  imageUrls: string[];
  tags: string[];
  shareToDiary: boolean;
  visibility: Visibility;
  userId: string;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
  likesCount: number;
  commentsCount: number;
}

export interface PostResponse extends Omit<PostRecord, "userId"> {
  user: UserSummary;
  liked: boolean;
  bookmarked: boolean;
}

export interface CommentRecord {
  id: string;
  content: string;
  postId: string;
  userId: string;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface CommentResponse extends Omit<CommentRecord, "userId"> {
  user: UserSummary;
  likesCount: number;
}

export interface Lesson {
  id: string;
  title: string;
  description?: string | null;
  level: LearningLevel;
  order: number;
  assetPath?: string | null;
  assetVersion?: number | null;
  estimatedMinutes: number;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface LessonCompletion {
  id: string;
  lessonId: string;
  userId: string;
  wpm: number;
  accuracy: number;
  timeSpent: number;
  device: DeviceType;
  mode: LessonMode;
  mistakeCharacters?: Record<string, number> | null;
  completedAt: ISODateTime;
}

export interface Follow {
  id: string;
  followerId: string;
  followingId: string;
  createdAt: ISODateTime;
}

export interface Like {
  id: string;
  postId: string;
  userId: string;
  createdAt: ISODateTime;
}

export interface PageInfo {
  nextCursor: string | null;
  hasNextPage: boolean;
  count: number;
}

export interface PaginatedResult<T> {
  data: T[];
  pageInfo: PageInfo;
}

export interface ErrorPayload {
  error: {
    code: string;
    message: string;
    details?: Record<string, unknown> | null;
  };
}

export interface UserStatsResponse {
  wpmAvg: number;
  accuracyAvg: number;
  lessonsCompleted: number;
  streakDays: number;
  histories: Array<{
    date: string;
    wpm: number;
    accuracy: number;
  }>;
}

export interface LessonStatsResponse {
  totals: {
    lessons: number;
    timeSpent: number;
  };
  trend: Array<{
    date: string;
    wpmAvg: number;
    accuracyAvg: number;
  }>;
  weakCharacters: string[];
  recommendedLessons: Lesson[];
}

export interface WordbookEntry {
  id: string;
  userId: string;
  word: string;
  meaning: string;
  example?: string | null;
  status: WordStatus;
  category: WordCategory;
  lastReviewedAt?: ISODateTime | null;
  reviewCount: number;
  successRate: number;
  tags: string[];
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
}

export interface WordbookStatsResponse {
  totalWords: number;
  byCategory: Record<WordCategory, number>;
  byStatus: Record<WordStatus, number>;
  averageSuccessRate: number;
  totalReviewCount: number;
}
