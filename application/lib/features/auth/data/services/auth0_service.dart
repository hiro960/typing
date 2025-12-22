import 'dart:io' show Platform;

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/auth_tokens.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/exceptions/app_exception.dart';

/// Auth0認証を管理するサービス
class Auth0Service {
  late final Auth0 _auth0;
  late final CredentialsManager _credentialsManager;

  Auth0Service() {
    _initialize();
  }

  void _initialize() {
    try {
      _auth0 = Auth0(
        EnvConfig.auth0Domain,
        EnvConfig.auth0ClientId,
      );
      _credentialsManager = _auth0.credentialsManager;

      AppLogger.auth('Auth0 initialized', detail: EnvConfig.auth0Domain);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize Auth0',
        tag: 'Auth0Service',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// ログイン (Universal Login)
  /// Authorization Code + PKCE フローを使用
  Future<AuthTokens> login() async {
    try {

      // Use HTTPS callback URL on iOS 17.4+ / macOS 14.4+
      // For Android, use custom scheme
      // Note: HTTPS callback requires Associated Domains which only works on:
      //   - Physical devices with Release builds (TestFlight/App Store)
      //   - Does NOT work on simulators or Debug builds
      final webAuth = _auth0.webAuthentication();
      final useHttps = !kIsWeb &&
          (Platform.isIOS || Platform.isMacOS) &&
          !EnvConfig.isDevelopment; // 開発環境ではカスタムスキームを使用

      final redirectUrl = Platform.isAndroid
          ? 'app.koreantyping.chaletta://${EnvConfig.auth0Domain}/android/app.koreantyping.chaletta/callback'
          : null;
      

      final credentials = await webAuth.login(
        useHTTPS: useHttps, // iOS/macOS用のUniversal Link（Androidはカスタムスキーム）
        redirectUrl: redirectUrl,
        audience: EnvConfig.auth0Audience.isNotEmpty ? EnvConfig.auth0Audience : null,
        scopes: {
          'openid',
          'profile',
          'email',
          'offline_access', // リフレッシュトークン取得用
        },
        parameters: {
          'ui_locales': 'ja', // OpenID Connect仕様: 日本語UIを要求
        },
      );

      return AuthTokens(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        idToken: credentials.idToken,
        expiresIn: credentials.expiresAt.difference(DateTime.now()).inSeconds,
        tokenType: credentials.tokenType,
      );
    } on WebAuthenticationException catch (e) {
      AppLogger.error(
        'Auth0 login failed',
        tag: 'Auth0Service',
        error: e,
      );

      // ユーザーがキャンセルした場合
      if (e.code == 'a0.authentication_canceled' ||
          e.message.contains('User cancelled')) {
        throw AuthException.loginCancelled();
      }

      throw AuthException.loginFailed(e.message);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during login',
        tag: 'Auth0Service',
        error: e,
        stackTrace: stackTrace,
      );
      throw AuthException.loginFailed('予期しないエラーが発生しました');
    }
  }

  /// ログアウト
  /// Auth0のWebセッションを終了し、次回ログイン時にソーシャルメディア選択を表示
  Future<void> logout() async {
    try {
      AppLogger.auth('Starting Auth0 logout');

      final webAuth = _auth0.webAuthentication();
      final useHttps = !kIsWeb &&
          (Platform.isIOS || Platform.isMacOS) &&
          !EnvConfig.isDevelopment;

      final redirectUrl = Platform.isAndroid
          ? 'app.koreantyping.chaletta://${EnvConfig.auth0Domain}/android/app.koreantyping.chaletta/callback'
          : null;

      await webAuth.logout(
        useHTTPS: useHttps,
        returnTo: redirectUrl,
      );

      AppLogger.auth('Auth0 logout completed');
    } on WebAuthenticationException catch (e) {
      AppLogger.error(
        'Auth0 logout failed',
        tag: 'Auth0Service',
        error: e,
      );
      // ログアウトは失敗しても続行
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during logout',
        tag: 'Auth0Service',
        error: e,
        stackTrace: stackTrace,
      );
      // ログアウトは失敗しても続行
    }
  }

  /// トークンのリフレッシュ
  /// リフレッシュトークンを使用して新しいアクセストークンを取得
  Future<AuthTokens> refreshTokens() async {
    try {

      final credentials = await _credentialsManager.credentials();

      return AuthTokens(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        idToken: credentials.idToken,
        expiresIn: credentials.expiresAt.difference(DateTime.now()).inSeconds,
        tokenType: credentials.tokenType,
      );
    } on CredentialsManagerException catch (e) {
      AppLogger.error(
        'Failed to refresh tokens',
        tag: 'Auth0Service',
        error: e,
      );

      // リフレッシュトークンも期限切れの場合
      if (e.code == 'INVALID_REFRESH_TOKEN' ||
          e.message.contains('expired')) {
        throw AuthException.tokenExpired();
      }

      throw AuthException.invalidToken(e.message);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error during token refresh',
        tag: 'Auth0Service',
        error: e,
        stackTrace: stackTrace,
      );
      throw AuthException.invalidToken('トークンの更新に失敗しました');
    }
  }

  /// 保存されているクレデンシャルを取得
  ///
  /// auth0_flutter の CredentialsManager.credentials() は、
  /// トークンが期限切れの場合、自動的にリフレッシュトークンを使って更新を試みます。
  /// これにより、IDトークンが期限切れでもリフレッシュトークンが有効なら
  /// 新しいトークンを取得できます。
  Future<AuthTokens?> getStoredCredentials() async {
    try {
      AppLogger.auth('Getting stored credentials from Auth0');

      // credentials() を直接呼び出す
      // auth0_flutter は期限切れの場合、自動的にリフレッシュを試みる
      final credentials = await _credentialsManager.credentials();

      AppLogger.auth('Retrieved stored credentials (refreshed if needed)');

      return AuthTokens(
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        idToken: credentials.idToken,
        expiresIn: credentials.expiresAt.difference(DateTime.now()).inSeconds,
        tokenType: credentials.tokenType,
      );
    } on CredentialsManagerException catch (e) {
      // リフレッシュトークンも無効、またはトークンが保存されていない場合
      AppLogger.auth(
        'No valid credentials available',
        detail: 'code: ${e.code}, message: ${e.message}',
      );
      return null;
    } catch (e) {
      AppLogger.error(
        'Failed to get stored credentials',
        tag: 'Auth0Service',
        error: e,
      );
      return null;
    }
  }

  /// 保存されているクレデンシャルをクリア
  Future<void> clearCredentials() async {
    try {
      AppLogger.auth('Clearing Auth0 credentials');
      await _credentialsManager.clearCredentials();
      AppLogger.auth('Credentials cleared');
    } catch (e) {
      AppLogger.error(
        'Failed to clear credentials',
        tag: 'Auth0Service',
        error: e,
      );
      // クリアは失敗しても続行
    }
  }
}
