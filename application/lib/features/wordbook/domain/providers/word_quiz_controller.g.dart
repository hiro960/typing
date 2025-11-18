// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WordQuizController)
const wordQuizControllerProvider = WordQuizControllerProvider._();

final class WordQuizControllerProvider
    extends $NotifierProvider<WordQuizController, WordQuizState> {
  const WordQuizControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordQuizControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordQuizControllerHash();

  @$internal
  @override
  WordQuizController create() => WordQuizController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WordQuizState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WordQuizState>(value),
    );
  }
}

String _$wordQuizControllerHash() =>
    r'98376246dc596c1e87d704f6fbeb956f5e781644';

abstract class _$WordQuizController extends $Notifier<WordQuizState> {
  WordQuizState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WordQuizState, WordQuizState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WordQuizState, WordQuizState>,
              WordQuizState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
