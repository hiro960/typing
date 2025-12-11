import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/quick_translation_models.dart';
import '../../data/repositories/quick_translation_repository.dart';
import '../../data/services/answer_checker_service.dart';
import '../../data/services/speech_recognition_service.dart';

part 'quick_translation_providers.g.dart';

// ==================== Repository & Service Providers ====================

@Riverpod(keepAlive: true)
QuickTranslationRepository quickTranslationRepository(Ref ref) {
  return QuickTranslationRepository();
}

@Riverpod(keepAlive: true)
AnswerCheckerService answerCheckerService(Ref ref) {
  return const AnswerCheckerService();
}

@Riverpod(keepAlive: true)
SpeechRecognitionService speechRecognitionService(Ref ref) {
  return SpeechRecognitionService();
}

// ==================== Data Providers ====================

/// 利用可能なカテゴリ一覧
/// grammar_index.jsonのカテゴリ定義に基づく
@riverpod
Future<List<QuickTranslationCategory>> quickTranslationCategories(
  Ref ref,
) async {
  final repository = ref.watch(quickTranslationRepositoryProvider);
  final clearedCounts = await repository.getClearedCountByCategory();

  // 固定のカテゴリ定義（grammar_index.jsonをベースに、orthographyは非表示）
  final categoryDefinitions = [
    // 表記・発音（orthography）は現状非表示
    ('substantive', '体言', '代名詞・数詞・疑問詞など'),
    ('particle', '助詞', '이/가、은/는、에、에서など'),
    ('conjugation', '用言と活用', '不規則活用パターン'),
    ('sentence_ending', '終止形と待遇法', '-아/어요、-습니다など'),
    ('connective', '接続形', '-고、-아서、-면、-지만'),
    ('adnominal', '連体形', '名詞を修飾する形'),
    ('tense_aspect', '時制', '時制・否定・受身・使役'),
    ('expression', 'さまざまな表現', '文法的な慣用表現'),
    ('quotation', '直接話法と間接話法', '引用表現'),
    ('word_formation', '単語の作り', '副詞形・体言形・接辞'),
  ];

  final categories = <QuickTranslationCategory>[];

  for (final (id, name, description) in categoryDefinitions) {
    final items = await repository.loadAvailableItems(id);
    if (items.isEmpty) continue;

    categories.add(QuickTranslationCategory(
      id: id,
      name: name,
      description: description,
      itemCount: items.length,
      clearedCount: clearedCounts[id] ?? 0,
    ));
  }

  return categories;
}

/// カテゴリ内の利用可能な文法項目一覧
@riverpod
Future<List<AvailableGrammarItem>> availableGrammarItems(
  Ref ref,
  String categoryId,
) async {
  final repository = ref.watch(quickTranslationRepositoryProvider);
  final itemIds = await repository.loadAvailableItems(categoryId);
  final allProgress = await repository.loadAllProgress();

  final items = <AvailableGrammarItem>[];

  for (final grammarRef in itemIds) {
    final questionSet = await repository.loadQuestionSet(grammarRef);
    if (questionSet == null) continue;

    items.add(AvailableGrammarItem(
      grammarRef: grammarRef,
      grammarTitle: questionSet.grammarTitle,
      grammarSubtitle: questionSet.grammarSubtitle,
      category: categoryId,
      progress: allProgress[grammarRef],
    ));
  }

  return items;
}

/// 問題セット
@riverpod
Future<QuickTranslationQuestionSet?> questionSet(
  Ref ref,
  String grammarRef,
) async {
  final repository = ref.watch(quickTranslationRepositoryProvider);
  return repository.loadQuestionSet(grammarRef);
}

/// 項目別進捗
@riverpod
Future<GrammarItemProgress?> grammarItemProgress(
  Ref ref,
  String grammarRef,
) async {
  final repository = ref.watch(quickTranslationRepositoryProvider);
  return repository.loadProgress(grammarRef);
}

/// 全進捗
@riverpod
Future<Map<String, GrammarItemProgress>> allGrammarProgress(Ref ref) async {
  final repository = ref.watch(quickTranslationRepositoryProvider);
  return repository.loadAllProgress();
}

// ==================== Practice Session ====================

/// 練習セッション状態
@riverpod
class PracticeSessionNotifier extends _$PracticeSessionNotifier {
  @override
  PracticeSessionState? build() {
    return null;
  }

  /// セッションを開始
  Future<bool> startSession({
    required String grammarRef,
    required PracticeMode practiceMode,
    required InputMode inputMode,
  }) async {
    final repository = ref.read(quickTranslationRepositoryProvider);
    final questionSet = await repository.loadQuestionSet(grammarRef);

    if (questionSet == null) {
      return false;
    }

    final effectiveQuestionSet = practiceMode == PracticeMode.random
        ? questionSet.shuffled()
        : questionSet;

    state = PracticeSessionState(
      questionSet: effectiveQuestionSet,
      practiceMode: practiceMode,
      inputMode: inputMode,
      currentIndex: 0,
      records: [],
      startedAt: DateTime.now(),
    );

    return true;
  }

  /// 回答を記録して次へ進む
  void submitAnswer(String userAnswer, AnswerResult result) {
    if (state == null || state!.isCompleted) return;

    final record = QuickTranslationRecord(
      questionId: state!.currentQuestion.id,
      result: result,
      userAnswer: userAnswer,
      attemptedAt: DateTime.now(),
    );

    final newRecords = [...state!.records, record];
    final newIndex = state!.currentIndex + 1;

    state = state!.copyWith(
      currentIndex: newIndex,
      records: newRecords,
      completedAt: newIndex >= state!.totalQuestions ? DateTime.now() : null,
    );
  }

  /// スキップ
  void skip() {
    submitAnswer('', AnswerResult.skipped);
  }

  /// セッションを終了して進捗を保存
  Future<GrammarItemProgress?> finishSession() async {
    if (state == null) return null;

    final repository = ref.read(quickTranslationRepositoryProvider);
    final progress = await repository.updateProgressFromSession(state!);

    // カテゴリプロバイダーを無効化して再取得させる
    ref.invalidate(quickTranslationCategoriesProvider);
    ref.invalidate(availableGrammarItemsProvider(state!.questionSet.category));

    return progress;
  }

  /// セッションをリセット
  void reset() {
    state = null;
  }

  /// 間違えた問題だけで再開
  Future<bool> retryIncorrect() async {
    if (state == null) return false;

    // 不正解・スキップの問題だけを抽出
    final incorrectQuestionIds = state!.records
        .where((r) =>
            r.result == AnswerResult.incorrect ||
            r.result == AnswerResult.skipped)
        .map((r) => r.questionId)
        .toSet();

    if (incorrectQuestionIds.isEmpty) return false;

    final incorrectQuestions = state!.questionSet.questions
        .where((q) => incorrectQuestionIds.contains(q.id))
        .toList();

    final newQuestionSet = QuickTranslationQuestionSet(
      grammarRef: state!.questionSet.grammarRef,
      grammarTitle: state!.questionSet.grammarTitle,
      grammarSubtitle: state!.questionSet.grammarSubtitle,
      category: state!.questionSet.category,
      questions: incorrectQuestions,
    );

    state = PracticeSessionState(
      questionSet: state!.practiceMode == PracticeMode.random
          ? newQuestionSet.shuffled()
          : newQuestionSet,
      practiceMode: state!.practiceMode,
      inputMode: state!.inputMode,
      currentIndex: 0,
      records: [],
      startedAt: DateTime.now(),
    );

    return true;
  }

  /// もう一度最初から
  Future<bool> retry() async {
    if (state == null) return false;

    return startSession(
      grammarRef: state!.questionSet.grammarRef,
      practiceMode: state!.practiceMode,
      inputMode: state!.inputMode,
    );
  }
}
