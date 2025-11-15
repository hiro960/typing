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
  final correct = session.records.where((r) => r.isCorrect).length;
  final incorrect = session.records.length - correct;
  final accuracy = session.records.isEmpty
      ? 0.0
      : correct / session.records.length;
  final wpm = _calculateWpm(correct, session.elapsedMs);

  return TypingStatsData(
    correctCount: correct,
    incorrectCount: incorrect,
    totalCount: session.records.length,
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
