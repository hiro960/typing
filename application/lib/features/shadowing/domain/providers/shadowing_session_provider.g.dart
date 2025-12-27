// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadowing_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// シャドーイングセッションプロバイダー

@ProviderFor(ShadowingSession)
const shadowingSessionProvider = ShadowingSessionFamily._();

/// シャドーイングセッションプロバイダー
final class ShadowingSessionProvider
    extends $AsyncNotifierProvider<ShadowingSession, ShadowingSessionState> {
  /// シャドーイングセッションプロバイダー
  const ShadowingSessionProvider._({
    required ShadowingSessionFamily super.from,
    required (String, ShadowingLevel) super.argument,
  }) : super(
         retry: null,
         name: r'shadowingSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shadowingSessionHash();

  @override
  String toString() {
    return r'shadowingSessionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ShadowingSession create() => ShadowingSession();

  @override
  bool operator ==(Object other) {
    return other is ShadowingSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shadowingSessionHash() => r'319e236be21caea4fa7b17d4555e2270d03128c1';

/// シャドーイングセッションプロバイダー

final class ShadowingSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          ShadowingSession,
          AsyncValue<ShadowingSessionState>,
          ShadowingSessionState,
          FutureOr<ShadowingSessionState>,
          (String, ShadowingLevel)
        > {
  const ShadowingSessionFamily._()
    : super(
        retry: null,
        name: r'shadowingSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// シャドーイングセッションプロバイダー

  ShadowingSessionProvider call(String contentId, ShadowingLevel level) =>
      ShadowingSessionProvider._(argument: (contentId, level), from: this);

  @override
  String toString() => r'shadowingSessionProvider';
}

/// シャドーイングセッションプロバイダー

abstract class _$ShadowingSession
    extends $AsyncNotifier<ShadowingSessionState> {
  late final _$args = ref.$arg as (String, ShadowingLevel);
  String get contentId => _$args.$1;
  ShadowingLevel get level => _$args.$2;

  FutureOr<ShadowingSessionState> build(String contentId, ShadowingLevel level);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref
            as $Ref<AsyncValue<ShadowingSessionState>, ShadowingSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ShadowingSessionState>,
                ShadowingSessionState
              >,
              AsyncValue<ShadowingSessionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
