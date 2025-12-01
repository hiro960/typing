import 'package:dio/dio.dart';
import 'package:chaletta/core/constants/api_constants.dart';
import 'package:chaletta/features/auth/data/services/api_client_service.dart';
import 'package:chaletta/features/exchange_rate/data/models/exchange_rate_model.dart';

/// 為替レートのリポジトリ
class ExchangeRateRepository {
  ExchangeRateRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  /// 為替レートを取得
  Future<ExchangeRate> fetchExchangeRate({
    String base = 'JPY',
    String target = 'KRW',
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.exchangeRate,
        queryParameters: {
          'base': base,
          'target': target,
        },
      );

      return ExchangeRate.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }
}
