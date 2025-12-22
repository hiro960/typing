import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/user_status_response.dart';
import '../models/auth_tokens.dart';
import '../services/auth0_service.dart';
import '../services/token_storage_service.dart';
import '../services/api_client_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/exceptions/app_exception.dart';

/// 認証関連のビジネスロジックを管理するリポジトリ
class AuthRepository {
  final Auth0Service _auth0Service;
  final TokenStorageService _tokenStorage;
  final ApiClientService _apiClient;

  AuthRepository({
    required Auth0Service auth0Service,
    required TokenStorageService tokenStorage,
    required ApiClientService apiClient,
  })  : _auth0Service = auth0Service,
        _tokenStorage = tokenStorage,
        _apiClient = apiClient;

  // ==================== 認証フロー ====================

  /// ログイン処理
  /// 1. Auth0でログイン
  /// 2. トークンを保存
  /// 3. ユーザー登録状況を確認
  Future<UserStatusResponse> login() async {
    try {
      AppLogger.auth('Starting login flow');

      // 1. Auth0でログイン
      final tokens = await _auth0Service.login();

      // 2. トークンを保存
      await _tokenStorage.saveTokens(tokens);

      // 3. ユーザー登録状況を確認
      final status = await checkUserStatus();

      AppLogger.auth('Login flow completed', detail: 'registered: ${status.registered}');

      return status;
    } catch (e) {
      AppLogger.error('Login flow failed', tag: 'AuthRepository', error: e);
      rethrow;
    }
  }

  /// ログアウト処理（ローカルのみ）
  /// ローカルのトークンとクレデンシャルを削除
  /// 次回ログイン時は prompt=login により必ずソーシャルメディア選択画面が表示される
  Future<void> logout() async {
    try {
      AppLogger.auth('Starting logout flow (local only)');

      // 1. ローカルトークンを削除
      await _tokenStorage.deleteTokens();

      // 2. Auth0のクレデンシャルもクリア
      await _auth0Service.clearCredentials();

      AppLogger.auth('Logout flow completed');
    } catch (e) {
      AppLogger.error('Logout flow failed', tag: 'AuthRepository', error: e);
      rethrow;
    }
  }

  /// 保存されているトークンから自動ログイン
  /// アプリ起動時に呼び出す
  ///
  /// CredentialsManager を中心に据えたアプローチ：
  /// 1. CredentialsManager から有効なトークンを取得（期限切れなら自動リフレッシュ）
  /// 2. TokenStorageService と同期
  /// 3. API呼び出しでユーザー状態を確認
  Future<UserStatusResponse?> tryAutoLogin() async {
    try {
      AppLogger.auth('Attempting auto login');

      // 1. CredentialsManager から有効なトークンを取得
      // auth0_flutter は期限切れの場合、自動的にリフレッシュトークンで更新を試みる
      final storedCredentials = await _auth0Service.getStoredCredentials();

      if (storedCredentials == null) {
        AppLogger.auth('No valid credentials in CredentialsManager');
        // TokenStorageService も念のためクリア（不整合防止）
        await _tokenStorage.deleteTokens();
        return null;
      }

      // 2. TokenStorageService と同期（APIリクエストで使用するため）
      await _tokenStorage.saveTokens(storedCredentials);
      AppLogger.auth('Credentials synced to TokenStorage');

      // 3. ユーザー登録状況を確認
      try {
        final status = await checkUserStatus();
        AppLogger.auth('Auto login successful', detail: 'registered: ${status.registered}');
        return status;
      } on AppException catch (e) {
        // トークンが無効な場合（ApiException または AuthException）
        final isAuthError = (e is ApiException && e.statusCode == 401) ||
            (e is AuthException);
        if (isAuthError) {
          AppLogger.auth('Token is invalid, clearing all credentials');
          await _clearAllCredentials();
          return null;
        }
        rethrow;
      }
    } catch (e) {
      AppLogger.error('Auto login failed', tag: 'AuthRepository', error: e);
      // 予期しないエラーの場合もクレデンシャルをクリア
      await _clearAllCredentials();
      return null;
    }
  }

  /// すべてのクレデンシャルをクリア
  Future<void> _clearAllCredentials() async {
    await _tokenStorage.deleteTokens();
    await _auth0Service.clearCredentials();
  }

  // ==================== ユーザー登録 ====================

  /// ユーザー登録状況を確認
  /// GET /api/users/status
  Future<UserStatusResponse> checkUserStatus() async {
    try {
      AppLogger.debug('Checking user status', tag: 'AuthRepository');

      final response = await _apiClient.dio.get(ApiConstants.userStatus);

      final status = UserStatusResponse.fromJson(response.data);

      AppLogger.debug(
        'User status checked',
        tag: 'AuthRepository',
      );

      return status;
    } on DioException catch (e) {
      throw ApiClientService.handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check user status',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(originalError: e, stackTrace: stackTrace);
    }
  }

  /// ユーザーを新規登録
  /// POST /api/users/setup
  Future<UserModel> setupUser(UserSetupRequest request) async {
    try {
      AppLogger.debug('Setting up new user', tag: 'AuthRepository');

      final response = await _apiClient.dio.post(
        ApiConstants.userSetup,
        data: request.toJson(),
      );

      final user = UserModel.fromJson(response.data);

      AppLogger.debug(
        'User setup completed',
        tag: 'AuthRepository',
      );

      return user;
    } on DioException catch (e) {
      throw ApiClientService.handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to setup user',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(originalError: e, stackTrace: stackTrace);
    }
  }

  /// ユーザー名の重複チェック
  /// GET /api/users/check-username?username=xxx
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      AppLogger.debug('Checking username availability', tag: 'AuthRepository');

      final response = await _apiClient.dio.get(
        ApiConstants.checkUsername(username),
      );

      final availability = UsernameAvailabilityResponse.fromJson(response.data);

      AppLogger.debug(
        'Username availability checked',
        tag: 'AuthRepository',
      );

      return availability.available;
    } on DioException catch (e) {
      throw ApiClientService.handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check username availability',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(originalError: e, stackTrace: stackTrace);
    }
  }

  // ==================== トークン管理 ====================

  /// 現在のトークンを取得
  Future<AuthTokens?> getCurrentTokens() async {
    return await _tokenStorage.getTokens();
  }

  /// トークンをリフレッシュ
  Future<void> refreshTokens() async {
    try {
      AppLogger.auth('Refreshing tokens');

      final newTokens = await _auth0Service.refreshTokens();
      await _tokenStorage.saveTokens(newTokens);

      AppLogger.auth('Tokens refreshed');
    } catch (e) {
      AppLogger.error('Failed to refresh tokens', tag: 'AuthRepository', error: e);
      rethrow;
    }
  }
}
