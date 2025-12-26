// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadowing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// シャドーイングリポジトリのプロバイダー

@ProviderFor(shadowingRepository)
const shadowingRepositoryProvider = ShadowingRepositoryProvider._();

/// シャドーイングリポジトリのプロバイダー

final class ShadowingRepositoryProvider
    extends
        $FunctionalProvider<
          ShadowingRepository,
          ShadowingRepository,
          ShadowingRepository
        >
    with $Provider<ShadowingRepository> {
  /// シャドーイングリポジトリのプロバイダー
  const ShadowingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shadowingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shadowingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShadowingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShadowingRepository create(Ref ref) {
    return shadowingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShadowingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShadowingRepository>(value),
    );
  }
}

String _$shadowingRepositoryHash() =>
    r'747f802f7878135a68f656d5919b0b09fcb28922';

/// レベル別コンテンツ一覧のプロバイダー

@ProviderFor(shadowingContents)
const shadowingContentsProvider = ShadowingContentsFamily._();

/// レベル別コンテンツ一覧のプロバイダー

final class ShadowingContentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShadowingContent>>,
          List<ShadowingContent>,
          FutureOr<List<ShadowingContent>>
        >
    with
        $FutureModifier<List<ShadowingContent>>,
        $FutureProvider<List<ShadowingContent>> {
  /// レベル別コンテンツ一覧のプロバイダー
  const ShadowingContentsProvider._({
    required ShadowingContentsFamily super.from,
    required ShadowingLevel super.argument,
  }) : super(
         retry: null,
         name: r'shadowingContentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shadowingContentsHash();

  @override
  String toString() {
    return r'shadowingContentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ShadowingContent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShadowingContent>> create(Ref ref) {
    final argument = this.argument as ShadowingLevel;
    return shadowingContents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShadowingContentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shadowingContentsHash() => r'a3914655f92b51d346dc94ce4c53acd2f517e535';

/// レベル別コンテンツ一覧のプロバイダー

final class ShadowingContentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ShadowingContent>>,
          ShadowingLevel
        > {
  const ShadowingContentsFamily._()
    : super(
        retry: null,
        name: r'shadowingContentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// レベル別コンテンツ一覧のプロバイダー

  ShadowingContentsProvider call(ShadowingLevel level) =>
      ShadowingContentsProvider._(argument: level, from: this);

  @override
  String toString() => r'shadowingContentsProvider';
}

/// 全進捗データのプロバイダー

@ProviderFor(shadowingAllProgress)
const shadowingAllProgressProvider = ShadowingAllProgressProvider._();

/// 全進捗データのプロバイダー

final class ShadowingAllProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ShadowingProgress>>,
          Map<String, ShadowingProgress>,
          FutureOr<Map<String, ShadowingProgress>>
        >
    with
        $FutureModifier<Map<String, ShadowingProgress>>,
        $FutureProvider<Map<String, ShadowingProgress>> {
  /// 全進捗データのプロバイダー
  const ShadowingAllProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shadowingAllProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shadowingAllProgressHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, ShadowingProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ShadowingProgress>> create(Ref ref) {
    return shadowingAllProgress(ref);
  }
}

String _$shadowingAllProgressHash() =>
    r'e255e7bbe0cbb07cfc1cc6a6df38292a16bc1c52';

/// レベル別統計のプロバイダー

@ProviderFor(shadowingLevelStats)
const shadowingLevelStatsProvider = ShadowingLevelStatsFamily._();

/// レベル別統計のプロバイダー

final class ShadowingLevelStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShadowingLevelStats>,
          ShadowingLevelStats,
          FutureOr<ShadowingLevelStats>
        >
    with
        $FutureModifier<ShadowingLevelStats>,
        $FutureProvider<ShadowingLevelStats> {
  /// レベル別統計のプロバイダー
  const ShadowingLevelStatsProvider._({
    required ShadowingLevelStatsFamily super.from,
    required ShadowingLevel super.argument,
  }) : super(
         retry: null,
         name: r'shadowingLevelStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shadowingLevelStatsHash();

  @override
  String toString() {
    return r'shadowingLevelStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShadowingLevelStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShadowingLevelStats> create(Ref ref) {
    final argument = this.argument as ShadowingLevel;
    return shadowingLevelStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShadowingLevelStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shadowingLevelStatsHash() =>
    r'2be23661af2faa1d4e336f5333c1826a9ea93018';

/// レベル別統計のプロバイダー

final class ShadowingLevelStatsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ShadowingLevelStats>,
          ShadowingLevel
        > {
  const ShadowingLevelStatsFamily._()
    : super(
        retry: null,
        name: r'shadowingLevelStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// レベル別統計のプロバイダー

  ShadowingLevelStatsProvider call(ShadowingLevel level) =>
      ShadowingLevelStatsProvider._(argument: level, from: this);

  @override
  String toString() => r'shadowingLevelStatsProvider';
}

/// 全レベルの統計を取得するプロバイダー

@ProviderFor(shadowingAllLevelStats)
const shadowingAllLevelStatsProvider = ShadowingAllLevelStatsProvider._();

/// 全レベルの統計を取得するプロバイダー

final class ShadowingAllLevelStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShadowingLevelStats>>,
          List<ShadowingLevelStats>,
          FutureOr<List<ShadowingLevelStats>>
        >
    with
        $FutureModifier<List<ShadowingLevelStats>>,
        $FutureProvider<List<ShadowingLevelStats>> {
  /// 全レベルの統計を取得するプロバイダー
  const ShadowingAllLevelStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shadowingAllLevelStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shadowingAllLevelStatsHash();

  @$internal
  @override
  $FutureProviderElement<List<ShadowingLevelStats>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShadowingLevelStats>> create(Ref ref) {
    return shadowingAllLevelStats(ref);
  }
}

String _$shadowingAllLevelStatsHash() =>
    r'6454fc925227ed37528ac93465f590112efc079d';

/// 特定コンテンツの進捗を取得するプロバイダー

@ProviderFor(shadowingProgress)
const shadowingProgressProvider = ShadowingProgressFamily._();

/// 特定コンテンツの進捗を取得するプロバイダー

final class ShadowingProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShadowingProgress?>,
          ShadowingProgress?,
          FutureOr<ShadowingProgress?>
        >
    with
        $FutureModifier<ShadowingProgress?>,
        $FutureProvider<ShadowingProgress?> {
  /// 特定コンテンツの進捗を取得するプロバイダー
  const ShadowingProgressProvider._({
    required ShadowingProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shadowingProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shadowingProgressHash();

  @override
  String toString() {
    return r'shadowingProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShadowingProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShadowingProgress?> create(Ref ref) {
    final argument = this.argument as String;
    return shadowingProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShadowingProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shadowingProgressHash() => r'18d789b9b2b8104489722fc0661a238bf6d541e4';

/// 特定コンテンツの進捗を取得するプロバイダー

final class ShadowingProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShadowingProgress?>, String> {
  const ShadowingProgressFamily._()
    : super(
        retry: null,
        name: r'shadowingProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 特定コンテンツの進捗を取得するプロバイダー

  ShadowingProgressProvider call(String contentId) =>
      ShadowingProgressProvider._(argument: contentId, from: this);

  @override
  String toString() => r'shadowingProgressProvider';
}
