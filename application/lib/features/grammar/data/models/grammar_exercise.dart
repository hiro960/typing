import 'grammar_models.dart';

/// 練習問題
class GrammarExercise {
  const GrammarExercise({
    required this.id,
    required this.type,
    required this.question,
    this.answer,
    this.hint,
    this.explanation,
    this.choices,
    this.answerIndex,
    this.acceptableAnswers,
    this.pairs,
    this.japanese,
  });

  final String id;
  final ExerciseType type;
  final String question;
  final String? answer;
  final String? hint;
  final String? explanation;
  final List<String>? choices;
  final int? answerIndex;
  final List<String>? acceptableAnswers;
  final List<MatchingPair>? pairs;
  final String? japanese;

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'fill_blank';
    final choicesJson = json['choices'] as List<dynamic>?;
    final acceptableJson = json['acceptableAnswers'] as List<dynamic>?;
    final pairsJson = json['pairs'] as List<dynamic>?;

    return GrammarExercise(
      id: json['id'] as String? ?? '',
      type: ExerciseTypeX.fromKey(typeStr) ?? ExerciseType.fillBlank,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String?,
      hint: json['hint'] as String?,
      explanation: json['explanation'] as String?,
      choices: choicesJson?.whereType<String>().toList(),
      answerIndex: json['answerIndex'] as int?,
      acceptableAnswers: acceptableJson?.whereType<String>().toList(),
      pairs:
          pairsJson
              ?.whereType<Map<String, dynamic>>()
              .map(MatchingPair.fromJson)
              .toList(),
      japanese: json['japanese'] as String?,
    );
  }

  /// 回答が正解かどうかを判定
  bool checkAnswer(dynamic userAnswer) {
    switch (type) {
      case ExerciseType.fillBlank:
      case ExerciseType.typing:
      case ExerciseType.translation:
        final normalizedUserAnswer =
            userAnswer.toString().replaceAll(' ', '').toLowerCase();
        final answers = <String>[
          if (answer != null) answer!,
          ...?acceptableAnswers,
        ];
        return answers.any(
          (a) => a.replaceAll(' ', '').toLowerCase() == normalizedUserAnswer,
        );

      case ExerciseType.choice:
        return userAnswer == answerIndex;

      case ExerciseType.matching:
        if (userAnswer is! Map<String, String>) return false;
        if (pairs == null) return false;
        for (final pair in pairs!) {
          if (userAnswer[pair.left] != pair.right) {
            return false;
          }
        }
        return true;
    }
  }

  /// 正解を取得（表示用）
  String get correctAnswer {
    switch (type) {
      case ExerciseType.fillBlank:
      case ExerciseType.typing:
      case ExerciseType.translation:
        return answer ?? '';

      case ExerciseType.choice:
        if (choices != null && answerIndex != null && answerIndex! < choices!.length) {
          return choices![answerIndex!];
        }
        return '';

      case ExerciseType.matching:
        if (pairs == null) return '';
        return pairs!.map((p) => '${p.left} → ${p.right}').join('\n');
    }
  }
}

/// マッチングペア
class MatchingPair {
  const MatchingPair({
    required this.left,
    required this.right,
  });

  final String left;
  final String right;

  factory MatchingPair.fromJson(Map<String, dynamic> json) {
    return MatchingPair(
      left: json['left'] as String? ?? '',
      right: json['right'] as String? ?? '',
    );
  }
}
