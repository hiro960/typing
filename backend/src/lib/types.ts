export type LearningLevel = "beginner" | "intermediate" | "advanced";
export type UserType = "NORMAL" | "PREMIUM" | "OFFICIAL";
export type Visibility = "public" | "followers" | "private";
export type LessonMode = "standard" | "challenge";
export type DeviceType = "ios" | "android" | "web";
export type FeedType = "forYou" | "following" | "popular" | "recommended" | "latest";
export type UserStatsRange = "weekly" | "monthly" | "all";
export type LessonStatsRange = "daily" | "weekly" | "monthly" | "all";
export type WordStatus = "MASTERED" | "REVIEWING" | "NEEDS_REVIEW";
export type WordCategory = "WORDS" | "SENTENCES";
export type ISODateTime = string | Date;
export type NotificationType = "LIKE" | "COMMENT" | "FOLLOW" | "QUOTE";
export type ReportType = "POST" | "COMMENT" | "USER";
export type ReportReason =
  | "SPAM"
  | "HARASSMENT"
  | "INAPPROPRIATE_CONTENT"
  | "HATE_SPEECH"
  | "OTHER";

export interface UserSettings {
  notifications: {
    push: boolean;
    email: boolean;
    comment: boolean;
    like: boolean;
    follow: boolean;
    quote: boolean;
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
  email: string | null;
  bio?: string | null;
  lastLoginAt?: ISODateTime | null;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
  isActive: boolean;
  isBanned: boolean;
  settings: UserSettings;
}

export interface QuotedPostSummary {
  id: string;
  content: string;
  user: UserSummary;
  imageUrls: string[];
  tags: string[];
  createdAt: ISODateTime;
}

export interface PostRecord {
  id: string;
  content: string;
  imageUrls: string[];
  tags: string[];
  shareToDiary: boolean;
  visibility: Visibility;
  userId: string;
  quotedPostId?: string | null;
  createdAt: ISODateTime;
  updatedAt: ISODateTime;
  likesCount: number;
  commentsCount: number;
  quotesCount: number;
  isEdited: boolean;
  editedAt?: ISODateTime | null;
}

export interface PostResponse extends Omit<PostRecord, "userId"> {
  user: UserSummary;
  liked: boolean;
  bookmarked: boolean;
  quotedPost: QuotedPostSummary | null;
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
  liked: boolean;
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

export interface NotificationRecord {
  id: string;
  userId: string;
  actorId: string;
  type: NotificationType;
  postId?: string | null;
  commentId?: string | null;
  isRead: boolean;
  createdAt: ISODateTime;
}

export interface NotificationResponse extends NotificationRecord {
  actor: UserSummary;
  post?: PostResponse | null;
  comment?: CommentResponse | null;
}

export interface BlockRecord {
  id: string;
  blockerId: string;
  blockedId: string;
  createdAt: ISODateTime;
}

export interface BlockResponse extends BlockRecord {
  blockedUser: UserSummary | null;
}

export interface ReportRecord {
  id: string;
  reporterId: string;
  type: ReportType;
  targetId: string;
  reason: ReportReason;
  description?: string | null;
  status: string;
  createdAt: ISODateTime;
}

export interface ReportResponse extends ReportRecord {
  reporter: UserSummary;
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

// ランキングゲーム関連の型定義
export type RankingGameDifficulty = "beginner" | "intermediate" | "advanced";
export type RankingPeriod = "daily" | "weekly" | "monthly";

export interface RankingGameResultRecord {
  id: string;
  userId: string;
  difficulty: RankingGameDifficulty;
  score: number;
  correctCount: number;
  maxCombo: number;
  totalBonusTime: number;
  avgInputSpeed: number;
  characterLevel: number;
  playedAt: ISODateTime;
}

export interface RankingGameResultResponse extends RankingGameResultRecord {
  ranking: {
    position: number;
    previousPosition: number | null;
    totalParticipants: number;
    isNewBest: boolean;
  };
  achievements: string[];
}

export interface RankingEntry {
  position: number;
  user: UserSummary;
  score: number;
  characterLevel: number;
  playCount: number;
  maxCombo: number;
}

export interface RankingDataResponse {
  period: {
    start: ISODateTime;
    end: ISODateTime;
  };
  rankings: RankingEntry[];
  myRanking: {
    position: number;
    score: number;
    characterLevel: number;
  } | null;
  totalParticipants: number;
}

export interface RankingGameUserStats {
  totalPlays: number;
  bestScore: {
    all: number;
    beginner: number;
    intermediate: number;
    advanced: number;
  };
  monthlyRanking: {
    all: number | null;
    beginner: number | null;
    intermediate: number | null;
    advanced: number | null;
  };
  achievements: {
    maxCombo: number;
    maxCharacterLevel: number;
    totalBonusTimeEarned: number;
  };
  recentResults: RankingGameResultRecord[];
}

// 発音ゲーム関連の型定義
export interface PronunciationGameResultRecord {
  id: string;
  userId: string;
  difficulty: RankingGameDifficulty;
  score: number;
  correctCount: number;
  maxCombo: number;
  totalBonusTime: number;
  characterLevel: number;
  playedAt: ISODateTime;
}

export interface PronunciationGameResultResponse extends PronunciationGameResultRecord {
  ranking: {
    position: number;
    previousPosition: number | null;
    totalParticipants: number;
    isNewBest: boolean;
  };
  achievements: string[];
}

export interface PronunciationRankingEntry {
  position: number;
  user: UserSummary;
  score: number;
  characterLevel: number;
  playCount: number;
  maxCombo: number;
}

export interface PronunciationRankingDataResponse {
  period: {
    start: ISODateTime;
    end: ISODateTime;
  };
  rankings: PronunciationRankingEntry[];
  myRanking: {
    position: number;
    score: number;
    characterLevel: number;
  } | null;
  totalParticipants: number;
}

export interface PronunciationGameUserStats {
  totalPlays: number;
  bestScore: {
    all: number;
    beginner: number;
    intermediate: number;
    advanced: number;
  };
  monthlyRanking: {
    all: number | null;
    beginner: number | null;
    intermediate: number | null;
    advanced: number | null;
  };
  achievements: {
    maxCombo: number;
    maxCharacterLevel: number;
    totalBonusTimeEarned: number;
  };
  recentResults: PronunciationGameResultRecord[];
}

// 統合統計関連の型定義
export type ActivityType =
  | "lesson"
  | "ranking_game"
  | "pronunciation_game"
  | "quick_translation"
  | "writing"
  | "hanja_quiz"
  | "shadowing";

export interface ActivityLogRecord {
  id: string;
  userId: string;
  activityType: ActivityType;
  timeSpent: number;
  wpm: number | null;
  accuracy: number | null;
  metadata: Record<string, unknown> | null;
  completedAt: ISODateTime;
}

export interface IntegratedStats {
  totalTimeSpent: number;
  streakDays: number;
  maxWpm: number;
  avgWpm: number;
  maxAccuracy: number;
  avgAccuracy: number;
  activeDays: number;
  breakdown: {
    lesson: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
    rankingGame: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
    quickTranslation: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
    writing: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
    hanjaQuiz: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
    shadowing: {
      count: number;
      timeSpent: number;
      avgAccuracy: number;
    };
  };
  dailyTrend: Array<{
    date: string;
    lessonTime: number;
    rankingGameTime: number;
    quickTranslationTime: number;
    writingTime: number;
    hanjaQuizTime: number;
    shadowingTime: number;
    wpm: number | null;
    accuracy: number | null;
  }>;
}
