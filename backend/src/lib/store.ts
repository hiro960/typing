import {
  Prisma,
  User,
  Post as PrismaPost,
  Lesson as PrismaLesson,
  LessonCompletion as PrismaLessonCompletion,
  Wordbook as PrismaWordbook,
} from "@prisma/client";
import prisma from "@/lib/prisma";
import { sendPushNotification } from "@/lib/push";
import { ERROR } from "@/lib/errors";
import { deleteManagedBlobs } from "@/lib/storage";
import {
  BlockResponse,
  CommentResponse,
  DeviceType,
  Lesson,
  LessonMode,
  LessonStatsRange,
  LessonStatsResponse,
  LearningLevel,
  NotificationResponse,
  NotificationType,
  PaginatedResult,
  PostRecord,
  PostResponse,
  QuotedPostSummary,
  ReportReason,
  ReportType,
  ReportResponse,
  UserDetail,
  UserSettings,
  UserStatsRange,
  UserStatsResponse,
  UserSummary,
  Visibility,
  WordbookEntry,
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

const notificationSettingKey: Record<
  NotificationType,
  keyof UserSettings["notifications"]
> = {
  LIKE: "like",
  COMMENT: "comment",
  FOLLOW: "follow",
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
  include: { user: true; quotedPost: { include: { user: true } } };
}>;

type PostWithOptionalUser = PrismaPost & {
  user?: User | null;
  quotedPost?: (PrismaPost & { user?: User | null }) | null;
};

type CommentWithUser = Prisma.CommentGetPayload<{
  include: { user: true };
}>;

type NotificationWithRelations = Prisma.NotificationGetPayload<{
  include: {
    actor: true;
    post: { include: { user: true; quotedPost: { include: { user: true } } } };
    comment: { include: { user: true } };
  };
}>;

interface NotificationDispatch {
  type: NotificationType;
  targetUserId: string;
  actorName: string;
  token?: string | null;
  postId?: string | null;
  commentId?: string | null;
  previewText?: string | null;
}

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
    profileImageUrl?: string | null;
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
      profileImageUrl:
        typeof updates.profileImageUrl === "undefined" ? undefined : updates.profileImageUrl,
    },
  });

  return toUserDetail(updated);
}

export function updateUserPushToken(userId: string, token: string | null) {
  return prisma.user.update({
    where: { id: userId },
    data: { fcmToken: token },
  });
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
    quotedPostId: post.quotedPostId ?? null,
    createdAt: post.createdAt,
    updatedAt: post.updatedAt,
    likesCount: post.likesCount,
    commentsCount: post.commentsCount,
    quotesCount: post.quotesCount,
    isEdited: post.isEdited ?? false,
    editedAt: post.editedAt,
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

async function isPostBookmarkedByUser(postId: string, userId?: string) {
  if (!userId) return false;
  const bookmark = await prisma.bookmark.findUnique({
    where: { userId_postId: { userId, postId } },
    select: { id: true },
  });
  return !!bookmark;
}



async function resolveQuotedPost(
  post: PostWithOptionalUser
): Promise<QuotedPostSummary | null> {
  if (!post.quotedPostId) {
    return null;
  }

  const quoted =
    post.quotedPost ??
    (await prisma.post.findUnique({
      where: { id: post.quotedPostId },
      include: { user: true },
    }));

  if (!quoted) {
    return null;
  }

  const quotedAuthor = quoted.user
    ? toUserSummary(quoted.user)
    : {
      id: quoted.userId,
      username: "unknown",
      displayName: "Unknown",
      profileImageUrl: null,
      type: "NORMAL" as const,
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
      settings: null,
    };

  return {
    id: quoted.id,
    content: quoted.content,
    user: quotedAuthor,
    imageUrls: quoted.imageUrls,
    tags: quoted.tags,
    createdAt: quoted.createdAt,
  };
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
  const bookmarked = await isPostBookmarkedByUser(post.id, viewerId);
  const quotedPost = await resolveQuotedPost(post);

  return {
    ...toPostRecord(post),
    user: userSummary,
    liked,
    bookmarked,
    quotedPost,
  };
}

export function getPostById(postId: string) {
  return prisma.post.findUnique({
    where: { id: postId },
    include: {
      user: true,
      quotedPost: { include: { user: true } },
    },
  });
}

export async function createPost(params: {
  userId: string;
  content: string;
  imageUrls: string[];
  visibility: Visibility;
  tags: string[];
  shareToDiary: boolean;
  quotedPostId?: string | null;
}) {
  const createData: Prisma.PostUncheckedCreateInput = {
    userId: params.userId,
    content: params.content,
    imageUrls: params.imageUrls,
    visibility: params.visibility,
    tags: params.tags,
    shareToDiary: params.shareToDiary,
  };
  if (params.quotedPostId) {
    createData.quotedPostId = params.quotedPostId;
  }
  return prisma.$transaction(async (tx) => {
    const created = await tx.post.create({ data: createData });

    if (params.visibility !== "private") {
      await tx.user.update({
        where: { id: params.userId },
        data: { postsCount: { increment: 1 } },
      });
    }

    if (params.quotedPostId) {
      await tx.post.update({
        where: { id: params.quotedPostId },
        data: { quotesCount: { increment: 1 } },
      });
    }

    const fullPost = await tx.post.findUnique({
      where: { id: created.id },
      include: {
        user: true,
        quotedPost: { include: { user: true } },
      },
    });

    return fullPost ?? created;
  });
}

export function updatePost(
  postId: string,
  updates: Partial<PostRecord>,
  options?: { resetCreatedAt?: boolean; markEdited?: boolean; incrementPostsCount?: boolean }
) {
  return prisma
    .$transaction(async (tx) => {
      const existing = await tx.post.findUnique({ where: { id: postId } });
      if (!existing) {
        throw ERROR.NOT_FOUND("Post not found");
      }

      const updated = await tx.post.update({
        where: { id: postId },
        data: {
          content: typeof updates.content === "undefined" ? undefined : updates.content,
          imageUrls: typeof updates.imageUrls === "undefined" ? undefined : updates.imageUrls,
          visibility:
            typeof updates.visibility === "undefined" ? undefined : updates.visibility,
          tags: typeof updates.tags === "undefined" ? undefined : updates.tags,
          shareToDiary:
            typeof updates.shareToDiary === "undefined" ? undefined : updates.shareToDiary,
          isEdited: options?.markEdited ? true : undefined,
          editedAt: options?.markEdited ? new Date() : undefined,
          createdAt: options?.resetCreatedAt ? new Date() : undefined,
        },
        include: {
          user: true,
          quotedPost: { include: { user: true } },
        },
      });

      if (options?.incrementPostsCount) {
        await tx.user.update({
          where: { id: updated.userId },
          data: { postsCount: { increment: 1 } },
        });
      }

      const removedImages = existing.imageUrls.filter(
        (url) => !updated.imageUrls.includes(url)
      );
      return { updated, removedImages };
    })
    .then(async ({ updated, removedImages }) => {
      if (removedImages.length > 0) {
        await deleteManagedBlobs(removedImages);
      }
      return updated;
    });
}

export async function deletePost(postId: string) {
  const imageUrls = await prisma.$transaction(async (tx) => {
    const post = await tx.post.findUnique({ where: { id: postId } });
    if (!post) {
      throw ERROR.NOT_FOUND("Post not found");
    }

    await tx.post.delete({ where: { id: postId } });

    if (post.visibility !== "private") {
      await tx.user.update({
        where: { id: post.userId },
        data: { postsCount: { decrement: 1 } },
      });
    }

    if (post.quotedPostId) {
      await tx.post
        .update({
          where: { id: post.quotedPostId },
          data: { quotesCount: { decrement: 1 } },
        })
        .catch(() => null);
    }
    return post.imageUrls;
  });
  if (imageUrls.length > 0) {
    await deleteManagedBlobs(imageUrls);
  }
}

export function addLike(post: PostWithUser, userId: string) {
  return prisma
    .$transaction(async (tx) => {
      const existing = await tx.like.findUnique({
        where: { postId_userId: { postId: post.id, userId } },
      });
      if (existing) {
        throw ERROR.CONFLICT("Already liked");
      }

      await tx.like.create({ data: { postId: post.id, userId } });
      const updated = await tx.post.update({
        where: { id: post.id },
        data: { likesCount: { increment: 1 } },
        include: { user: true },
      });
      const notificationDispatch = await maybeCreateNotification(tx, {
        targetUserId: post.userId,
        actorId: userId,
        type: "LIKE",
        postId: post.id,
        previewText: post.content,
      });
      return { updated, notificationDispatch };
    })
    .then(async ({ updated, notificationDispatch }) => {
      await dispatchNotificationPush(notificationDispatch);
      return updated;
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

export function addBookmark(postId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.bookmark.findUnique({
      where: { userId_postId: { userId, postId } },
    });
    if (existing) {
      throw ERROR.CONFLICT("Already bookmarked");
    }
    await tx.bookmark.create({ data: { userId, postId } });
    return { bookmarked: true };
  });
}

export function removeBookmark(postId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.bookmark.findUnique({
      where: { userId_postId: { userId, postId } },
    });
    if (!existing) {
      throw ERROR.NOT_FOUND("Bookmark not found");
    }
    await tx.bookmark.delete({ where: { id: existing.id } });
    return { bookmarked: false };
  });
}



function toCommentResponseInternal(
  comment: CommentWithUser,
  liked = false
): CommentResponse {
  return {
    id: comment.id,
    content: comment.content,
    postId: comment.postId,
    createdAt: comment.createdAt,
    updatedAt: comment.updatedAt,
    user: toUserSummary(comment.user),
    likesCount: comment.likesCount,
    liked,
  };
}

async function toNotificationResponseInternal(
  notification: NotificationWithRelations
): Promise<NotificationResponse> {
  const post = notification.post
    ? await toPostResponse(notification.post, notification.userId)
    : null;
  const comment = notification.comment
    ? toCommentResponseInternal(notification.comment, false)
    : null;

  return {
    id: notification.id,
    userId: notification.userId,
    actorId: notification.actorId,
    type: notification.type as NotificationType,
    postId: notification.postId,
    commentId: notification.commentId,
    isRead: notification.isRead,
    createdAt: notification.createdAt,
    actor: toUserSummary(notification.actor),
    post,
    comment,
  };
}

function buildNotificationPreview(text?: string | null) {
  if (!text) return "";
  const trimmed = text.trim().replace(/\s+/g, " ");
  if (trimmed.length <= 60) {
    return trimmed;
  }
  return `${trimmed.slice(0, 57)}...`;
}

function buildNotificationBody(dispatch: NotificationDispatch) {
  const preview = buildNotificationPreview(dispatch.previewText);
  switch (dispatch.type) {
    case "LIKE":
      return preview
        ? `${dispatch.actorName}さんが「${preview}」にいいねしました`
        : `${dispatch.actorName}さんがあなたの投稿にいいねしました`;
    case "COMMENT":
      return preview
        ? `${dispatch.actorName}さんがコメントしました: 「${preview}」`
        : `${dispatch.actorName}さんがあなたの投稿にコメントしました`;

    case "FOLLOW":
    default:
      return `${dispatch.actorName}さんがあなたをフォローしました`;
  }
}

async function dispatchNotificationPush(dispatch: NotificationDispatch | null) {
  if (!dispatch?.token) {
    return;
  }
  const body = buildNotificationBody(dispatch);
  await sendPushNotification({
    token: dispatch.token,
    notification: {
      title: "新しい通知",
      body,
    },
    data: {
      type: dispatch.type,
      postId: dispatch.postId ?? "",
      commentId: dispatch.commentId ?? "",
    },
  });
}

async function maybeCreateNotification(
  tx: Prisma.TransactionClient,
  params: {
    targetUserId: string;
    actorId: string;
    type: NotificationType;
    postId?: string | null;
    commentId?: string | null;
    previewText?: string | null;
  }
): Promise<NotificationDispatch | null> {
  if (params.targetUserId === params.actorId) {
    return null;
  }

  if (await hasBlockingBetween(params.targetUserId, params.actorId, tx)) {
    return null;
  }

  const target = await tx.user.findUnique({
    where: { id: params.targetUserId },
    select: { id: true, settings: true, fcmToken: true },
  });
  if (!target) {
    return null;
  }

  const actor = await tx.user.findUnique({
    where: { id: params.actorId },
    select: { displayName: true },
  });
  if (!actor) {
    return null;
  }

  const settings = parseUserSettings(target.settings);
  const key = notificationSettingKey[params.type];
  if (!settings.notifications[key]) {
    return null;
  }

  const existingNotification = await tx.notification.findFirst({
    where: {
      userId: params.targetUserId,
      actorId: params.actorId,
      type: params.type,
      postId: params.postId ?? null,
      commentId: params.commentId ?? null,
    },
  });

  if (existingNotification) {
    await tx.notification.update({
      where: { id: existingNotification.id },
      data: { isRead: false, createdAt: new Date() },
    });
  } else {
    await tx.notification.create({
      data: {
        userId: params.targetUserId,
        actorId: params.actorId,
        type: params.type,
        postId: params.postId ?? null,
        commentId: params.commentId ?? null,
      },
    });
  }

  return {
    type: params.type,
    targetUserId: params.targetUserId,
    actorName: actor.displayName,
    token: settings.notifications.push ? target.fcmToken ?? null : null,
    postId: params.postId,
    commentId: params.commentId,
    previewText: params.previewText ?? null,
  };
}

export async function listComments(
  postId: string,
  viewerId?: string
): Promise<CommentResponse[]> {
  const comments = await prisma.comment.findMany({
    where: { postId },
    include: { user: true },
    orderBy: { createdAt: "asc" },
  });
  let likedIds = new Set<string>();
  if (viewerId && comments.length > 0) {
    const likes = await prisma.commentLike.findMany({
      where: { userId: viewerId, commentId: { in: comments.map((c) => c.id) } },
      select: { commentId: true },
    });
    likedIds = new Set(likes.map((like) => like.commentId));
  }
  return comments.map((comment) =>
    toCommentResponseInternal(comment, likedIds.has(comment.id))
  );
}

export function findCommentById(commentId: string) {
  return prisma.comment.findUnique({ where: { id: commentId } });
}

export async function addComment(
  post: PostWithUser,
  userId: string,
  content: string
): Promise<CommentResponse> {
  const { comment, notificationDispatch } = await prisma.$transaction(
    async (tx) => {
      const created = await tx.comment.create({
        data: { postId: post.id, userId, content },
        include: { user: true },
      });
      await tx.post.update({
        where: { id: post.id },
        data: { commentsCount: { increment: 1 } },
      });
      const dispatchContext = await maybeCreateNotification(tx, {
        targetUserId: post.userId,
        actorId: userId,
        type: "COMMENT",
        postId: post.id,
        commentId: created.id,
        previewText: content,
      });
      return { comment: created, notificationDispatch: dispatchContext };
    }
  );
  await dispatchNotificationPush(notificationDispatch);
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

export function likeComment(commentId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.commentLike.findUnique({
      where: { commentId_userId: { commentId, userId } },
    });
    if (existing) {
      throw ERROR.CONFLICT("Already liked");
    }
    const comment = await tx.comment.findUnique({
      where: { id: commentId },
      include: { user: true },
    });
    if (!comment) {
      throw ERROR.NOT_FOUND("Comment not found");
    }
    await tx.commentLike.create({ data: { commentId, userId } });
    const updated = await tx.comment.update({
      where: { id: commentId },
      data: { likesCount: { increment: 1 } },
      include: { user: true },
    });
    return toCommentResponseInternal(updated, true);
  });
}

export function unlikeComment(commentId: string, userId: string) {
  return prisma.$transaction(async (tx) => {
    const existing = await tx.commentLike.findUnique({
      where: { commentId_userId: { commentId, userId } },
    });
    if (!existing) {
      throw ERROR.NOT_FOUND("Like not found");
    }
    const updated = await tx.comment.update({
      where: { id: commentId },
      data: { likesCount: { decrement: 1 } },
      include: { user: true },
    });
    await tx.commentLike.delete({ where: { id: existing.id } });
    return toCommentResponseInternal(updated, false);
  });
}

export async function listNotificationsForUser(
  userId: string,
  options: { cursor?: string | null; limit?: number; unreadOnly?: boolean } = {}
): Promise<PaginatedResult<NotificationResponse>> {
  const limit = Math.min(Math.max(options.limit ?? 20, 1), 100);
  const notifications = await prisma.notification.findMany({
    where: {
      userId,
      ...(options.unreadOnly ? { isRead: false } : {}),
    },
    include: {
      actor: true,
      post: { include: { user: true, quotedPost: { include: { user: true } } } },
      comment: { include: { user: true } },
    },
    orderBy: { createdAt: "desc" },
    take: limit + 1,
    ...(options.cursor ? { skip: 1, cursor: { id: options.cursor } } : {}),
  });

  const hasNextPage = notifications.length > limit;
  const nodes = hasNextPage ? notifications.slice(0, limit) : notifications;
  const nextCursor = hasNextPage ? nodes[nodes.length - 1]?.id ?? null : null;
  const data = await Promise.all(
    nodes.map((notification) => toNotificationResponseInternal(notification))
  );

  return {
    data,
    pageInfo: {
      nextCursor,
      hasNextPage,
      count: data.length,
    },
  };
}

export async function markNotificationRead(userId: string, notificationId: string) {
  const notification = await prisma.notification.findUnique({
    where: { id: notificationId },
    include: {
      actor: true,
      post: { include: { user: true, quotedPost: { include: { user: true } } } },
      comment: { include: { user: true } },
    },
  });
  if (!notification) {
    throw ERROR.NOT_FOUND("Notification not found");
  }
  if (notification.userId !== userId) {
    throw ERROR.FORBIDDEN("You cannot update this notification");
  }

  const updated = await prisma.notification.update({
    where: { id: notificationId },
    data: { isRead: true },
    include: {
      actor: true,
      post: { include: { user: true, quotedPost: { include: { user: true } } } },
      comment: { include: { user: true } },
    },
  });

  return toNotificationResponseInternal(updated);
}

export async function markAllNotificationsRead(userId: string) {
  const result = await prisma.notification.updateMany({
    where: { userId, isRead: false },
    data: { isRead: true },
  });
  return result.count;
}

export function addFollow(followerId: string, followingId: string) {
  if (followerId === followingId) {
    throw ERROR.INVALID_INPUT("Cannot follow yourself");
  }

  return prisma
    .$transaction(async (tx) => {
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

      const notificationDispatch = await maybeCreateNotification(tx, {
        targetUserId: followingId,
        actorId: followerId,
        type: "FOLLOW",
      });

      return { follow, notificationDispatch };
    })
    .then(async ({ follow, notificationDispatch }) => {
      await dispatchNotificationPush(notificationDispatch);
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

export async function createBlock(blockerId: string, blockedId: string) {
  if (blockerId === blockedId) {
    throw ERROR.INVALID_INPUT("You cannot block yourself");
  }

  return prisma.$transaction(async (tx) => {
    const target = await tx.user.findUnique({ where: { id: blockedId } });
    if (!target) {
      throw ERROR.NOT_FOUND("User not found");
    }

    const existing = await tx.block.findUnique({
      where: { blockerId_blockedId: { blockerId, blockedId } },
    });
    if (existing) {
      return existing;
    }

    return tx.block.create({
      data: { blockerId, blockedId },
    });
  });
}

export async function removeBlock(blockId: string, blockerId: string) {
  return prisma.$transaction(async (tx) => {
    const block = await tx.block.findUnique({ where: { id: blockId } });
    if (!block) {
      throw ERROR.NOT_FOUND("Block not found");
    }
    if (block.blockerId !== blockerId) {
      throw ERROR.FORBIDDEN("You cannot remove this block");
    }
    await tx.block.delete({ where: { id: blockId } });
    return block;
  });
}

export async function listBlocks(blockerId: string): Promise<BlockResponse[]> {
  const blocks = await prisma.block.findMany({
    where: { blockerId },
    include: { blocked: true },
    orderBy: { createdAt: "desc" },
  });
  return blocks.map((block) => ({
    id: block.id,
    blockerId: block.blockerId,
    blockedId: block.blockedId,
    createdAt: block.createdAt,
    blockedUser: block.blocked ? toUserSummary(block.blocked) : null,
  }));
}

export async function createReport(params: {
  reporterId: string;
  type: ReportType;
  targetId: string;
  reason: ReportReason;
  description?: string | null;
}): Promise<ReportResponse> {
  const report = await prisma.report.create({
    data: {
      reporterId: params.reporterId,
      type: params.type,
      targetId: params.targetId,
      reason: params.reason,
      description: params.description ?? null,
    },
    include: {
      reporter: true,
    },
  });
  return {
    ...report,
    reporter: toUserSummary(report.reporter),
  };
}

async function hasBlockingBetween(
  userId: string,
  viewerId?: string,
  client: Prisma.TransactionClient | typeof prisma = prisma
) {
  if (!viewerId) {
    return false;
  }
  const block = await client.block.findFirst({
    where: {
      OR: [
        { blockerId: userId, blockedId: viewerId },
        { blockerId: viewerId, blockedId: userId },
      ],
    },
    select: { id: true },
  });
  return !!block;
}

export async function canViewPost(post: PrismaPost, viewerId?: string) {
  if (await hasBlockingBetween(post.userId, viewerId)) {
    return false;
  }
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
  mistakeCharacters?: Record<string, number>;
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
      mistakeCharacters: params.mistakeCharacters ?? Prisma.JsonNull,
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

  const mistakeCounts = completions.reduce<Record<string, number>>(
    (acc, completion) => {
      if (completion.mistakeCharacters) {
        Object.entries(
          completion.mistakeCharacters as Record<string, number>
        ).forEach(([char, value]) => {
          if (!char || typeof value !== "number") {
            return;
          }
          acc[char] = (acc[char] ?? 0) + value;
        });
      }
      return acc;
    },
    {}
  );

  const weakCharacters = Object.entries(mistakeCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3)
    .map(([char]) => char);

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

export function toWordbookEntry(word: PrismaWordbook): WordbookEntry {
  return {
    id: word.id,
    userId: word.userId,
    word: word.word,
    meaning: word.meaning,
    example: word.example,
    status: word.status,
    category: word.category,
    lastReviewedAt: word.lastReviewedAt,
    reviewCount: word.reviewCount,
    successRate: word.successRate,
    tags: [...word.tags],
    createdAt: word.createdAt,
    updatedAt: word.updatedAt,
  };
}
