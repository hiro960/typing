import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/services/api_client_service.dart';
import '../../../diary/data/models/diary_post.dart';
import '../models/user_stats_model.dart';

class ProfileRepository {
  ProfileRepository({
    required ApiClientService apiClient,
  }) : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// ユーザープロフィールを取得
  Future<UserModel> fetchUserProfile(String userId) async {
    try {
      final response = await _apiClient.dio.get('/api/users/$userId');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch user profile',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ユーザー統計を取得
  Future<UserStatsModel> fetchUserStats(
    String userId, {
    String range = 'all',
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/users/$userId/stats',
        queryParameters: {'range': range},
      );
      return UserStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch user stats',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ユーザーの投稿を取得（最初のN件）
  Future<List<DiaryPost>> fetchUserPosts(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/users/$userId/posts',
        queryParameters: {'limit': limit},
      );
      final data = response.data['data'] as List<dynamic>?;
      if (data == null) {
        return [];
      }
      return data
          .map((json) => DiaryPost.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch user posts',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ユーザーをフォロー
  Future<void> followUser(String userId) async {
    try {
      await _apiClient.dio.post(
        '/api/follows',
        data: {'userId': userId},
      );
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to follow user',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ユーザーのフォローを解除
  Future<void> unfollowUser(String userId) async {
    try {
      await _apiClient.dio.delete('/api/follows/$userId');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to unfollow user',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// フォロワー一覧を取得
  Future<List<UserModel>> fetchFollowers(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/follows/followers',
        queryParameters: {
          'userId': userId,
          'limit': limit,
        },
      );
      final data = response.data['data'] as List<dynamic>?;
      if (data == null) {
        return [];
      }
      return data.map((json) {
        final userJson = json['user'] as Map<String, dynamic>;
        return UserModel.fromJson(userJson);
      }).toList();
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch followers',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  /// フォロー中一覧を取得
  Future<List<UserModel>> fetchFollowing(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/follows/following',
        queryParameters: {
          'userId': userId,
          'limit': limit,
        },
      );
      final data = response.data['data'] as List<dynamic>?;
      if (data == null) {
        return [];
      }
      return data.map((json) {
        final userJson = json['user'] as Map<String, dynamic>;
        return UserModel.fromJson(userJson);
      }).toList();
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch following',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<String> uploadProfileImage(File file) async {
    try {
      final filename = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'type': 'profile',
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
        'Failed to upload profile image',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<UserModel> updateProfileImage({
    required String userId,
    required String? profileImageUrl,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        ApiConstants.userById(userId),
        data: {'profileImageUrl': profileImageUrl},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to update profile image',
        tag: 'ProfileRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }
}
