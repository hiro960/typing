import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/typing_models.dart';
import 'typing_session_provider.dart';

part 'typing_stats_provider.g.dart';

@riverpod
TypingStatsData typingStats(Ref ref, String lessonId) {
  final sessionValue = ref.watch(typingSessionProvider(lessonId));
  return sessionValue.when(
    data: (session) => _calculateStats(session),
    loading: () => const TypingStatsData(),
    error: (_, __) => const TypingStatsData(),
  );
}

TypingStatsData _calculateStats(TypingSessionState session) {
  // recordsには全入力（正解+ミス）が記録されている
  final totalCount = session.records.length;

  // recordsからミス数をカウント
  final incorrectCount = session.records.where((r) => !r.isCorrect).length;
  final correctCount = totalCount - incorrectCount;

  // 正解率 = (入力文字数 - ミス入力文字数) / 入力文字数
  final accuracy = totalCount == 0 ? 0.0 : correctCount / totalCount;
  final wpm = _calculateWpm(correctCount, session.elapsedMs);

  return TypingStatsData(
    correctCount: correctCount,
    incorrectCount: incorrectCount,
    totalCount: totalCount,
    accuracy: accuracy,
    wpm: wpm,
    elapsedMs: session.elapsedMs,
  );
}

int _calculateWpm(int correctCount, int elapsedMs) {
  if (elapsedMs <= 0) {
    return 0;
  }
  final minutes = elapsedMs / 60000;
  if (minutes == 0) {
    return 0;
  }
  return (correctCount / minutes).round();
}
