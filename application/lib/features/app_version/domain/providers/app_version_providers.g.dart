// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AppVersionRepository のプロバイダー

@ProviderFor(appVersionRepository)
const appVersionRepositoryProvider = AppVersionRepositoryProvider._();

/// AppVersionRepository のプロバイダー

final class AppVersionRepositoryProvider
    extends
        $FunctionalProvider<
          AppVersionRepository,
          AppVersionRepository,
          AppVersionRepository
        >
    with $Provider<AppVersionRepository> {
  /// AppVersionRepository のプロバイダー
  const AppVersionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppVersionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppVersionRepository create(Ref ref) {
    return appVersionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppVersionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppVersionRepository>(value),
    );
  }
}

String _$appVersionRepositoryHash() =>
    r'8750db062ddce9c0975c44dd8f8106a02584b1d1';

/// バージョンチェック状態を管理するNotifier

@ProviderFor(VersionCheckNotifier)
const versionCheckProvider = VersionCheckNotifierProvider._();

/// バージョンチェック状態を管理するNotifier
final class VersionCheckNotifierProvider
    extends $NotifierProvider<VersionCheckNotifier, VersionCheckState> {
  /// バージョンチェック状態を管理するNotifier
  const VersionCheckNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'versionCheckProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$versionCheckNotifierHash();

  @$internal
  @override
  VersionCheckNotifier create() => VersionCheckNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VersionCheckState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VersionCheckState>(value),
    );
  }
}

String _$versionCheckNotifierHash() =>
    r'1b7a37edec6c78c172f4fd5dc56a40a25eba2026';

/// バージョンチェック状態を管理するNotifier

abstract class _$VersionCheckNotifier extends $Notifier<VersionCheckState> {
  VersionCheckState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VersionCheckState, VersionCheckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VersionCheckState, VersionCheckState>,
              VersionCheckState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 強制アップデートが必要かどうか

@ProviderFor(needsForceUpdate)
const needsForceUpdateProvider = NeedsForceUpdateProvider._();

/// 強制アップデートが必要かどうか

final class NeedsForceUpdateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 強制アップデートが必要かどうか
  const NeedsForceUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsForceUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsForceUpdateHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return needsForceUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$needsForceUpdateHash() => r'f538791cf119d9e83a4216fa1a9dc7088e3a54bd';

/// ストアURLを取得

@ProviderFor(updateStoreUrl)
const updateStoreUrlProvider = UpdateStoreUrlProvider._();

/// ストアURLを取得

final class UpdateStoreUrlProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// ストアURLを取得
  const UpdateStoreUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStoreUrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStoreUrlHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return updateStoreUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$updateStoreUrlHash() => r'81da9f05d4987cc3788560a1a99febd6d52324db';
