// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hanja_quiz_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hanjaQuizRepository)
const hanjaQuizRepositoryProvider = HanjaQuizRepositoryProvider._();

final class HanjaQuizRepositoryProvider
    extends
        $FunctionalProvider<
          HanjaQuizRepository,
          HanjaQuizRepository,
          HanjaQuizRepository
        >
    with $Provider<HanjaQuizRepository> {
  const HanjaQuizRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hanjaQuizRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hanjaQuizRepositoryHash();

  @$internal
  @override
  $ProviderElement<HanjaQuizRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HanjaQuizRepository create(Ref ref) {
    return hanjaQuizRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HanjaQuizRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HanjaQuizRepository>(value),
    );
  }
}

String _$hanjaQuizRepositoryHash() =>
    r'3a77fbf07a058309d157b89b3cdefcfb77c1fc2c';

@ProviderFor(confusingCharService)
const confusingCharServiceProvider = ConfusingCharServiceProvider._();

final class ConfusingCharServiceProvider
    extends
        $FunctionalProvider<
          ConfusingCharService,
          ConfusingCharService,
          ConfusingCharService
        >
    with $Provider<ConfusingCharService> {
  const ConfusingCharServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'confusingCharServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$confusingCharServiceHash();

  @$internal
  @override
  $ProviderElement<ConfusingCharService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConfusingCharService create(Ref ref) {
    return confusingCharService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfusingCharService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfusingCharService>(value),
    );
  }
}

String _$confusingCharServiceHash() =>
    r'1f68383cdb946c61be0592655bbc8895fedab20a';

@ProviderFor(MasteredWords)
const masteredWordsProvider = MasteredWordsProvider._();

final class MasteredWordsProvider
    extends $AsyncNotifierProvider<MasteredWords, Set<String>> {
  const MasteredWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masteredWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masteredWordsHash();

  @$internal
  @override
  MasteredWords create() => MasteredWords();
}

String _$masteredWordsHash() => r'ec5c7310f7c1b10c32c6a2b5a0dd23b7928996e8';

abstract class _$MasteredWords extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(masteredWordsCount)
const masteredWordsCountProvider = MasteredWordsCountProvider._();

final class MasteredWordsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const MasteredWordsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masteredWordsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masteredWordsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return masteredWordsCount(ref);
  }
}

String _$masteredWordsCountHash() =>
    r'51bd130903d22a2aa8e64e85877d7cde6e75b07b';

@ProviderFor(totalWordsCount)
const totalWordsCountProvider = TotalWordsCountProvider._();

final class TotalWordsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const TotalWordsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalWordsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalWordsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return totalWordsCount(ref);
  }
}

String _$totalWordsCountHash() => r'b3c2e03b11f7bfe5abae9145d3ff1e0115523360';

@ProviderFor(availableQuizWords)
const availableQuizWordsProvider = AvailableQuizWordsProvider._();

final class AvailableQuizWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaWord>>,
          List<HanjaWord>,
          FutureOr<List<HanjaWord>>
        >
    with $FutureModifier<List<HanjaWord>>, $FutureProvider<List<HanjaWord>> {
  const AvailableQuizWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableQuizWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableQuizWordsHash();

  @$internal
  @override
  $FutureProviderElement<List<HanjaWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaWord>> create(Ref ref) {
    return availableQuizWords(ref);
  }
}

String _$availableQuizWordsHash() =>
    r'ff791587b7e6108068efb9401d8ed5214df70885';

@ProviderFor(HanjaQuiz)
const hanjaQuizProvider = HanjaQuizProvider._();

final class HanjaQuizProvider
    extends $NotifierProvider<HanjaQuiz, HanjaQuizState?> {
  const HanjaQuizProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hanjaQuizProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hanjaQuizHash();

  @$internal
  @override
  HanjaQuiz create() => HanjaQuiz();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HanjaQuizState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HanjaQuizState?>(value),
    );
  }
}

String _$hanjaQuizHash() => r'3c002775c2ced5b56338d3872c4f5d96994d9cec';

abstract class _$HanjaQuiz extends $Notifier<HanjaQuizState?> {
  HanjaQuizState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HanjaQuizState?, HanjaQuizState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HanjaQuizState?, HanjaQuizState?>,
              HanjaQuizState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
