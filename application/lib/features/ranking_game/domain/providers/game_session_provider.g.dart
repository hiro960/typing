// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ゲームセッションプロバイダー

@ProviderFor(RankingGameSession)
const rankingGameSessionProvider = RankingGameSessionFamily._();

/// ゲームセッションプロバイダー
final class RankingGameSessionProvider
    extends $NotifierProvider<RankingGameSession, RankingGameSessionState> {
  /// ゲームセッションプロバイダー
  const RankingGameSessionProvider._({
    required RankingGameSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rankingGameSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rankingGameSessionHash();

  @override
  String toString() {
    return r'rankingGameSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RankingGameSession create() => RankingGameSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RankingGameSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RankingGameSessionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RankingGameSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rankingGameSessionHash() =>
    r'b2087e10d0af4983c4c7ce03e31f506362c472ff';

/// ゲームセッションプロバイダー

final class RankingGameSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          RankingGameSession,
          RankingGameSessionState,
          RankingGameSessionState,
          RankingGameSessionState,
          String
        > {
  const RankingGameSessionFamily._()
    : super(
        retry: null,
        name: r'rankingGameSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ゲームセッションプロバイダー

  RankingGameSessionProvider call(String difficulty) =>
      RankingGameSessionProvider._(argument: difficulty, from: this);

  @override
  String toString() => r'rankingGameSessionProvider';
}

/// ゲームセッションプロバイダー

abstract class _$RankingGameSession extends $Notifier<RankingGameSessionState> {
  late final _$args = ref.$arg as String;
  String get difficulty => _$args;

  RankingGameSessionState build(String difficulty);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<RankingGameSessionState, RankingGameSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RankingGameSessionState, RankingGameSessionState>,
              RankingGameSessionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
