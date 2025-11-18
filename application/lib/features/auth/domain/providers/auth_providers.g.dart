// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth0Service のプロバイダー

@ProviderFor(auth0Service)
const auth0ServiceProvider = Auth0ServiceProvider._();

/// Auth0Service のプロバイダー

final class Auth0ServiceProvider
    extends $FunctionalProvider<Auth0Service, Auth0Service, Auth0Service>
    with $Provider<Auth0Service> {
  /// Auth0Service のプロバイダー
  const Auth0ServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auth0ServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auth0ServiceHash();

  @$internal
  @override
  $ProviderElement<Auth0Service> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Auth0Service create(Ref ref) {
    return auth0Service(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Auth0Service value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Auth0Service>(value),
    );
  }
}

String _$auth0ServiceHash() => r'87e49d8ca340b79d4c7762e3c26511f26787cf07';

/// TokenStorageService のプロバイダー

@ProviderFor(tokenStorageService)
const tokenStorageServiceProvider = TokenStorageServiceProvider._();

/// TokenStorageService のプロバイダー

final class TokenStorageServiceProvider
    extends
        $FunctionalProvider<
          TokenStorageService,
          TokenStorageService,
          TokenStorageService
        >
    with $Provider<TokenStorageService> {
  /// TokenStorageService のプロバイダー
  const TokenStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageServiceHash();

  @$internal
  @override
  $ProviderElement<TokenStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TokenStorageService create(Ref ref) {
    return tokenStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorageService>(value),
    );
  }
}

String _$tokenStorageServiceHash() =>
    r'c7bb122057a9ce5622cd69cdb6c76f5eb37ac7f0';

/// ApiClientService のプロバイダー

@ProviderFor(apiClientService)
const apiClientServiceProvider = ApiClientServiceProvider._();

/// ApiClientService のプロバイダー

final class ApiClientServiceProvider
    extends
        $FunctionalProvider<
          ApiClientService,
          ApiClientService,
          ApiClientService
        >
    with $Provider<ApiClientService> {
  /// ApiClientService のプロバイダー
  const ApiClientServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientServiceHash();

  @$internal
  @override
  $ProviderElement<ApiClientService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClientService create(Ref ref) {
    return apiClientService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClientService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClientService>(value),
    );
  }
}

String _$apiClientServiceHash() => r'de6d580c2672794abed837e440fb14ca05eaf43c';

/// AuthRepository のプロバイダー

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// AuthRepository のプロバイダー

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// AuthRepository のプロバイダー
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'9b21a2f7ebae3fa64431674b6447dfd9d3a4efd6';

/// 認証状態を管理する Notifier

@ProviderFor(AuthStateNotifier)
const authStateProvider = AuthStateNotifierProvider._();

/// 認証状態を管理する Notifier
final class AuthStateNotifierProvider
    extends $NotifierProvider<AuthStateNotifier, AuthStateData> {
  /// 認証状態を管理する Notifier
  const AuthStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateNotifierHash();

  @$internal
  @override
  AuthStateNotifier create() => AuthStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStateData>(value),
    );
  }
}

String _$authStateNotifierHash() => r'4595edb37678d239618fbe8a9575ab73a0f20f2b';

/// 認証状態を管理する Notifier

abstract class _$AuthStateNotifier extends $Notifier<AuthStateData> {
  AuthStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthStateData, AuthStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthStateData, AuthStateData>,
              AuthStateData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 現在のユーザー情報を取得するプロバイダー

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// 現在のユーザー情報を取得するプロバイダー

final class CurrentUserProvider
    extends $FunctionalProvider<UserModel?, UserModel?, UserModel?>
    with $Provider<UserModel?> {
  /// 現在のユーザー情報を取得するプロバイダー
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserModel? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserModel?>(value),
    );
  }
}

String _$currentUserHash() => r'6ab1a8cd40b958db647a34e7939f21cfd4673c97';

/// 認証済みかどうかを取得するプロバイダー

@ProviderFor(isAuthenticated)
const isAuthenticatedProvider = IsAuthenticatedProvider._();

/// 認証済みかどうかを取得するプロバイダー

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 認証済みかどうかを取得するプロバイダー
  const IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'c57c3e9e16de5031545a72fce38e85c4038c538e';

/// ユーザー名重複チェック用プロバイダー

@ProviderFor(usernameAvailability)
const usernameAvailabilityProvider = UsernameAvailabilityFamily._();

/// ユーザー名重複チェック用プロバイダー

final class UsernameAvailabilityProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// ユーザー名重複チェック用プロバイダー
  const UsernameAvailabilityProvider._({
    required UsernameAvailabilityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'usernameAvailabilityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usernameAvailabilityHash();

  @override
  String toString() {
    return r'usernameAvailabilityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return usernameAvailability(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UsernameAvailabilityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usernameAvailabilityHash() =>
    r'68438ae900fc76b516ad95befd61472e300b1883';

/// ユーザー名重複チェック用プロバイダー

final class UsernameAvailabilityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const UsernameAvailabilityFamily._()
    : super(
        retry: null,
        name: r'usernameAvailabilityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ユーザー名重複チェック用プロバイダー

  UsernameAvailabilityProvider call(String username) =>
      UsernameAvailabilityProvider._(argument: username, from: this);

  @override
  String toString() => r'usernameAvailabilityProvider';
}
