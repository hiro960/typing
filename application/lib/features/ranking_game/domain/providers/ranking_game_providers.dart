import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:chaletta/core/utils/logger.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/ranking_game/data/repositories/ranking_game_repository.dart';
import 'package:chaletta/features/ranking_game/data/services/word_loader_service.dart';
import 'package:chaletta/features/ranking_game/data/services/offline_queue_service.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';

part 'ranking_game_providers.g.dart';

/// RankingGameRepository プロバイダー
@riverpod
RankingGameRepository rankingGameRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return RankingGameRepository(apiClient: apiClient);
}

/// WordLoaderService プロバイダー
@Riverpod(keepAlive: true)
WordLoaderService wordLoaderService(Ref ref) {
  return WordLoaderService();
}

/// OfflineQueueService プロバイダー
@Riverpod(keepAlive: true)
OfflineQueueService offlineQueueService(Ref ref) {
  return OfflineQueueService();
}

/// ゲーム結果送信プロバイダー（オフライン対応）
@riverpod
class GameResultSubmitter extends _$GameResultSubmitter {
  @override
  AsyncValue<RankingGameResultResponse?> build() {
    return const AsyncData(null);
  }

  /// ゲーム結果を送信（オフライン時はキューに保存）
  Future<RankingGameResultResponse?> submitResult({
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required double avgInputSpeed,
    required int characterLevel,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(rankingGameRepositoryProvider);
      final result = await repository.submitGameResult(
        difficulty: difficulty,
        score: score,
        correctCount: correctCount,
        maxCombo: maxCombo,
        totalBonusTime: totalBonusTime,
        avgInputSpeed: avgInputSpeed,
        characterLevel: characterLevel,
      );

      state = AsyncData(result);
      return result;
    } catch (e) {
      AppLogger.error(
        'Failed to submit result, saving to offline queue',
        tag: 'GameResultSubmitter',
        error: e,
      );

      // オフラインキューに保存
      final offlineQueue = ref.read(offlineQueueServiceProvider);
      final pendingResult = PendingGameResult(
        id: const Uuid().v4(),
        difficulty: difficulty,
        score: score,
        correctCount: correctCount,
        maxCombo: maxCombo,
        totalBonusTime: totalBonusTime,
        avgInputSpeed: avgInputSpeed,
        characterLevel: characterLevel,
        playedAt: DateTime.now(),
      );
      await offlineQueue.enqueue(pendingResult);

      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }

  /// 保留中の結果を同期
  Future<int> syncPendingResults() async {
    final offlineQueue = ref.read(offlineQueueServiceProvider);
    final repository = ref.read(rankingGameRepositoryProvider);
    final pendingResults = await offlineQueue.getPendingResults();

    int syncedCount = 0;

    for (final result in pendingResults) {
      try {
        await repository.submitGameResult(
          difficulty: result.difficulty,
          score: result.score,
          correctCount: result.correctCount,
          maxCombo: result.maxCombo,
          totalBonusTime: result.totalBonusTime,
          avgInputSpeed: result.avgInputSpeed,
          characterLevel: result.characterLevel,
        );

        await offlineQueue.remove(result.id);
        syncedCount++;

        AppLogger.info(
          'Synced pending result: ${result.id}',
          tag: 'GameResultSubmitter',
        );
      } catch (e) {
        AppLogger.error(
          'Failed to sync pending result: ${result.id}',
          tag: 'GameResultSubmitter',
          error: e,
        );
        // 1つ失敗しても他の結果は続ける
      }
    }

    return syncedCount;
  }
}

/// 保留中の結果数プロバイダー
@riverpod
Future<int> pendingResultsCount(Ref ref) async {
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  return offlineQueue.getPendingCount();
}
