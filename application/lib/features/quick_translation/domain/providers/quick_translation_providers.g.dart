// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_translation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quickTranslationRepository)
const quickTranslationRepositoryProvider =
    QuickTranslationRepositoryProvider._();

final class QuickTranslationRepositoryProvider
    extends
        $FunctionalProvider<
          QuickTranslationRepository,
          QuickTranslationRepository,
          QuickTranslationRepository
        >
    with $Provider<QuickTranslationRepository> {
  const QuickTranslationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickTranslationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickTranslationRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuickTranslationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickTranslationRepository create(Ref ref) {
    return quickTranslationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickTranslationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickTranslationRepository>(value),
    );
  }
}

String _$quickTranslationRepositoryHash() =>
    r'45c9abfac02bf090ed197da4da020aa5e2dd1a1c';

@ProviderFor(answerCheckerService)
const answerCheckerServiceProvider = AnswerCheckerServiceProvider._();

final class AnswerCheckerServiceProvider
    extends
        $FunctionalProvider<
          AnswerCheckerService,
          AnswerCheckerService,
          AnswerCheckerService
        >
    with $Provider<AnswerCheckerService> {
  const AnswerCheckerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'answerCheckerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$answerCheckerServiceHash();

  @$internal
  @override
  $ProviderElement<AnswerCheckerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnswerCheckerService create(Ref ref) {
    return answerCheckerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnswerCheckerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnswerCheckerService>(value),
    );
  }
}

String _$answerCheckerServiceHash() =>
    r'83a7e358bb9aa4bc881b01f0af67bac77201ce4c';

@ProviderFor(speechRecognitionService)
const speechRecognitionServiceProvider = SpeechRecognitionServiceProvider._();

final class SpeechRecognitionServiceProvider
    extends
        $FunctionalProvider<
          SpeechRecognitionService,
          SpeechRecognitionService,
          SpeechRecognitionService
        >
    with $Provider<SpeechRecognitionService> {
  const SpeechRecognitionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechRecognitionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechRecognitionServiceHash();

  @$internal
  @override
  $ProviderElement<SpeechRecognitionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpeechRecognitionService create(Ref ref) {
    return speechRecognitionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechRecognitionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechRecognitionService>(value),
    );
  }
}

String _$speechRecognitionServiceHash() =>
    r'24ba4fe2bf222fd0e41986e42eed77c4e12f1116';

/// 利用可能なカテゴリ一覧
/// grammar_index.jsonのカテゴリ定義に基づく

@ProviderFor(quickTranslationCategories)
const quickTranslationCategoriesProvider =
    QuickTranslationCategoriesProvider._();

/// 利用可能なカテゴリ一覧
/// grammar_index.jsonのカテゴリ定義に基づく

final class QuickTranslationCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuickTranslationCategory>>,
          List<QuickTranslationCategory>,
          FutureOr<List<QuickTranslationCategory>>
        >
    with
        $FutureModifier<List<QuickTranslationCategory>>,
        $FutureProvider<List<QuickTranslationCategory>> {
  /// 利用可能なカテゴリ一覧
  /// grammar_index.jsonのカテゴリ定義に基づく
  const QuickTranslationCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickTranslationCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickTranslationCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<QuickTranslationCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuickTranslationCategory>> create(Ref ref) {
    return quickTranslationCategories(ref);
  }
}

String _$quickTranslationCategoriesHash() =>
    r'5b9e605f559cd8842e28ff6c643e9ea9da975071';

/// カテゴリ内の利用可能な文法項目一覧

@ProviderFor(availableGrammarItems)
const availableGrammarItemsProvider = AvailableGrammarItemsFamily._();

/// カテゴリ内の利用可能な文法項目一覧

final class AvailableGrammarItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AvailableGrammarItem>>,
          List<AvailableGrammarItem>,
          FutureOr<List<AvailableGrammarItem>>
        >
    with
        $FutureModifier<List<AvailableGrammarItem>>,
        $FutureProvider<List<AvailableGrammarItem>> {
  /// カテゴリ内の利用可能な文法項目一覧
  const AvailableGrammarItemsProvider._({
    required AvailableGrammarItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'availableGrammarItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$availableGrammarItemsHash();

  @override
  String toString() {
    return r'availableGrammarItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AvailableGrammarItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AvailableGrammarItem>> create(Ref ref) {
    final argument = this.argument as String;
    return availableGrammarItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableGrammarItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$availableGrammarItemsHash() =>
    r'dcda8bd125ef32c00e1b665e849c162eccc3ebf1';

/// カテゴリ内の利用可能な文法項目一覧

final class AvailableGrammarItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AvailableGrammarItem>>,
          String
        > {
  const AvailableGrammarItemsFamily._()
    : super(
        retry: null,
        name: r'availableGrammarItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// カテゴリ内の利用可能な文法項目一覧

  AvailableGrammarItemsProvider call(String categoryId) =>
      AvailableGrammarItemsProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'availableGrammarItemsProvider';
}

/// 問題セット

@ProviderFor(questionSet)
const questionSetProvider = QuestionSetFamily._();

/// 問題セット

final class QuestionSetProvider
    extends
        $FunctionalProvider<
          AsyncValue<QuickTranslationQuestionSet?>,
          QuickTranslationQuestionSet?,
          FutureOr<QuickTranslationQuestionSet?>
        >
    with
        $FutureModifier<QuickTranslationQuestionSet?>,
        $FutureProvider<QuickTranslationQuestionSet?> {
  /// 問題セット
  const QuestionSetProvider._({
    required QuestionSetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'questionSetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$questionSetHash();

  @override
  String toString() {
    return r'questionSetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<QuickTranslationQuestionSet?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<QuickTranslationQuestionSet?> create(Ref ref) {
    final argument = this.argument as String;
    return questionSet(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionSetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$questionSetHash() => r'c96b5a77304044adec1e6b88a0355bf907317dc6';

/// 問題セット

final class QuestionSetFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<QuickTranslationQuestionSet?>,
          String
        > {
  const QuestionSetFamily._()
    : super(
        retry: null,
        name: r'questionSetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 問題セット

  QuestionSetProvider call(String grammarRef) =>
      QuestionSetProvider._(argument: grammarRef, from: this);

  @override
  String toString() => r'questionSetProvider';
}

/// 項目別進捗

@ProviderFor(grammarItemProgress)
const grammarItemProgressProvider = GrammarItemProgressFamily._();

/// 項目別進捗

final class GrammarItemProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<GrammarItemProgress?>,
          GrammarItemProgress?,
          FutureOr<GrammarItemProgress?>
        >
    with
        $FutureModifier<GrammarItemProgress?>,
        $FutureProvider<GrammarItemProgress?> {
  /// 項目別進捗
  const GrammarItemProgressProvider._({
    required GrammarItemProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'grammarItemProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$grammarItemProgressHash();

  @override
  String toString() {
    return r'grammarItemProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GrammarItemProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GrammarItemProgress?> create(Ref ref) {
    final argument = this.argument as String;
    return grammarItemProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GrammarItemProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$grammarItemProgressHash() =>
    r'cb843e92f9e62bbebafdd810c948bead74bbe096';

/// 項目別進捗

final class GrammarItemProgressFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GrammarItemProgress?>, String> {
  const GrammarItemProgressFamily._()
    : super(
        retry: null,
        name: r'grammarItemProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 項目別進捗

  GrammarItemProgressProvider call(String grammarRef) =>
      GrammarItemProgressProvider._(argument: grammarRef, from: this);

  @override
  String toString() => r'grammarItemProgressProvider';
}

/// 全進捗

@ProviderFor(allGrammarProgress)
const allGrammarProgressProvider = AllGrammarProgressProvider._();

/// 全進捗

final class AllGrammarProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, GrammarItemProgress>>,
          Map<String, GrammarItemProgress>,
          FutureOr<Map<String, GrammarItemProgress>>
        >
    with
        $FutureModifier<Map<String, GrammarItemProgress>>,
        $FutureProvider<Map<String, GrammarItemProgress>> {
  /// 全進捗
  const AllGrammarProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allGrammarProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allGrammarProgressHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, GrammarItemProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, GrammarItemProgress>> create(Ref ref) {
    return allGrammarProgress(ref);
  }
}

String _$allGrammarProgressHash() =>
    r'7a299d4fe6991c31330b93cf75a73da6e4a658fd';

/// 練習セッション状態

@ProviderFor(PracticeSessionNotifier)
const practiceSessionProvider = PracticeSessionNotifierProvider._();

/// 練習セッション状態
final class PracticeSessionNotifierProvider
    extends $NotifierProvider<PracticeSessionNotifier, PracticeSessionState?> {
  /// 練習セッション状態
  const PracticeSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'practiceSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$practiceSessionNotifierHash();

  @$internal
  @override
  PracticeSessionNotifier create() => PracticeSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PracticeSessionState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PracticeSessionState?>(value),
    );
  }
}

String _$practiceSessionNotifierHash() =>
    r'77713696f79573bb4be5aa1785a2959fe1a0103e';

/// 練習セッション状態

abstract class _$PracticeSessionNotifier
    extends $Notifier<PracticeSessionState?> {
  PracticeSessionState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PracticeSessionState?, PracticeSessionState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PracticeSessionState?, PracticeSessionState?>,
              PracticeSessionState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
