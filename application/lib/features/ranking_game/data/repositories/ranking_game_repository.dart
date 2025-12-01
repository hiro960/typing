import 'package:dio/dio.dart';
import 'package:chaletta/core/constants/api_constants.dart';
import 'package:chaletta/core/exceptions/app_exception.dart';
import 'package:chaletta/features/auth/data/services/api_client_service.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';

/// ランキングゲームのリポジトリ
class RankingGameRepository {
  RankingGameRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// ゲーム結果を送信
  Future<RankingGameResultResponse> submitGameResult({
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required double avgInputSpeed,
    required int characterLevel,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.rankingGameResults,
        data: {
          'difficulty': difficulty,
          'score': score,
          'correctCount': correctCount,
          'maxCombo': maxCombo,
          'totalBonusTime': totalBonusTime,
          'avgInputSpeed': avgInputSpeed,
          'characterLevel': characterLevel,
        },
      );

      return RankingGameResultResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// ランキングを取得
  Future<RankingDataResponse> getRanking({
    String difficulty = 'all',
    String period = 'monthly',
    int limit = 50,
    bool followingOnly = false,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.rankingGameRanking,
        queryParameters: {
          'difficulty': difficulty,
          'period': period,
          'limit': limit,
          'following': followingOnly.toString(),
        },
      );

      return RankingDataResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// 自分の統計を取得
  Future<RankingGameUserStats> getMyStats() async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.rankingGameMyStats,
      );

      return RankingGameUserStats.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  /// 自分の統計を取得（軽量版・ホーム画面用）
  /// bestScoreのみを高速に取得
  Future<RankingGameStatsSummary> getMyStatsSummary() async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.rankingGameMyStatsSummary,
      );

      return RankingGameStatsSummary.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }
}
