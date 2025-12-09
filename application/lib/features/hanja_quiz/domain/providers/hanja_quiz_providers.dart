import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../hanja/data/models/hanja_word.dart';
import '../../../hanja/domain/providers/hanja_providers.dart';
import '../../data/models/hanja_quiz_models.dart';
import '../../data/repositories/hanja_quiz_repository.dart';
import '../../data/services/confusing_char_service.dart';

part 'hanja_quiz_providers.g.dart';

// ===== サービス・リポジトリプロバイダー =====

@Riverpod(keepAlive: true)
HanjaQuizRepository hanjaQuizRepository(Ref ref) {
  return HanjaQuizRepository();
}

@Riverpod(keepAlive: true)
ConfusingCharService confusingCharService(Ref ref) {
  return ConfusingCharService();
}

// ===== 覚えた単語プロバイダー =====

@riverpod
class MasteredWords extends _$MasteredWords {
  @override
  Future<Set<String>> build() async {
    final repository = ref.watch(hanjaQuizRepositoryProvider);
    return repository.getMasteredWordIds();
  }

  Future<void> markAsMastered(String wordId) async {
    final repository = ref.read(hanjaQuizRepositoryProvider);
    await repository.markAsMastered(wordId);
    ref.invalidateSelf();
  }

  Future<void> unmarkAsMastered(String wordId) async {
    final repository = ref.read(hanjaQuizRepositoryProvider);
    await repository.unmarkAsMastered(wordId);
    ref.invalidateSelf();
  }
}

@riverpod
Future<int> masteredWordsCount(Ref ref) async {
  final masteredWords = await ref.watch(masteredWordsProvider.future);
  return masteredWords.length;
}

@riverpod
Future<int> totalWordsCount(Ref ref) async {
  final allWords = await ref.watch(allHanjaWordsProvider.future);
  return allWords.length;
}

// ===== 出題可能な単語プロバイダー =====

@riverpod
Future<List<HanjaWord>> availableQuizWords(Ref ref) async {
  final allWords = await ref.watch(allHanjaWordsProvider.future);
  final masteredIds = await ref.watch(masteredWordsProvider.future);

  // 覚えた単語を除外し、componentsが空でないものだけを対象
  return allWords
      .where((w) => !masteredIds.contains(w.id) && w.components.isNotEmpty)
      .toList();
}

// ===== クイズ状態管理プロバイダー =====

@Riverpod(keepAlive: true)
class HanjaQuiz extends _$HanjaQuiz {
  final _random = Random();

  @override
  HanjaQuizState? build() {
    return null;
  }

  /// ゲームを開始
  Future<void> startGame(QuizQuestionCount questionCount) async {
    final availableWords = await ref.read(availableQuizWordsProvider.future);
    final confusingService = ref.read(confusingCharServiceProvider);

    if (availableWords.isEmpty) {
      return;
    }

    // ランダムに問題を選択
    final shuffled = List<HanjaWord>.from(availableWords)..shuffle(_random);
    final questions = shuffled.take(questionCount.value).toList();

    if (questions.isEmpty) {
      return;
    }

    // 最初の選択肢を生成
    final firstWord = questions.first;
    final firstCorrectChar = firstWord.components.first.korean;
    final choices = confusingService.generateChoices(firstCorrectChar);

    state = HanjaQuizState(
      questionCount: questionCount,
      questions: questions,
      choices: choices,
    );
  }

  /// 回答を選択
  void selectAnswer(String selected) {
    final currentState = state;
    if (currentState == null || currentState.isGameComplete) return;

    final correctChar = currentState.currentCorrectChar;
    final isCorrect = selected == correctChar;

    if (isCorrect) {
      _handleCorrectAnswer(currentState, selected);
    } else {
      _handleWrongAnswer(currentState);
    }
  }

  void _handleCorrectAnswer(HanjaQuizState currentState, String selected) {
    final confusingService = ref.read(confusingCharServiceProvider);
    final newAnsweredChars = [...currentState.answeredChars, selected];
    final totalChars = currentState.correctChars.length;

    if (newAnsweredChars.length >= totalChars) {
      // 現在の単語を完了
      state = currentState.copyWith(
        answeredChars: newAnsweredChars,
        isWordComplete: true,
        correctCount: currentState.hasWrongAnswer
            ? currentState.correctCount
            : currentState.correctCount + 1,
      );
    } else {
      // 次の文字へ
      final nextCharIndex = currentState.currentCharIndex + 1;
      final nextCorrectChar = currentState.correctChars[nextCharIndex];
      final newChoices = confusingService.generateChoices(nextCorrectChar);

      state = currentState.copyWith(
        currentCharIndex: nextCharIndex,
        answeredChars: newAnsweredChars,
        choices: newChoices,
      );
    }
  }

  void _handleWrongAnswer(HanjaQuizState currentState) {
    // 不正解の場合は正解を表示して次の問題へ進めるようにする
    state = currentState.copyWith(
      hasWrongAnswer: true,
      isWordComplete: true,
      wrongCount: currentState.wrongCount + 1,
    );
  }

  /// 次の問題へ進む
  void nextQuestion({bool markAsMastered = false}) {
    final currentState = state;
    if (currentState == null) return;

    final confusingService = ref.read(confusingCharServiceProvider);
    final currentWord = currentState.currentWord;

    // 回答履歴に追加
    final newRecord = QuizAnswerRecord(
      word: currentWord,
      isCorrect: !currentState.hasWrongAnswer,
      isMastered: markAsMastered,
    );
    final newHistory = [...currentState.answerHistory, newRecord];

    // 覚えた場合は記録
    if (markAsMastered) {
      ref.read(masteredWordsProvider.notifier).markAsMastered(currentWord.id);
    }

    final nextIndex = currentState.currentQuestionIndex + 1;

    if (nextIndex >= currentState.questions.length) {
      // ゲーム終了
      state = currentState.copyWith(
        isGameComplete: true,
        answerHistory: newHistory,
      );
    } else {
      // 次の問題へ
      final nextWord = currentState.questions[nextIndex];
      final nextCorrectChar = nextWord.components.first.korean;
      final newChoices = confusingService.generateChoices(nextCorrectChar);

      state = currentState.copyWith(
        currentQuestionIndex: nextIndex,
        currentCharIndex: 0,
        answeredChars: [],
        choices: newChoices,
        hasWrongAnswer: false,
        isWordComplete: false,
        answerHistory: newHistory,
      );
    }
  }

  /// ゲームをリセット
  void resetGame() {
    state = null;
  }

  /// 結果サマリーを取得
  QuizResultSummary? getResultSummary() {
    final currentState = state;
    if (currentState == null) return null;

    return QuizResultSummary(
      totalQuestions: currentState.questions.length,
      correctCount: currentState.correctCount,
      wrongCount: currentState.wrongCount,
      answerHistory: currentState.answerHistory,
    );
  }
}
