import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/core/utils/logger.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/pronunciation_game/data/repositories/pronunciation_game_repository.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';

part 'pronunciation_game_providers.g.dart';

/// PronunciationGameRepository プロバイダー
@riverpod
PronunciationGameRepository pronunciationGameRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return PronunciationGameRepository(apiClient: apiClient);
}

/// ゲーム結果送信プロバイダー
@riverpod
class PronunciationGameResultSubmitter extends _$PronunciationGameResultSubmitter {
  @override
  AsyncValue<PronunciationGameResultResponse?> build() {
    return const AsyncData(null);
  }

  /// ゲーム結果を送信
  Future<PronunciationGameResultResponse?> submitResult({
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required int characterLevel,
    int? timeSpent,
    double? accuracy,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(pronunciationGameRepositoryProvider);
      final result = await repository.submitGameResult(
        difficulty: difficulty,
        score: score,
        correctCount: correctCount,
        maxCombo: maxCombo,
        totalBonusTime: totalBonusTime,
        characterLevel: characterLevel,
        timeSpent: timeSpent,
        accuracy: accuracy,
      );

      if (!ref.mounted) {
        AppLogger.warning(
          'Provider was disposed after API call succeeded. Result: $result',
          tag: 'PronunciationGameResultSubmitter',
        );
        return result;
      }

      state = AsyncData(result);
      return result;
    } catch (e) {
      AppLogger.error(
        'Failed to submit result',
        tag: 'PronunciationGameResultSubmitter',
        error: e,
      );

      if (!ref.mounted) rethrow;

      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}
