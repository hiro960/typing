// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'original_content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// オリジナル文章リポジトリのプロバイダー

@ProviderFor(originalContentRepository)
const originalContentRepositoryProvider = OriginalContentRepositoryProvider._();

/// オリジナル文章リポジトリのプロバイダー

final class OriginalContentRepositoryProvider
    extends
        $FunctionalProvider<
          OriginalContentRepository,
          OriginalContentRepository,
          OriginalContentRepository
        >
    with $Provider<OriginalContentRepository> {
  /// オリジナル文章リポジトリのプロバイダー
  const OriginalContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originalContentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originalContentRepositoryHash();

  @$internal
  @override
  $ProviderElement<OriginalContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OriginalContentRepository create(Ref ref) {
    return originalContentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OriginalContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OriginalContentRepository>(value),
    );
  }
}

String _$originalContentRepositoryHash() =>
    r'4470fe0b4f9284639a34e8f733cabc92b320fc7f';

/// オリジナル文章一覧のプロバイダー

@ProviderFor(originalContents)
const originalContentsProvider = OriginalContentsProvider._();

/// オリジナル文章一覧のプロバイダー

final class OriginalContentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OriginalContent>>,
          List<OriginalContent>,
          FutureOr<List<OriginalContent>>
        >
    with
        $FutureModifier<List<OriginalContent>>,
        $FutureProvider<List<OriginalContent>> {
  /// オリジナル文章一覧のプロバイダー
  const OriginalContentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originalContentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originalContentsHash();

  @$internal
  @override
  $FutureProviderElement<List<OriginalContent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OriginalContent>> create(Ref ref) {
    return originalContents(ref);
  }
}

String _$originalContentsHash() => r'7519d8c4c6b3e328d71185315c52d1ecc5d54f0d';

/// 単一のオリジナル文章を取得するプロバイダー

@ProviderFor(originalContent)
const originalContentProvider = OriginalContentFamily._();

/// 単一のオリジナル文章を取得するプロバイダー

final class OriginalContentProvider
    extends
        $FunctionalProvider<
          AsyncValue<OriginalContent?>,
          OriginalContent?,
          FutureOr<OriginalContent?>
        >
    with $FutureModifier<OriginalContent?>, $FutureProvider<OriginalContent?> {
  /// 単一のオリジナル文章を取得するプロバイダー
  const OriginalContentProvider._({
    required OriginalContentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'originalContentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$originalContentHash();

  @override
  String toString() {
    return r'originalContentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OriginalContent?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OriginalContent?> create(Ref ref) {
    final argument = this.argument as String;
    return originalContent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OriginalContentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$originalContentHash() => r'5457e66564964039910d2ba325853cb6c2f5209a';

/// 単一のオリジナル文章を取得するプロバイダー

final class OriginalContentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OriginalContent?>, String> {
  const OriginalContentFamily._()
    : super(
        retry: null,
        name: r'originalContentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 単一のオリジナル文章を取得するプロバイダー

  OriginalContentProvider call(String id) =>
      OriginalContentProvider._(argument: id, from: this);

  @override
  String toString() => r'originalContentProvider';
}

/// オリジナル文章の統計を取得するプロバイダー

@ProviderFor(originalContentStats)
const originalContentStatsProvider = OriginalContentStatsProvider._();

/// オリジナル文章の統計を取得するプロバイダー

final class OriginalContentStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<OriginalContentStats>,
          OriginalContentStats,
          FutureOr<OriginalContentStats>
        >
    with
        $FutureModifier<OriginalContentStats>,
        $FutureProvider<OriginalContentStats> {
  /// オリジナル文章の統計を取得するプロバイダー
  const OriginalContentStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originalContentStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originalContentStatsHash();

  @$internal
  @override
  $FutureProviderElement<OriginalContentStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OriginalContentStats> create(Ref ref) {
    return originalContentStats(ref);
  }
}

String _$originalContentStatsHash() =>
    r'f201c589512e4e98537f0d442cb19a1f0ffec691';

/// オリジナル文章の保存（新規作成・更新）Notifier

@ProviderFor(OriginalContentSaver)
const originalContentSaverProvider = OriginalContentSaverProvider._();

/// オリジナル文章の保存（新規作成・更新）Notifier
final class OriginalContentSaverProvider
    extends $AsyncNotifierProvider<OriginalContentSaver, void> {
  /// オリジナル文章の保存（新規作成・更新）Notifier
  const OriginalContentSaverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originalContentSaverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originalContentSaverHash();

  @$internal
  @override
  OriginalContentSaver create() => OriginalContentSaver();
}

String _$originalContentSaverHash() =>
    r'3f90349d6429991c70711b835fc93486fb4625e2';

/// オリジナル文章の保存（新規作成・更新）Notifier

abstract class _$OriginalContentSaver extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

/// 練習回数更新Notifier

@ProviderFor(OriginalContentPractice)
const originalContentPracticeProvider = OriginalContentPracticeProvider._();

/// 練習回数更新Notifier
final class OriginalContentPracticeProvider
    extends $AsyncNotifierProvider<OriginalContentPractice, void> {
  /// 練習回数更新Notifier
  const OriginalContentPracticeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'originalContentPracticeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$originalContentPracticeHash();

  @$internal
  @override
  OriginalContentPractice create() => OriginalContentPractice();
}

String _$originalContentPracticeHash() =>
    r'f8bd15709efba4e36321573e7b7fde884f1bab82';

/// 練習回数更新Notifier

abstract class _$OriginalContentPractice extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
