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
  // recordsには正解文字のみが記録されている
  final correctCount = session.records.length;

  // mistakeHistoryから誤答の総数を計算
  final incorrectCount = session.mistakeHistory.values.fold<int>(
    0,
    (sum, count) => sum + count,
  );

  final totalCount = correctCount + incorrectCount;
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
