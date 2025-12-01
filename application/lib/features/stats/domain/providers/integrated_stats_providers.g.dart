// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integrated_stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// IntegratedStatsRepository プロバイダー

@ProviderFor(integratedStatsRepository)
const integratedStatsRepositoryProvider = IntegratedStatsRepositoryProvider._();

/// IntegratedStatsRepository プロバイダー

final class IntegratedStatsRepositoryProvider
    extends
        $FunctionalProvider<
          IntegratedStatsRepository,
          IntegratedStatsRepository,
          IntegratedStatsRepository
        >
    with $Provider<IntegratedStatsRepository> {
  /// IntegratedStatsRepository プロバイダー
  const IntegratedStatsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'integratedStatsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$integratedStatsRepositoryHash();

  @$internal
  @override
  $ProviderElement<IntegratedStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IntegratedStatsRepository create(Ref ref) {
    return integratedStatsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IntegratedStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IntegratedStatsRepository>(value),
    );
  }
}

String _$integratedStatsRepositoryHash() =>
    r'749ab1e1a1f510543e91233f40794ddba84b3fb4';

/// 統合統計プロバイダー（週次）

@ProviderFor(integratedStats)
const integratedStatsProvider = IntegratedStatsProvider._();

/// 統合統計プロバイダー（週次）

final class IntegratedStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<IntegratedStats>,
          IntegratedStats,
          FutureOr<IntegratedStats>
        >
    with $FutureModifier<IntegratedStats>, $FutureProvider<IntegratedStats> {
  /// 統合統計プロバイダー（週次）
  const IntegratedStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'integratedStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$integratedStatsHash();

  @$internal
  @override
  $FutureProviderElement<IntegratedStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IntegratedStats> create(Ref ref) {
    return integratedStats(ref);
  }
}

String _$integratedStatsHash() => r'5a2b0064ed00235ea62464743280e9045a35854d';

/// 統合統計プロバイダー（月次）

@ProviderFor(monthlyIntegratedStats)
const monthlyIntegratedStatsProvider = MonthlyIntegratedStatsProvider._();

/// 統合統計プロバイダー（月次）

final class MonthlyIntegratedStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<IntegratedStats>,
          IntegratedStats,
          FutureOr<IntegratedStats>
        >
    with $FutureModifier<IntegratedStats>, $FutureProvider<IntegratedStats> {
  /// 統合統計プロバイダー（月次）
  const MonthlyIntegratedStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyIntegratedStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyIntegratedStatsHash();

  @$internal
  @override
  $FutureProviderElement<IntegratedStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IntegratedStats> create(Ref ref) {
    return monthlyIntegratedStats(ref);
  }
}

String _$monthlyIntegratedStatsHash() =>
    r'ff17bfd0455b50fd738a3d5ea87182932816b3e2';

/// 統合統計プロバイダー（全期間）

@ProviderFor(allTimeIntegratedStats)
const allTimeIntegratedStatsProvider = AllTimeIntegratedStatsProvider._();

/// 統合統計プロバイダー（全期間）

final class AllTimeIntegratedStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<IntegratedStats>,
          IntegratedStats,
          FutureOr<IntegratedStats>
        >
    with $FutureModifier<IntegratedStats>, $FutureProvider<IntegratedStats> {
  /// 統合統計プロバイダー（全期間）
  const AllTimeIntegratedStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTimeIntegratedStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTimeIntegratedStatsHash();

  @$internal
  @override
  $FutureProviderElement<IntegratedStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IntegratedStats> create(Ref ref) {
    return allTimeIntegratedStats(ref);
  }
}

String _$allTimeIntegratedStatsHash() =>
    r'3739de69848b4ae1e3a0b7dc2be42e9a37740593';
