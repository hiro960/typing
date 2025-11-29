// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// RankingGameRepository プロバイダー

@ProviderFor(rankingGameRepository)
const rankingGameRepositoryProvider = RankingGameRepositoryProvider._();

/// RankingGameRepository プロバイダー

final class RankingGameRepositoryProvider
    extends
        $FunctionalProvider<
          RankingGameRepository,
          RankingGameRepository,
          RankingGameRepository
        >
    with $Provider<RankingGameRepository> {
  /// RankingGameRepository プロバイダー
  const RankingGameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankingGameRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankingGameRepositoryHash();

  @$internal
  @override
  $ProviderElement<RankingGameRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RankingGameRepository create(Ref ref) {
    return rankingGameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankingGameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankingGameRepository>(value),
    );
  }
}

String _$rankingGameRepositoryHash() =>
    r'a72f9923246ee30a4c442454ea8d498399b60a0b';

/// WordLoaderService プロバイダー

@ProviderFor(wordLoaderService)
const wordLoaderServiceProvider = WordLoaderServiceProvider._();

/// WordLoaderService プロバイダー

final class WordLoaderServiceProvider
    extends
        $FunctionalProvider<
          WordLoaderService,
          WordLoaderService,
          WordLoaderService
        >
    with $Provider<WordLoaderService> {
  /// WordLoaderService プロバイダー
  const WordLoaderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordLoaderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordLoaderServiceHash();

  @$internal
  @override
  $ProviderElement<WordLoaderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WordLoaderService create(Ref ref) {
    return wordLoaderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WordLoaderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WordLoaderService>(value),
    );
  }
}

String _$wordLoaderServiceHash() => r'c31b61f14df53c8bbb9af7e6b406d571f50bc9d7';

/// OfflineQueueService プロバイダー

@ProviderFor(offlineQueueService)
const offlineQueueServiceProvider = OfflineQueueServiceProvider._();

/// OfflineQueueService プロバイダー

final class OfflineQueueServiceProvider
    extends
        $FunctionalProvider<
          OfflineQueueService,
          OfflineQueueService,
          OfflineQueueService
        >
    with $Provider<OfflineQueueService> {
  /// OfflineQueueService プロバイダー
  const OfflineQueueServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineQueueServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineQueueServiceHash();

  @$internal
  @override
  $ProviderElement<OfflineQueueService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OfflineQueueService create(Ref ref) {
    return offlineQueueService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineQueueService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineQueueService>(value),
    );
  }
}

String _$offlineQueueServiceHash() =>
    r'a5517717abfcb108216da424ae6ba22c791e506a';

/// ゲーム結果送信プロバイダー（オフライン対応）

@ProviderFor(GameResultSubmitter)
const gameResultSubmitterProvider = GameResultSubmitterProvider._();

/// ゲーム結果送信プロバイダー（オフライン対応）
final class GameResultSubmitterProvider
    extends
        $NotifierProvider<
          GameResultSubmitter,
          AsyncValue<RankingGameResultResponse?>
        > {
  /// ゲーム結果送信プロバイダー（オフライン対応）
  const GameResultSubmitterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameResultSubmitterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameResultSubmitterHash();

  @$internal
  @override
  GameResultSubmitter create() => GameResultSubmitter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RankingGameResultResponse?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<RankingGameResultResponse?>>(value),
    );
  }
}

String _$gameResultSubmitterHash() =>
    r'0dec0d50cd4b5b5514e46eee0794355006514ee6';

/// ゲーム結果送信プロバイダー（オフライン対応）

abstract class _$GameResultSubmitter
    extends $Notifier<AsyncValue<RankingGameResultResponse?>> {
  AsyncValue<RankingGameResultResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<RankingGameResultResponse?>,
              AsyncValue<RankingGameResultResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RankingGameResultResponse?>,
                AsyncValue<RankingGameResultResponse?>
              >,
              AsyncValue<RankingGameResultResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 保留中の結果数プロバイダー

@ProviderFor(pendingResultsCount)
const pendingResultsCountProvider = PendingResultsCountProvider._();

/// 保留中の結果数プロバイダー

final class PendingResultsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// 保留中の結果数プロバイダー
  const PendingResultsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingResultsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingResultsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingResultsCount(ref);
  }
}

String _$pendingResultsCountHash() =>
    r'727d3105970f5a23ddf49081ff26654a44487cb7';
