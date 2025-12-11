import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../hanja/data/models/hanja_word.dart';

part 'hanja_quiz_models.g.dart';

/// クイズの問題数
enum QuizQuestionCount {
  ten(10, '10問'),
  twenty(20, '20問'),
  fifty(50, '50問');

  const QuizQuestionCount(this.value, this.label);
  final int value;
  final String label;
}

/// 各問題の回答記録
class QuizAnswerRecord {
  const QuizAnswerRecord({
    required this.word,
    required this.isCorrect,
    this.isMastered = false,
  });

  final HanjaWord word;
  final bool isCorrect;
  final bool isMastered;

  QuizAnswerRecord copyWith({
    HanjaWord? word,
    bool? isCorrect,
    bool? isMastered,
  }) {
    return QuizAnswerRecord(
      word: word ?? this.word,
      isCorrect: isCorrect ?? this.isCorrect,
      isMastered: isMastered ?? this.isMastered,
    );
  }
}

/// 漢字語クイズのゲーム状態
class HanjaQuizState {
  const HanjaQuizState({
    required this.questionCount,
    required this.questions,
    required this.startedAt,
    this.currentQuestionIndex = 0,
    this.currentCharIndex = 0,
    this.answeredChars = const [],
    this.choices = const [],
    this.hasWrongAnswer = false,
    this.isWordComplete = false,
    this.isGameComplete = false,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.answerHistory = const [],
  });

  /// 選択された問題数
  final QuizQuestionCount questionCount;

  /// 出題する問題リスト
  final List<HanjaWord> questions;

  /// ゲーム開始時刻
  final DateTime startedAt;

  /// 現在の問題番号（0始まり）
  final int currentQuestionIndex;

  /// 現在回答中の文字インデックス
  final int currentCharIndex;

  /// 回答済みの文字
  final List<String> answeredChars;

  /// 現在の選択肢
  final List<String> choices;

  /// 現在の単語で不正解があったか
  final bool hasWrongAnswer;

  /// 現在の単語の全文字回答完了か
  final bool isWordComplete;

  /// 全問題完了か
  final bool isGameComplete;

  /// 正解数
  final int correctCount;

  /// 不正解数
  final int wrongCount;

  /// 回答履歴（結果画面用）
  final List<QuizAnswerRecord> answerHistory;

  /// 現在の問題
  HanjaWord get currentWord => questions[currentQuestionIndex];

  /// 現在の問題の正解文字列（components から取得）
  List<String> get correctChars =>
      currentWord.components.map((c) => c.korean).toList();

  /// 現在回答すべき正解文字
  String get currentCorrectChar => correctChars[currentCharIndex];

  /// 進捗表示用テキスト
  String get progressText =>
      '${currentQuestionIndex + 1} / ${questionCount.value}';

  HanjaQuizState copyWith({
    QuizQuestionCount? questionCount,
    List<HanjaWord>? questions,
    DateTime? startedAt,
    int? currentQuestionIndex,
    int? currentCharIndex,
    List<String>? answeredChars,
    List<String>? choices,
    bool? hasWrongAnswer,
    bool? isWordComplete,
    bool? isGameComplete,
    int? correctCount,
    int? wrongCount,
    List<QuizAnswerRecord>? answerHistory,
  }) {
    return HanjaQuizState(
      questionCount: questionCount ?? this.questionCount,
      questions: questions ?? this.questions,
      startedAt: startedAt ?? this.startedAt,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      currentCharIndex: currentCharIndex ?? this.currentCharIndex,
      answeredChars: answeredChars ?? this.answeredChars,
      choices: choices ?? this.choices,
      hasWrongAnswer: hasWrongAnswer ?? this.hasWrongAnswer,
      isWordComplete: isWordComplete ?? this.isWordComplete,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      answerHistory: answerHistory ?? this.answerHistory,
    );
  }
}

/// 覚えた漢字語の記録
@JsonSerializable()
class MasteredHanjaWord {
  const MasteredHanjaWord({
    required this.wordId,
    required this.masteredAt,
  });

  final String wordId;
  final DateTime masteredAt;

  factory MasteredHanjaWord.fromJson(Map<String, dynamic> json) =>
      _$MasteredHanjaWordFromJson(json);

  Map<String, dynamic> toJson() => _$MasteredHanjaWordToJson(this);
}

/// クイズ結果のサマリー
class QuizResultSummary {
  const QuizResultSummary({
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.answerHistory,
  });

  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final List<QuizAnswerRecord> answerHistory;

  /// 正答率（0.0 - 1.0）
  double get accuracy =>
      totalQuestions > 0 ? correctCount / totalQuestions : 0.0;

  /// 正答率（パーセント表示）
  String get accuracyPercent => '${(accuracy * 100).round()}%';
}
