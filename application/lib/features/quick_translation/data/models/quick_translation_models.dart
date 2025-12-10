import 'dart:math';

/// 回答結果
enum AnswerResult {
  correct,       // 正解
  almostCorrect, // ほぼ正解（80%以上の類似度）
  incorrect,     // 不正解
  skipped,       // スキップ
}

/// 出題モード
enum PracticeMode {
  sequential, // 順番
  random,     // ランダム
}

/// 入力モード
enum InputMode {
  voice,  // 音声入力
  manual, // 手動モード
}

/// 瞬間作文の問題
class QuickTranslationQuestion {
  const QuickTranslationQuestion({
    required this.id,
    required this.order,
    required this.japanese,
    required this.korean,
    this.alternativeAnswers = const [],
    this.hint,
    this.explanation,
  });

  final String id;
  final int order;
  final String japanese;
  final String korean;
  final List<String> alternativeAnswers;
  final String? hint;
  final String? explanation;

  factory QuickTranslationQuestion.fromJson(Map<String, dynamic> json) {
    final alternativeAnswersJson =
        json['alternativeAnswers'] as List<dynamic>? ?? [];
    return QuickTranslationQuestion(
      id: json['id'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      japanese: json['japanese'] as String? ?? '',
      korean: json['korean'] as String? ?? '',
      alternativeAnswers: alternativeAnswersJson.whereType<String>().toList(),
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
    );
  }
}

/// 文法項目の問題セット
class QuickTranslationQuestionSet {
  const QuickTranslationQuestionSet({
    required this.grammarRef,
    required this.grammarTitle,
    required this.grammarSubtitle,
    required this.category,
    required this.questions,
  });

  final String grammarRef;
  final String grammarTitle;
  final String grammarSubtitle;
  final String category;
  final List<QuickTranslationQuestion> questions;

  factory QuickTranslationQuestionSet.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List<dynamic>? ?? [];
    return QuickTranslationQuestionSet(
      grammarRef: json['grammarRef'] as String? ?? '',
      grammarTitle: json['grammarTitle'] as String? ?? '',
      grammarSubtitle: json['grammarSubtitle'] as String? ?? '',
      category: json['category'] as String? ?? '',
      questions: questionsJson
          .whereType<Map<String, dynamic>>()
          .map(QuickTranslationQuestion.fromJson)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order)),
    );
  }

  /// 問題をシャッフルしたコピーを返す
  QuickTranslationQuestionSet shuffled() {
    final shuffledQuestions = List<QuickTranslationQuestion>.from(questions)
      ..shuffle(Random());
    return QuickTranslationQuestionSet(
      grammarRef: grammarRef,
      grammarTitle: grammarTitle,
      grammarSubtitle: grammarSubtitle,
      category: category,
      questions: shuffledQuestions,
    );
  }
}

/// 回答記録
class QuickTranslationRecord {
  const QuickTranslationRecord({
    required this.questionId,
    required this.result,
    required this.userAnswer,
    required this.attemptedAt,
  });

  final String questionId;
  final AnswerResult result;
  final String userAnswer;
  final DateTime attemptedAt;

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'result': result.name,
      'userAnswer': userAnswer,
      'attemptedAt': attemptedAt.toIso8601String(),
    };
  }

  factory QuickTranslationRecord.fromJson(Map<String, dynamic> json) {
    return QuickTranslationRecord(
      questionId: json['questionId'] as String? ?? '',
      result: AnswerResult.values.firstWhere(
        (e) => e.name == json['result'],
        orElse: () => AnswerResult.incorrect,
      ),
      userAnswer: json['userAnswer'] as String? ?? '',
      attemptedAt: DateTime.tryParse(json['attemptedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// 項目別の進捗
class GrammarItemProgress {
  const GrammarItemProgress({
    required this.grammarRef,
    required this.isCleared,
    required this.bestCorrectCount,
    this.lastPracticedAt,
  });

  final String grammarRef;
  final bool isCleared; // 10問中8問以上正解でクリア
  final int bestCorrectCount;
  final DateTime? lastPracticedAt;

  Map<String, dynamic> toJson() {
    return {
      'grammarRef': grammarRef,
      'isCleared': isCleared,
      'bestCorrectCount': bestCorrectCount,
      'lastPracticedAt': lastPracticedAt?.toIso8601String(),
    };
  }

  factory GrammarItemProgress.fromJson(Map<String, dynamic> json) {
    return GrammarItemProgress(
      grammarRef: json['grammarRef'] as String? ?? '',
      isCleared: json['isCleared'] as bool? ?? false,
      bestCorrectCount: json['bestCorrectCount'] as int? ?? 0,
      lastPracticedAt:
          DateTime.tryParse(json['lastPracticedAt'] as String? ?? ''),
    );
  }

  GrammarItemProgress copyWith({
    bool? isCleared,
    int? bestCorrectCount,
    DateTime? lastPracticedAt,
  }) {
    return GrammarItemProgress(
      grammarRef: grammarRef,
      isCleared: isCleared ?? this.isCleared,
      bestCorrectCount: bestCorrectCount ?? this.bestCorrectCount,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
    );
  }
}

/// 練習セッションの状態
class PracticeSessionState {
  const PracticeSessionState({
    required this.questionSet,
    required this.practiceMode,
    required this.inputMode,
    required this.currentIndex,
    required this.records,
    required this.startedAt,
    this.completedAt,
  });

  final QuickTranslationQuestionSet questionSet;
  final PracticeMode practiceMode;
  final InputMode inputMode;
  final int currentIndex;
  final List<QuickTranslationRecord> records;
  final DateTime startedAt;
  final DateTime? completedAt;

  /// 現在の問題
  QuickTranslationQuestion get currentQuestion =>
      questionSet.questions[currentIndex];

  /// 問題数
  int get totalQuestions => questionSet.questions.length;

  /// 完了したかどうか
  bool get isCompleted => currentIndex >= totalQuestions;

  /// 進捗率
  double get progressRate => currentIndex / totalQuestions;

  /// 正解数
  int get correctCount =>
      records.where((r) => r.result == AnswerResult.correct).length;

  /// ほぼ正解数
  int get almostCorrectCount =>
      records.where((r) => r.result == AnswerResult.almostCorrect).length;

  /// 不正解数
  int get incorrectCount =>
      records.where((r) => r.result == AnswerResult.incorrect).length;

  /// スキップ数
  int get skippedCount =>
      records.where((r) => r.result == AnswerResult.skipped).length;

  PracticeSessionState copyWith({
    int? currentIndex,
    List<QuickTranslationRecord>? records,
    DateTime? completedAt,
  }) {
    return PracticeSessionState(
      questionSet: questionSet,
      practiceMode: practiceMode,
      inputMode: inputMode,
      currentIndex: currentIndex ?? this.currentIndex,
      records: records ?? this.records,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// 利用可能な文法項目（カテゴリ内）
class AvailableGrammarItem {
  const AvailableGrammarItem({
    required this.grammarRef,
    required this.grammarTitle,
    required this.grammarSubtitle,
    required this.category,
    required this.progress,
  });

  final String grammarRef;
  final String grammarTitle;
  final String grammarSubtitle;
  final String category;
  final GrammarItemProgress? progress;

  bool get isCleared => progress?.isCleared ?? false;
}

/// カテゴリ情報
class QuickTranslationCategory {
  const QuickTranslationCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.itemCount,
    required this.clearedCount,
  });

  final String id;
  final String name;
  final String description;
  final int itemCount;
  final int clearedCount;

  double get progressRate => itemCount > 0 ? clearedCount / itemCount : 0.0;
}
