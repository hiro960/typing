import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dio/dio.dart';
import '../../../auth/domain/providers/auth_providers.dart';
import '../../data/models/blocked_account.dart';
import '../../data/models/diary_comment.dart';
import '../../data/models/diary_notification.dart';
import '../../data/models/diary_post.dart';
import '../../data/repositories/diary_repository.dart';
import '../../data/services/ai_correction_service.dart';

part 'diary_providers.g.dart';

@riverpod
DiaryRepository diaryRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return DiaryRepository(apiClient: apiClient);
}

@riverpod
AiCorrectionService aiCorrectionService(Ref ref) {
  return AiCorrectionService(Dio());
}

final blockedAccountsProvider =
    FutureProvider.autoDispose<List<BlockedAccount>>((ref) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.fetchBlockedAccounts();
});

class DiaryFeedData {
  const DiaryFeedData({
    this.posts = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.initialized = false,
    this.errorMessage,
  });

  final List<DiaryPost> posts;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool initialized;
  final String? errorMessage;

  DiaryFeedData copyWith({
    List<DiaryPost>? posts,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? initialized,
    String? errorMessage,
  }) {
    return DiaryFeedData(
      posts: posts ?? this.posts,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      initialized: initialized ?? this.initialized,
      errorMessage: errorMessage,
    );
  }
}

class DiaryTimelineState {
  const DiaryTimelineState({
    this.feeds = const {},
  });

  final Map<DiaryFeedType, DiaryFeedData> feeds;

  DiaryFeedData feed(DiaryFeedType type) =>
      feeds[type] ?? const DiaryFeedData();

  DiaryTimelineState setFeed(DiaryFeedType type, DiaryFeedData data) {
    final updated = Map<DiaryFeedType, DiaryFeedData>.from(feeds);
    updated[type] = data;
    return DiaryTimelineState(feeds: updated);
  }
}

@Riverpod(keepAlive: true)
class DiaryTimelineController extends _$DiaryTimelineController {
  DiaryRepository get _repository => ref.watch(diaryRepositoryProvider);

  @override
  DiaryTimelineState build() => const DiaryTimelineState();

  Future<void> ensureLoaded(DiaryFeedType feed) async {
    final feedState = state.feed(feed);
    if (feedState.initialized || feedState.isLoading) {
      return;
    }
    await _fetchFeed(feed, refresh: true);
  }

  Future<void> refresh(DiaryFeedType feed) async {
    await _fetchFeed(feed, refresh: true);
  }

  Future<void> loadMore(DiaryFeedType feed) async {
    final feedState = state.feed(feed);
    if (!feedState.hasMore || feedState.isLoadingMore) {
      return;
    }
    await _fetchFeed(feed);
  }

  Future<void> _fetchFeed(
    DiaryFeedType feed, {
    bool refresh = false,
  }) async {
    final current = state.feed(feed);
    if (refresh) {
      state = state.setFeed(
        feed,
        current.copyWith(
          isLoading: true,
          errorMessage: null,
          initialized: true,
        ),
      );
    } else if (current.isLoading || current.isLoadingMore) {
      return;
    } else {
      state = state.setFeed(
        feed,
        current.copyWith(
          isLoadingMore: true,
          errorMessage: null,
        ),
      );
    }

    final previous = state;
    try {
      final page = await _repository.fetchPosts(
        feed: feed,
        cursor: refresh ? null : current.nextCursor,
      );
      final posts = refresh ? page.posts : [...current.posts, ...page.posts];
      state = state.setFeed(
        feed,
        current.copyWith(
          posts: posts,
          nextCursor: page.nextCursor,
          hasMore: page.hasNextPage,
          isLoading: false,
          isLoadingMore: false,
          initialized: true,
          errorMessage: null,
        ),
      );
    } catch (error) {
      state = previous.setFeed(
        feed,
        current.copyWith(
          isLoading: false,
          isLoadingMore: false,
          initialized: current.initialized,
          errorMessage: error.toString(),
        ),
      );
      rethrow;
    }
  }

  void prependPost(DiaryPost post) {
    final feed = DiaryFeedType.recommended;
    final feedState = state.feed(feed);
    final updatedPosts = [post, ...feedState.posts];
    state = state.setFeed(
      feed,
      feedState.copyWith(
        posts: updatedPosts,
        initialized: true,
      ),
    );
  }

  void updatePost(DiaryPost post) {
    _updatePostEverywhere(post.id, (_) => post);
  }

  void adjustCommentCount(String postId, int delta) {
    _updatePostEverywhere(postId, (post) {
      final updatedCount = (post.commentsCount + delta).clamp(0, 1 << 31);
      return post.copyWith(commentsCount: updatedCount);
    });
  }

  Future<void> toggleLike(String postId, {required bool like}) async {
    final previous = state;
    _updatePostEverywhere(postId, (post) {
      final updatedCount = like
          ? post.likesCount + 1
          : (post.likesCount - 1).clamp(0, 1 << 31);
      return post.copyWith(liked: like, likesCount: updatedCount);
    });
    try {
      final result =
          await _repository.toggleLike(postId, like: like);
      _updatePostEverywhere(postId, (post) {
        return post.copyWith(
          liked: result.isActive,
          likesCount: result.count,
        );
      });
    } catch (error) {
      state = previous;
      rethrow;
    }
  }

  Future<void> toggleBookmark(String postId, {required bool bookmark}) async {
    final previous = state;
    _updatePostEverywhere(
      postId,
      (post) => post.copyWith(bookmarked: bookmark),
    );
    try {
      await _repository.toggleBookmark(postId, bookmark: bookmark);
    } catch (error) {
      state = previous;
      rethrow;
    }
  }



  void _updatePostEverywhere(
    String postId,
    DiaryPost Function(DiaryPost post) updater,
  ) {
    var changed = false;
    final updatedFeeds = <DiaryFeedType, DiaryFeedData>{};
    state.feeds.forEach((feed, feedData) {
      final index = feedData.posts.indexWhere((post) => post.id == postId);
      if (index == -1) {
        updatedFeeds[feed] = feedData;
        return;
      }
      final posts = [...feedData.posts];
      posts[index] = updater(posts[index]);
      updatedFeeds[feed] = feedData.copyWith(posts: posts);
      changed = true;
    });
    if (changed) {
      state = DiaryTimelineState(feeds: {
        ...state.feeds,
        ...updatedFeeds,
      });
    }
  }

  void removePost(String postId) {
    var changed = false;
    final updatedFeeds = <DiaryFeedType, DiaryFeedData>{};
    state.feeds.forEach((feed, feedData) {
      final exists = feedData.posts.any((post) => post.id == postId);
      if (!exists) {
        updatedFeeds[feed] = feedData;
        return;
      }
      final posts =
          feedData.posts.where((post) => post.id != postId).toList();
      updatedFeeds[feed] = feedData.copyWith(posts: posts);
      changed = true;
    });
    if (changed) {
      state = DiaryTimelineState(feeds: {
        ...state.feeds,
        ...updatedFeeds,
      });
    }
  }
}

class DiaryCommentsState {
  const DiaryCommentsState({
    this.comments = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  final List<DiaryComment> comments;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  DiaryCommentsState copyWith({
    List<DiaryComment>? comments,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return DiaryCommentsState(
      comments: comments ?? this.comments,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class PostCommentsController extends _$PostCommentsController {
  DiaryRepository get _repository => ref.watch(diaryRepositoryProvider);
  late String _postId;

  @override
  DiaryCommentsState build(String postId) {
    _postId = postId;
    return const DiaryCommentsState();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final page = await _repository.fetchComments(_postId);
      state = state.copyWith(
        comments: page.comments,
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    try {
      final page = await _repository.fetchComments(
        _postId,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        comments: [...state.comments, ...page.comments],
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoadingMore: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> addComment(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    try {
      final comment = await _repository.addComment(_postId, trimmed);
      state = state.copyWith(comments: [comment, ...state.comments]);
      ref
          .read(diaryTimelineControllerProvider.notifier)
          .adjustCommentCount(_postId, 1);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId) async {
    final previous = state;
    state = state.copyWith(
      comments:
          state.comments.where((comment) => comment.id != commentId).toList(),
    );
    try {
      await _repository.deleteComment(commentId);
      ref
          .read(diaryTimelineControllerProvider.notifier)
          .adjustCommentCount(_postId, -1);
    } catch (error) {
      state = previous;
      rethrow;
    }
  }

  Future<void> toggleCommentLike(
    String commentId, {
    required bool like,
  }) async {
    final previous = state;
    state = state.copyWith(
      comments: state.comments
          .map(
            (comment) => comment.id == commentId
                ? comment.copyWith(
                    liked: like,
                    likesCount: like
                        ? comment.likesCount + 1
                        : (comment.likesCount - 1).clamp(0, 1 << 31),
                  )
                : comment,
          )
          .toList(),
    );
    try {
      final result = await _repository.toggleCommentLike(
        commentId,
        like: like,
      );
      state = state.copyWith(
        comments: state.comments
            .map(
              (comment) => comment.id == commentId
                  ? comment.copyWith(
                      liked: result.isActive,
                      likesCount: result.count,
                    )
                  : comment,
            )
            .toList(),
      );
    } catch (error) {
      state = previous;
      rethrow;
    }
  }
}

class DiaryBookmarksState {
  const DiaryBookmarksState({
    this.posts = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  final List<DiaryPost> posts;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  DiaryBookmarksState copyWith({
    List<DiaryPost>? posts,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return DiaryBookmarksState(
      posts: posts ?? this.posts,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class DiaryBookmarksController extends _$DiaryBookmarksController {
  DiaryRepository get _repository => ref.watch(diaryRepositoryProvider);

  @override
  DiaryBookmarksState build() => const DiaryBookmarksState();

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final page = await _repository.fetchBookmarks();
      state = state.copyWith(
        posts: page.posts,
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    try {
      final page = await _repository.fetchBookmarks(cursor: state.nextCursor);
      state = state.copyWith(
        posts: [...state.posts, ...page.posts],
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoadingMore: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  void replacePost(DiaryPost post) {
    final index = state.posts.indexWhere((item) => item.id == post.id);
    if (index == -1) return;
    final updated = [...state.posts];
    updated[index] = post;
    state = state.copyWith(posts: updated);
  }

  void removePost(String postId) {
    state = state.copyWith(
      posts: state.posts.where((post) => post.id != postId).toList(),
    );
  }
}

class DiaryNotificationsState {
  const DiaryNotificationsState({
    this.notifications = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.unreadOnly = false,
    this.errorMessage,
  });

  final List<DiaryNotification> notifications;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool unreadOnly;
  final String? errorMessage;

  DiaryNotificationsState copyWith({
    List<DiaryNotification>? notifications,
    String? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool? unreadOnly,
    String? errorMessage,
  }) {
    return DiaryNotificationsState(
      notifications: notifications ?? this.notifications,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class DiaryNotificationsController extends _$DiaryNotificationsController {
  DiaryRepository get _repository => ref.watch(diaryRepositoryProvider);

  bool _disposed = false;

  @override
  DiaryNotificationsState build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
    return const DiaryNotificationsState();
  }

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final page = await _repository.fetchNotifications(
        unreadOnly: state.unreadOnly,
      );
      if (_disposed) return;
      state = state.copyWith(
        notifications: page.notifications,
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoading: false,
      );
    } catch (error) {
      if (_disposed) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    try {
      final page = await _repository.fetchNotifications(
        cursor: state.nextCursor,
        unreadOnly: state.unreadOnly,
      );
      if (_disposed) return;
      state = state.copyWith(
        notifications: [...state.notifications, ...page.notifications],
        nextCursor: page.nextCursor,
        hasMore: page.hasNextPage,
        isLoadingMore: false,
      );
    } catch (error) {
      if (_disposed) return;
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      notifications: const [],
      nextCursor: null,
      hasMore: false,
    );
    await loadInitial();
  }

  Future<void> toggleUnreadOnly(bool unreadOnly) async {
    state = state.copyWith(
      unreadOnly: unreadOnly,
      notifications: const [],
      nextCursor: null,
      hasMore: false,
    );
    await loadInitial();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markNotificationRead(notificationId);
      if (_disposed) return;
      state = state.copyWith(
        notifications: state.notifications
            .map(
              (notification) => notification.id == notificationId
                  ? DiaryNotification(
                      id: notification.id,
                      type: notification.type,
                      actor: notification.actor,
                      isRead: true,
                      post: notification.post,
                      comment: notification.comment,
                      postId: notification.postId,
                      commentId: notification.commentId,
                      createdAt: notification.createdAt,
                    )
                  : notification,
            )
            .toList(),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> markAllRead() async {
    try {
      await _repository.markAllNotificationsRead();
      if (_disposed) return;
      state = state.copyWith(
        notifications: state.notifications
            .map(
              (notification) => DiaryNotification(
                id: notification.id,
                type: notification.type,
                actor: notification.actor,
                isRead: true,
                post: notification.post,
                comment: notification.comment,
                postId: notification.postId,
                commentId: notification.commentId,
                createdAt: notification.createdAt,
              ),
            )
            .toList(),
      );
    } catch (error) {
      rethrow;
    }
  }
}
