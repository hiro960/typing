import 'dart:math';

import '../models/quick_translation_models.dart';

/// 正解判定サービス
class AnswerCheckerService {
  const AnswerCheckerService();

  /// 回答を正規化
  String normalizeAnswer(String answer) {
    return answer
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // 連続空白を1つに
        .replaceAll('．', '.') // 全角句点を半角に
        .replaceAll('。', '.') // 日本語句点を統一
        .replaceAll('？', '?') // 全角疑問符を半角に
        .replaceAll('！', '!') // 全角感嘆符を半角に
        .toLowerCase(); // 小文字化（英字混在時）
  }

  /// 句読点を除去
  String removePunctuation(String text) {
    return text.replaceAll(RegExp(r'[.?!,、。？！]'), '').trim();
  }

  /// Levenshtein距離を計算
  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final List<List<int>> matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // 削除
          matrix[i][j - 1] + 1, // 挿入
          matrix[i - 1][j - 1] + cost, // 置換
        ].reduce(min);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// 類似度を計算（0.0 〜 1.0）
  double calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty && s2.isEmpty) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final distance = _levenshteinDistance(s1, s2);
    final maxLength = max(s1.length, s2.length);
    return 1.0 - (distance / maxLength);
  }

  /// 回答を判定
  AnswerResult checkAnswer(
    String userAnswer,
    QuickTranslationQuestion question,
  ) {
    if (userAnswer.trim().isEmpty) {
      return AnswerResult.skipped;
    }

    final normalized = normalizeAnswer(userAnswer);
    final correctNormalized = normalizeAnswer(question.korean);

    // 1. 完全一致チェック
    if (normalized == correctNormalized) {
      return AnswerResult.correct;
    }

    // 2. 別解チェック
    for (final alt in question.alternativeAnswers) {
      if (normalized == normalizeAnswer(alt)) {
        return AnswerResult.correct;
      }
    }

    // 3. 句読点を除いて完全一致チェック
    final noPunc = removePunctuation(normalized);
    final correctNoPunc = removePunctuation(correctNormalized);
    if (noPunc == correctNoPunc) {
      return AnswerResult.correct; // 句読点の違いは正解扱い
    }

    // 4. 別解の句読点なしチェック
    for (final alt in question.alternativeAnswers) {
      final altNoPunc = removePunctuation(normalizeAnswer(alt));
      if (noPunc == altNoPunc) {
        return AnswerResult.correct;
      }
    }

    // 5. 類似度チェック（80%以上でほぼ正解）
    final similarity = calculateSimilarity(noPunc, correctNoPunc);
    if (similarity >= 0.8) {
      return AnswerResult.almostCorrect;
    }

    // 6. 別解との類似度チェック
    for (final alt in question.alternativeAnswers) {
      final altNoPunc = removePunctuation(normalizeAnswer(alt));
      if (calculateSimilarity(noPunc, altNoPunc) >= 0.8) {
        return AnswerResult.almostCorrect;
      }
    }

    // 7. 不正解
    return AnswerResult.incorrect;
  }
}
