import 'package:dio/dio.dart';
import 'package:chaletta/core/constants/api_constants.dart';
import 'package:chaletta/features/auth/data/services/api_client_service.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';

/// 発音ゲームのリポジトリ
class PronunciationGameRepository {
  PronunciationGameRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// ゲーム結果を送信
  Future<PronunciationGameResultResponse> submitGameResult({
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required int characterLevel,
    int? timeSpent,
    double? accuracy,
  }) async {
    try {
      final data = <String, dynamic>{
        'difficulty': difficulty,
        'score': score,
        'correctCount': correctCount,
        'maxCombo': maxCombo,
        'totalBonusTime': totalBonusTime,
        'characterLevel': characterLevel,
      };

      if (timeSpent != null) {
        data['timeSpent'] = timeSpent;
      }
      if (accuracy != null) {
        data['accuracy'] = accuracy;
      }

      final response = await _apiClient.dio.post(
        ApiConstants.pronunciationGameResults,
        data: data,
      );

      return PronunciationGameResultResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ランキングを取得
  Future<PronunciationRankingDataResponse> getRanking({
    String difficulty = 'all',
    String period = 'monthly',
    int limit = 50,
    bool followingOnly = false,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.pronunciationGameRanking,
        queryParameters: {
          'difficulty': difficulty,
          'period': period,
          'limit': limit,
          'following': followingOnly.toString(),
        },
      );

      return PronunciationRankingDataResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// 自分の統計を取得
  Future<PronunciationGameUserStats> getMyStats() async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.pronunciationGameMyStats,
      );

      return PronunciationGameUserStats.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// 自分の統計を取得（軽量版・ホーム画面用）
  Future<PronunciationGameStatsSummary> getMyStatsSummary() async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.pronunciationGameMyStatsSummary,
      );

      return PronunciationGameStatsSummary.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }
}
