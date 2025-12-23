import 'package:chaletta/features/analysis/domain/models/analysis_models.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/data/services/api_client_service.dart';

class AnalysisRepository {
  AnalysisRepository({required ApiClientService apiClient})
      : _apiClient = apiClient;

  final ApiClientService _apiClient;

  Future<AnalysisDashboard> fetchDashboard({
    String period = 'month',
    String? calendarMonth,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.analysisDashboard,
        queryParameters: {
          'period': period,
          if (calendarMonth != null) 'calendarMonth': calendarMonth,
        },
      );

      return AnalysisDashboard.fromJson(response.data);
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }
}
