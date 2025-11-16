import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/services/api_client_service.dart';
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
  Future<List<Map<String, dynamic>>> fetchUserPosts(
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
      return data.cast<Map<String, dynamic>>();
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
}
