// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'original_content_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// オリジナル文章セッションプロバイダー

@ProviderFor(OriginalContentSession)
const originalContentSessionProvider = OriginalContentSessionFamily._();

/// オリジナル文章セッションプロバイダー
final class OriginalContentSessionProvider
    extends
        $AsyncNotifierProvider<
          OriginalContentSession,
          OriginalContentSessionState
        > {
  /// オリジナル文章セッションプロバイダー
  const OriginalContentSessionProvider._({
    required OriginalContentSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'originalContentSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$originalContentSessionHash();

  @override
  String toString() {
    return r'originalContentSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OriginalContentSession create() => OriginalContentSession();

  @override
  bool operator ==(Object other) {
    return other is OriginalContentSessionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$originalContentSessionHash() =>
    r'5884ec9ac6e1888d3817759e0c92f419492ca044';

/// オリジナル文章セッションプロバイダー

final class OriginalContentSessionFamily extends $Family
    with
        $ClassFamilyOverride<
          OriginalContentSession,
          AsyncValue<OriginalContentSessionState>,
          OriginalContentSessionState,
          FutureOr<OriginalContentSessionState>,
          String
        > {
  const OriginalContentSessionFamily._()
    : super(
        retry: null,
        name: r'originalContentSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// オリジナル文章セッションプロバイダー

  OriginalContentSessionProvider call(String contentId) =>
      OriginalContentSessionProvider._(argument: contentId, from: this);

  @override
  String toString() => r'originalContentSessionProvider';
}

/// オリジナル文章セッションプロバイダー

abstract class _$OriginalContentSession
    extends $AsyncNotifier<OriginalContentSessionState> {
  late final _$args = ref.$arg as String;
  String get contentId => _$args;

  FutureOr<OriginalContentSessionState> build(String contentId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<OriginalContentSessionState>,
              OriginalContentSessionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<OriginalContentSessionState>,
                OriginalContentSessionState
              >,
              AsyncValue<OriginalContentSessionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
