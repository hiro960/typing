import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_tokens.dart';
import '../../../../core/utils/logger.dart';

/// トークンを安全に保存・取得するサービス
class TokenStorageService {
  final FlutterSecureStorage _storage;

  // ストレージキー
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyIdToken = 'auth_id_token';
  static const String _keyExpiresIn = 'auth_expires_in';
  static const String _keyTokenType = 'auth_token_type';

  TokenStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  /// トークンを保存
  Future<void> saveTokens(AuthTokens tokens) async {
    try {
      AppLogger.auth('Saving tokens to secure storage');

      await Future.wait([
        _storage.write(key: _keyAccessToken, value: tokens.accessToken),
        if (tokens.refreshToken != null)
          _storage.write(key: _keyRefreshToken, value: tokens.refreshToken),
        if (tokens.idToken != null)
          _storage.write(key: _keyIdToken, value: tokens.idToken),
        if (tokens.expiresIn != null)
          _storage.write(
              key: _keyExpiresIn, value: tokens.expiresIn.toString()),
        _storage.write(key: _keyTokenType, value: tokens.tokenType),
      ]);

      AppLogger.auth('Tokens saved successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save tokens',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// トークンを取得
  Future<AuthTokens?> getTokens() async {
    try {
      final accessToken = await _storage.read(key: _keyAccessToken);

      if (accessToken == null) {
        AppLogger.auth('No tokens found in storage');
        return null;
      }

      final refreshToken = await _storage.read(key: _keyRefreshToken);
      final idToken = await _storage.read(key: _keyIdToken);
      final expiresInStr = await _storage.read(key: _keyExpiresIn);
      final tokenType =
          await _storage.read(key: _keyTokenType) ?? 'Bearer';

      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idToken: idToken,
        expiresIn: expiresInStr != null ? int.tryParse(expiresInStr) : null,
        tokenType: tokenType,
      );

      AppLogger.auth('Tokens retrieved from storage');
      return tokens;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve tokens',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// アクセストークンのみを取得
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _keyAccessToken);
    } catch (e) {
      AppLogger.error('Failed to get access token', tag: 'TokenStorage', error: e);
      return null;
    }
  }

  /// リフレッシュトークンのみを取得
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      AppLogger.error('Failed to get refresh token', tag: 'TokenStorage', error: e);
      return null;
    }
  }

  /// トークンを削除 (ログアウト時)
  Future<void> deleteTokens() async {
    try {
      AppLogger.auth('Deleting tokens from storage');

      await Future.wait([
        _storage.delete(key: _keyAccessToken),
        _storage.delete(key: _keyRefreshToken),
        _storage.delete(key: _keyIdToken),
        _storage.delete(key: _keyExpiresIn),
        _storage.delete(key: _keyTokenType),
      ]);

      AppLogger.auth('Tokens deleted successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete tokens',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// トークンが存在するかチェック
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

  /// すべてのストレージをクリア (デバッグ用)
  Future<void> clearAll() async {
    try {
      AppLogger.warning('Clearing all secure storage');
      await _storage.deleteAll();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear storage',
        tag: 'TokenStorage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
