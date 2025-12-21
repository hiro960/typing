import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/logger.dart';
import '../models/app_version_info.dart';

/// バージョン情報取得リポジトリ
/// 認証不要のため、専用のDioインスタンスを使用
class AppVersionRepository {
  late final Dio _dio;

  AppVersionRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 4),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// バージョン情報を取得
  /// GET /api/app-version
  Future<AppVersionResponse> getAppVersion() async {
    try {
      AppLogger.debug('Fetching app version info', tag: 'AppVersionRepository');

      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.appVersion,
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      return AppVersionResponse.fromJson(response.data!);
    } on DioException catch (e) {
      AppLogger.error(
        'Failed to fetch app version',
        tag: 'AppVersionRepository',
        error: e,
      );
      rethrow;
    }
  }
}
