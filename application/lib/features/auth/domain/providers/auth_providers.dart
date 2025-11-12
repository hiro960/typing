import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth0_service.dart';
import '../../data/services/token_storage_service.dart';
import '../../data/services/api_client_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_status_response.dart';
import '../../../../core/utils/logger.dart';

part 'auth_providers.g.dart';

// ==================== Service Providers ====================

/// Auth0Service のプロバイダー
@riverpod
Auth0Service auth0Service(Ref ref) {
  return Auth0Service();
}

/// TokenStorageService のプロバイダー
@riverpod
TokenStorageService tokenStorageService(Ref ref) {
  return TokenStorageService();
}

/// ApiClientService のプロバイダー
@riverpod
ApiClientService apiClientService(Ref ref) {
  return ApiClientService(
    tokenStorage: ref.watch(tokenStorageServiceProvider),
    auth0Service: ref.watch(auth0ServiceProvider),
  );
}

/// AuthRepository のプロバイダー
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    auth0Service: ref.watch(auth0ServiceProvider),
    tokenStorage: ref.watch(tokenStorageServiceProvider),
    apiClient: ref.watch(apiClientServiceProvider),
  );
}

// ==================== Auth State ====================

/// 認証状態を表す列挙型
enum AuthStatus {
  /// 初期状態 (認証状態を確認中)
  initial,

  /// 未認証 (ログインしていない)
  unauthenticated,

  /// 認証済みだが未登録 (プロフィール入力が必要)
  authenticatedButNotRegistered,

  /// 認証済みかつ登録済み (ホーム画面へ)
  authenticated,

  /// エラー状態
  error,
}

/// 認証状態を管理するクラス
class AuthStateData {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthStateData({
    required this.status,
    this.user,
    this.errorMessage,
  });

  /// 初期状態
  const AuthStateData.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  /// 未認証状態
  const AuthStateData.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null;

  /// 認証済みだが未登録状態
  const AuthStateData.authenticatedButNotRegistered()
      : status = AuthStatus.authenticatedButNotRegistered,
        user = null,
        errorMessage = null;

  /// 認証済み状態
  const AuthStateData.authenticated(this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  /// エラー状態
  const AuthStateData.error(this.errorMessage)
      : status = AuthStatus.error,
        user = null;

  AuthStateData copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AuthStateData(status: $status, user: ${user?.username ?? 'null'}, error: $errorMessage)';
  }
}

// ==================== Auth State Notifier ====================

/// 認証状態を管理する Notifier
@Riverpod(keepAlive: true)
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  AuthStateData build() {
    // 初期化時に自動ログインを試行
    _tryAutoLogin();
    return const AuthStateData.initial();
  }

  /// 自動ログインを試行
  Future<void> _tryAutoLogin() async {
    try {
      AppLogger.auth('Trying auto login...');

      final authRepository = ref.read(authRepositoryProvider);
      final status = await authRepository.tryAutoLogin();

      // プロバイダーがまだマウントされているか確認
      if (!ref.mounted) return;

      if (status == null) {
        // トークンがない or 無効
        AppLogger.auth('No valid tokens, setting state to unauthenticated');
        state = const AuthStateData.unauthenticated();
        return;
      }

      if (status.registered && status.user != null) {
        // 登録済みユーザー
        AppLogger.auth('User is registered, setting state to authenticated');
        state = AuthStateData.authenticated(status.user!);
      } else {
        // 未登録ユーザー
        AppLogger.auth('User is not registered, setting state to authenticatedButNotRegistered');
        state = const AuthStateData.authenticatedButNotRegistered();
      }
    } catch (e) {
      AppLogger.error('Auto login failed', tag: 'AuthStateNotifier', error: e);
      if (ref.mounted) {
        state = const AuthStateData.unauthenticated();
      }
    }
  }

  /// ログイン処理
  Future<void> login() async {
    try {
      AppLogger.auth('Starting login process...');

      final authRepository = ref.read(authRepositoryProvider);
      final status = await authRepository.login();

      // プロバイダーがまだマウントされているか確認
      if (!ref.mounted) return;

      if (status.registered && status.user != null) {
        // 登録済みユーザー
        AppLogger.auth('Login successful - user registered');
        state = AuthStateData.authenticated(status.user!);
      } else {
        // 未登録ユーザー (プロフィール入力へ)
        AppLogger.auth('Login successful - user not registered');
        state = const AuthStateData.authenticatedButNotRegistered();
      }
    } catch (e) {
      AppLogger.error('Login failed', tag: 'AuthStateNotifier', error: e);
      if (ref.mounted) {
        state = AuthStateData.error(e.toString());
      }
      rethrow;
    }
  }

  /// ユーザー登録処理
  Future<void> setupUser({
    required String username,
    required String displayName,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      AppLogger.auth('Starting user setup...');

      final request = UserSetupRequest(
        username: username,
        displayName: displayName,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );

      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.setupUser(request);

      // プロバイダーがまだマウントされているか確認
      if (!ref.mounted) return;

      AppLogger.auth('User setup successful');
      state = AuthStateData.authenticated(user);
    } catch (e) {
      AppLogger.error('User setup failed', tag: 'AuthStateNotifier', error: e);
      if (ref.mounted) {
        state = AuthStateData.error(e.toString());
      }
      rethrow;
    }
  }

  /// ログアウト処理
  Future<void> logout() async {
    try {
      AppLogger.auth('Starting logout process...');

      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();

      AppLogger.auth('Logout successful');
      state = const AuthStateData.unauthenticated();
    } catch (e) {
      AppLogger.error('Logout failed', tag: 'AuthStateNotifier', error: e);
      // ログアウトは失敗しても状態を未認証にする
      state = const AuthStateData.unauthenticated();
    }
  }

  /// ユーザー情報を更新
  void updateUser(UserModel user) {
    state = AuthStateData.authenticated(user);
  }

  /// エラーをクリア
  void clearError() {
    if (state.status == AuthStatus.error) {
      state = const AuthStateData.unauthenticated();
    }
  }
}

// ==================== Computed Providers ====================

/// 現在のユーザー情報を取得するプロバイダー
@riverpod
UserModel? currentUser(Ref ref) {
  return ref.watch(authStateProvider).user;
}

/// 認証済みかどうかを取得するプロバイダー
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(authStateProvider).status == AuthStatus.authenticated;
}

/// ユーザー名重複チェック用プロバイダー
@riverpod
Future<bool> usernameAvailability(
  Ref ref,
  String username,
) async {
  if (username.isEmpty) {
    return false;
  }

  final authRepo = ref.watch(authRepositoryProvider);
  return await authRepo.checkUsernameAvailability(username);
}
