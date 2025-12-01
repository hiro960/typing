import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_game_providers.dart';

part 'ranking_providers.g.dart';

/// ランキングデータプロバイダー
@riverpod
Future<RankingDataResponse> rankingData(
  Ref ref, {
  String difficulty = 'all',
  String period = 'monthly',
  bool followingOnly = false,
}) async {
  final repository = ref.watch(rankingGameRepositoryProvider);
  return repository.getRanking(
    difficulty: difficulty,
    period: period,
    followingOnly: followingOnly,
  );
}

/// 自分の統計プロバイダー（詳細版・ランキング画面用）
@riverpod
Future<RankingGameUserStats> myRankingStats(Ref ref) async {
  final repository = ref.watch(rankingGameRepositoryProvider);
  return repository.getMyStats();
}

/// 自分の統計プロバイダー（軽量版・ホーム画面用）
/// bestScoreのみを高速に取得
@riverpod
Future<RankingGameStatsSummary> myRankingStatsSummary(Ref ref) async {
  final repository = ref.watch(rankingGameRepositoryProvider);
  return repository.getMyStatsSummary();
}

/// 難易度別ベストスコアプロバイダー
@riverpod
Future<Map<String, int>> bestScores(Ref ref) async {
  final stats = await ref.watch(myRankingStatsProvider.future);
  return {
    'all': stats.bestScore.all,
    'beginner': stats.bestScore.beginner,
    'intermediate': stats.bestScore.intermediate,
    'advanced': stats.bestScore.advanced,
  };
}
