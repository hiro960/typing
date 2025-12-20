import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../../auth/data/services/api_client_service.dart';
import '../models/blocked_account.dart';
import '../models/diary_comment.dart';
import '../models/diary_notification.dart';
import '../models/diary_post.dart';
import '../models/diary_search.dart';

enum DiaryFeedType { latest, recommended, following }

extension DiaryFeedTypeQuery on DiaryFeedType {
  String get query {
    switch (this) {
      case DiaryFeedType.latest:
        return 'latest';
      case DiaryFeedType.recommended:
        return 'recommended';
      case DiaryFeedType.following:
        return 'following';
    }
  }
}

class ToggleCountResult {
  ToggleCountResult({required this.isActive, required this.count});

  final bool isActive;
  final int count;
}

class DiaryRepository {
  DiaryRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  Future<DiaryFeedPage> fetchPosts({
    required DiaryFeedType feed,
    String? cursor,
    int limit = 20,
    String? visibility,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/posts',
        queryParameters: {
          'feed': feed.query,
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
          if (visibility != null) 'visibility': visibility,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final posts = (payload['data'] as List<dynamic>? ?? [])
          .map((item) =>
              DiaryPost.fromJson(item as Map<String, dynamic>))
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryFeedPage(posts: posts, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch diary posts',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryFeedPage> fetchBookmarks({
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/bookmarks',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final posts = (payload['data'] as List<dynamic>? ?? [])
          .map(
            (item) => DiaryPost.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryFeedPage(posts: posts, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch bookmarks',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryPost> fetchPostById(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/posts/$id');
      return DiaryPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch diary post',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryPost> createPost({
    required String content,
    List<String> imageUrls = const [],
    String visibility = 'public',
    List<String> tags = const [],
    String? quotedPostId,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/posts',
        data: {
          'content': content,
          'imageUrls': imageUrls,
          'visibility': visibility,
          'tags': tags,
          if (quotedPostId != null) 'quotedPostId': quotedPostId,
        },
      );
      return DiaryPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to create diary post',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryPost> updatePost(
    String postId, {
    String? content,
    List<String>? imageUrls,
    String? visibility,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiClient.dio.patch(
        '/api/posts/$postId',
        data: {
          if (content != null) 'content': content,
          if (imageUrls != null) 'imageUrls': imageUrls,
          if (visibility != null) 'visibility': visibility,
          if (tags != null) 'tags': tags,
        },
      );
      return DiaryPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to update diary post',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _apiClient.dio.delete('/api/posts/$postId');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to delete diary post',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<ToggleCountResult> toggleLike(String postId, {required bool like}) async {
    try {
      final response = like
          ? await _apiClient.dio.post('/api/posts/$postId/like')
          : await _apiClient.dio.delete('/api/posts/$postId/like');
      final data = response.data as Map<String, dynamic>;
      return ToggleCountResult(
        isActive: data['liked'] as bool? ?? like,
        count: data['likesCount'] as int? ?? 0,
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to toggle like',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> toggleBookmark(String postId, {required bool bookmark}) async {
    try {
      if (bookmark) {
        await _apiClient.dio.post('/api/posts/$postId/bookmark');
      } else {
        await _apiClient.dio.delete('/api/posts/$postId/bookmark');
      }
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to toggle bookmark',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }



  Future<DiaryCommentsPage> fetchComments(
    String postId, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/posts/$postId/comments',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final comments = (payload['data'] as List<dynamic>? ?? [])
          .map((item) =>
              DiaryComment.fromJson(item as Map<String, dynamic>))
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryCommentsPage(comments: comments, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch comments',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryComment> addComment(String postId, String content) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/posts/$postId/comments',
        data: {'content': content},
      );
      return DiaryComment.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to add comment',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _apiClient.dio.delete('/api/comments/$commentId');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to delete comment',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<ToggleCountResult> toggleCommentLike(
    String commentId, {
    required bool like,
  }) async {
    try {
      final response = like
          ? await _apiClient.dio.post('/api/comments/$commentId/like')
          : await _apiClient.dio.delete('/api/comments/$commentId/like');
      final data = response.data as Map<String, dynamic>;
      return ToggleCountResult(
        isActive: data['liked'] as bool? ?? like,
        count: data['likesCount'] as int? ?? 0,
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to toggle comment like',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<String> uploadPostImage(File file) async {
    try {
      final filename = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'type': 'post',
        'file': await MultipartFile.fromFile(
          file.path,
          filename: filename,
        ),
      });
      final response = await _apiClient.dio.post(
        '/api/upload/image',
        data: formData,
      );
      final payload = response.data as Map<String, dynamic>;
      return payload['url'] as String? ?? '';
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to upload image',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryFeedPage> searchPosts(
    String query, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/search',
        queryParameters: {
          'q': query,
          'type': 'posts',
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final posts = (payload['data'] as List<dynamic>? ?? [])
          .map(
            (item) => DiaryPost.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryFeedPage(posts: posts, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to search posts',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryUserSearchPage> searchUsers(
    String query, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/search',
        queryParameters: {
          'q': query,
          'type': 'users',
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final users = (payload['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DiaryUserSummary.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryUserSearchPage(users: users, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to search users',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryHashtagSearchPage> searchHashtags(
    String query, {
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/search',
        queryParameters: {
          'q': query,
          'type': 'hashtags',
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final tags = (payload['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DiaryHashtagTrend.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryHashtagSearchPage(tags: tags, pageInfo: pageInfo);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to search hashtags',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<DiaryNotificationsPage> fetchNotifications({
    String? cursor,
    bool unreadOnly = false,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/notifications',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
          if (unreadOnly) 'unreadOnly': true,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final notifications = (payload['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                DiaryNotification.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final pageInfo = DiaryPageInfo.fromJson(
        payload['pageInfo'] as Map<String, dynamic>? ?? const {},
      );
      return DiaryNotificationsPage(
        notifications: notifications,
        pageInfo: pageInfo,
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch notifications',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await _apiClient.dio.patch('/api/notifications/$id/read');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to mark notification read',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await _apiClient.dio.patch('/api/notifications/mark-all-read');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to mark notifications read',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await _apiClient.dio.post('/api/blocks', data: {'blockedId': userId});
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to block user',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<List<BlockedAccount>> fetchBlockedAccounts() async {
    try {
      final response = await _apiClient.dio.get('/api/blocks');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => BlockedAccount.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch blocked accounts',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> unblock(String blockId) async {
    try {
      await _apiClient.dio.delete('/api/blocks/$blockId');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to unblock user',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> reportPost({
    required String postId,
    required String reason,
    String? description,
  }) async {
    try {
      await _apiClient.dio.post('/api/reports', data: {
        'type': 'POST',
        'targetId': postId,
        'reason': reason,
        if (description?.isNotEmpty ?? false) 'description': description,
      });
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to report post',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> updatePushToken(String token) async {
    try {
      await _apiClient.dio.put(
        '/api/users/me/push-token',
        data: {'fcmToken': token},
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to update push token',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> clearPushToken() async {
    try {
      await _apiClient.dio.delete('/api/users/me/push-token');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to clear push token',
        tag: 'DiaryRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }
}
