// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PronunciationGameRepository プロバイダー

@ProviderFor(pronunciationGameRepository)
const pronunciationGameRepositoryProvider =
    PronunciationGameRepositoryProvider._();

/// PronunciationGameRepository プロバイダー

final class PronunciationGameRepositoryProvider
    extends
        $FunctionalProvider<
          PronunciationGameRepository,
          PronunciationGameRepository,
          PronunciationGameRepository
        >
    with $Provider<PronunciationGameRepository> {
  /// PronunciationGameRepository プロバイダー
  const PronunciationGameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pronunciationGameRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pronunciationGameRepositoryHash();

  @$internal
  @override
  $ProviderElement<PronunciationGameRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PronunciationGameRepository create(Ref ref) {
    return pronunciationGameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PronunciationGameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PronunciationGameRepository>(value),
    );
  }
}

String _$pronunciationGameRepositoryHash() =>
    r'b60a8a1021a8918ae530ccbe965df1f1c8ead4fb';

/// ゲーム結果送信プロバイダー

@ProviderFor(PronunciationGameResultSubmitter)
const pronunciationGameResultSubmitterProvider =
    PronunciationGameResultSubmitterProvider._();

/// ゲーム結果送信プロバイダー
final class PronunciationGameResultSubmitterProvider
    extends
        $NotifierProvider<
          PronunciationGameResultSubmitter,
          AsyncValue<PronunciationGameResultResponse?>
        > {
  /// ゲーム結果送信プロバイダー
  const PronunciationGameResultSubmitterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pronunciationGameResultSubmitterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pronunciationGameResultSubmitterHash();

  @$internal
  @override
  PronunciationGameResultSubmitter create() =>
      PronunciationGameResultSubmitter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    AsyncValue<PronunciationGameResultResponse?> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<PronunciationGameResultResponse?>>(
            value,
          ),
    );
  }
}

String _$pronunciationGameResultSubmitterHash() =>
    r'3ee32cf62ca90fe9d4f1c845d6eff0ae6a021894';

/// ゲーム結果送信プロバイダー

abstract class _$PronunciationGameResultSubmitter
    extends $Notifier<AsyncValue<PronunciationGameResultResponse?>> {
  AsyncValue<PronunciationGameResultResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PronunciationGameResultResponse?>,
              AsyncValue<PronunciationGameResultResponse?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PronunciationGameResultResponse?>,
                AsyncValue<PronunciationGameResultResponse?>
              >,
              AsyncValue<PronunciationGameResultResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
