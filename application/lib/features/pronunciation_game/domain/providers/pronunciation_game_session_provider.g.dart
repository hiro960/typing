// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_game_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 発音ゲームセッションプロバイダー

@ProviderFor(PronunciationGameSession)
const pronunciationGameSessionProvider = PronunciationGameSessionFamily._();

/// 発音ゲームセッションプロバイダー
final class PronunciationGameSessionProvider
    extends
        $NotifierProvider<
          PronunciationGameSession,
          PronunciationGameSessionState
        > {
  /// 発音ゲームセッションプロバイダー
  const PronunciationGameSessionProvider._({
    required PronunciationGameSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pronunciationGameSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pronunciationGameSessionHash();

  @override
  String toString() {
    return r'pronunciationGameSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PronunciationGameSession create() => PronunciationGameSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PronunciationGameSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PronunciationGameSessionState>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PronunciationGameSessionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pronunciationGameSessionHash() =>
    r'7c9ab137514cd74ad38f8e0d2250b0dcb63900c3';

/// 発音ゲームセッションプロバイダー

final class PronunciationGameSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          PronunciationGameSession,
          PronunciationGameSessionState,
          PronunciationGameSessionState,
          PronunciationGameSessionState,
          String
        > {
  const PronunciationGameSessionFamily._()
    : super(
        retry: null,
        name: r'pronunciationGameSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 発音ゲームセッションプロバイダー

  PronunciationGameSessionProvider call(String difficulty) =>
      PronunciationGameSessionProvider._(argument: difficulty, from: this);

  @override
  String toString() => r'pronunciationGameSessionProvider';
}

/// 発音ゲームセッションプロバイダー

abstract class _$PronunciationGameSession
    extends $Notifier<PronunciationGameSessionState> {
  late final _$args = ref.$arg as String;
  String get difficulty => _$args;

  PronunciationGameSessionState build(String difficulty);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              PronunciationGameSessionState,
              PronunciationGameSessionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PronunciationGameSessionState,
                PronunciationGameSessionState
              >,
              PronunciationGameSessionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
