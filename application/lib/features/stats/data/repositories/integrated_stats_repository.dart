import 'package:dio/dio.dart';
import 'package:chaletta/core/constants/api_constants.dart';
import 'package:chaletta/features/auth/data/services/api_client_service.dart';
import 'package:chaletta/features/stats/data/models/integrated_stats_model.dart';

/// 統合統計のリポジトリ
class IntegratedStatsRepository {
  IntegratedStatsRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// 統合統計を取得
  Future<IntegratedStats> fetchIntegratedStats({String range = 'weekly'}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.integratedStats,
        queryParameters: {'range': range},
      );

      return IntegratedStats.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }
}
