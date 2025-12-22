import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/exceptions/app_exception.dart';
import 'token_storage_service.dart';
import 'auth0_service.dart';

/// APIクライアントを管理するサービス
/// Dioのインスタンスを提供し、インターセプターを設定
class ApiClientService {
  late final Dio _dio;
  final TokenStorageService _tokenStorage;
  final Auth0Service _auth0Service;

  ApiClientService({
    required TokenStorageService tokenStorage,
    required Auth0Service auth0Service,
  })  : _tokenStorage = tokenStorage,
        _auth0Service = auth0Service {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        // タイムアウトを短縮（起動時の待ち時間改善）
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// Dioインスタンスを取得
  Dio get dio => _dio;

  /// インターセプターの設定
  void _setupInterceptors() {
    // リクエストインターセプター (トークンの自動付与)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // ログインターセプター (開発環境のみ)
    if (EnvConfig.isDevelopment) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => AppLogger.debug(obj.toString(), tag: 'Dio'),
        ),
      );
    }
  }

  /// リクエスト前の処理
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // トークンを取得してAuthorizationヘッダーに設定
      final accessToken = await _tokenStorage.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      AppLogger.error('Request interceptor error', tag: 'ApiClient', error: e);
      handler.next(options);
    }
  }

  /// レスポンス受信後の処理
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.apiResponse(
      method: response.requestOptions.method,
      path: response.requestOptions.path,
      statusCode: response.statusCode ?? 0,
      body: response.data,
    );

    handler.next(response);
  }

  /// エラー発生時の処理
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    AppLogger.error(
      'API Error: ${error.message}',
      tag: 'ApiClient',
      error: error,
    );

    // 401エラーの場合、トークンをリフレッシュして再試行
    if (error.response?.statusCode == 401) {
      // リトライ回数をチェック（無限ループ防止）
      final retryCount = error.requestOptions.extra['retry_count'] as int? ?? 0;

      if (retryCount >= 3) {
        AppLogger.error(
          'Maximum retry attempts (3) reached for 401 error',
          tag: 'ApiClient',
        );
        // 最大リトライ回数に達したらログアウト
        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: AuthException.tokenExpired(),
            type: DioExceptionType.unknown,
          ),
        );
      }

      try {
        AppLogger.auth('401 error detected, attempting token refresh (attempt ${retryCount + 1}/3)');

        // トークンをリフレッシュ
        final newTokens = await _auth0Service.refreshTokens();
        await _tokenStorage.saveTokens(newTokens);

        AppLogger.auth('Token refreshed, retrying request');

        // 元のリクエストを再試行（リトライカウントを増やす）
        final options = error.requestOptions;
        options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
        options.extra['retry_count'] = retryCount + 1;

        final response = await _dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        AppLogger.error(
          'Token refresh failed',
          tag: 'ApiClient',
          error: e,
        );
        // リフレッシュに失敗したら、すべてのクレデンシャルをクリア
        try {
          await _tokenStorage.deleteTokens();
          await _auth0Service.clearCredentials();
          AppLogger.auth('Cleared all credentials after refresh failure');
        } catch (clearError) {
          AppLogger.error(
            'Failed to clear credentials',
            tag: 'ApiClient',
            error: clearError,
          );
        }
        // ログインページへ遷移させるため例外をスロー
        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: AuthException.tokenExpired(),
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    // その他のエラーはそのまま
    handler.next(error);
  }

  /// DioExceptionをAppExceptionに変換
  static AppException handleDioException(DioException error) {
    if (error.error is AppException) {
      return error.error as AppException;
    }

    // ネットワークエラー
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException.timeout();
    }

    // ネットワーク接続エラー
    if (error.type == DioExceptionType.connectionError) {
      return ApiException.networkError();
    }

    // レスポンスがある場合、ステータスコードに応じてエラーを作成
    final response = error.response;
    if (response != null) {
      final statusCode = response.statusCode ?? 0;
      final data = response.data;
      String message = 'エラーが発生しました';

      // バックエンドからのエラーメッセージを取得
      if (data is Map<String, dynamic> && data['error'] != null) {
        final errorData = data['error'];
        if (errorData is Map<String, dynamic>) {
          message = errorData['message'] as String? ?? message;
        }
      }

      switch (statusCode) {
        case 400:
          return ApiException.badRequest(message);
        case 401:
          return ApiException.unauthorized(message);
        case 403:
          return ApiException.forbidden(message);
        case 404:
          return ApiException.notFound(message);
        case 409:
          return ApiException.conflict(message);
        case 422:
          return ApiException.unprocessable(message);
        case >= 500:
          return ApiException.serverError(message);
        default:
          return ApiException(
            code: 'HTTP_ERROR',
            message: message,
            statusCode: statusCode,
            responseBody: data,
          );
      }
    }

    // その他の予期しないエラー
    return UnknownException(
      originalError: error,
      stackTrace: error.stackTrace,
    );
  }
}
