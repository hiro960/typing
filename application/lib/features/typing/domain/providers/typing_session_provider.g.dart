// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TypingSession)
const typingSessionProvider = TypingSessionFamily._();

final class TypingSessionProvider
    extends $AsyncNotifierProvider<TypingSession, TypingSessionState> {
  const TypingSessionProvider._({
    required TypingSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'typingSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$typingSessionHash();

  @override
  String toString() {
    return r'typingSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TypingSession create() => TypingSession();

  @override
  bool operator ==(Object other) {
    return other is TypingSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$typingSessionHash() => r'19dbe23cf45abb69bd9a01a8d9a6d1ca59a83cfa';

final class TypingSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          TypingSession,
          AsyncValue<TypingSessionState>,
          TypingSessionState,
          FutureOr<TypingSessionState>,
          String
        > {
  const TypingSessionFamily._()
    : super(
        retry: null,
        name: r'typingSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TypingSessionProvider call(String lessonId) =>
      TypingSessionProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'typingSessionProvider';
}

abstract class _$TypingSession extends $AsyncNotifier<TypingSessionState> {
  late final _$args = ref.$arg as String;
  String get lessonId => _$args;

  FutureOr<TypingSessionState> build(String lessonId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<TypingSessionState>, TypingSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TypingSessionState>, TypingSessionState>,
              AsyncValue<TypingSessionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
