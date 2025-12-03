import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/pronunciation_game/domain/providers/pronunciation_game_providers.dart';

part 'pronunciation_ranking_providers.g.dart';

/// ランキングデータプロバイダー
@riverpod
Future<PronunciationRankingDataResponse> pronunciationRankingData(
  Ref ref, {
  String difficulty = 'all',
  String period = 'monthly',
  bool followingOnly = false,
}) async {
  final repository = ref.watch(pronunciationGameRepositoryProvider);
  return repository.getRanking(
    difficulty: difficulty,
    period: period,
    followingOnly: followingOnly,
  );
}

/// 自分の統計プロバイダー（詳細版・ランキング画面用）
@riverpod
Future<PronunciationGameUserStats> myPronunciationStats(Ref ref) async {
  final repository = ref.watch(pronunciationGameRepositoryProvider);
  return repository.getMyStats();
}

/// 自分の統計プロバイダー（軽量版・ホーム画面用）
@riverpod
Future<PronunciationGameStatsSummary> myPronunciationStatsSummary(Ref ref) async {
  final repository = ref.watch(pronunciationGameRepositoryProvider);
  return repository.getMyStatsSummary();
}

/// 難易度別ベストスコアプロバイダー
@riverpod
Future<Map<String, int>> pronunciationBestScores(Ref ref) async {
  final stats = await ref.watch(myPronunciationStatsProvider.future);
  return {
    'all': stats.bestScore.all,
    'beginner': stats.bestScore.beginner,
    'intermediate': stats.bestScore.intermediate,
    'advanced': stats.bestScore.advanced,
  };
}
