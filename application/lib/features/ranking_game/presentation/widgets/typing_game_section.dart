import 'package:chaletta/ui/widgets/section_title.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/typing_game_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/typing_leaderboard_screen.dart';

/// ホーム画面用タイピングゲームセクション
class RankingGameSection extends ConsumerWidget {
  const RankingGameSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 軽量版プロバイダーを使用（bestScoreのみ、1クエリで高速）
    final statsAsync = ref.watch(myRankingStatsSummaryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションヘッダー
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle(iconData: Icons.sports_esports, text: 'タイピングゲーム', color: AppColors.primary),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const RankingLeaderboardScreen(),
                  ),
                );
              },
              child: Text(
                'ランキング →',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 12),

        // ベストスコア表示（データがある場合）
        statsAsync.when(
          data: (stats) => _buildBestScoreCard(context, stats.bestScore.all, isDark),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 12),

        // 難易度選択カード
        _buildDifficultyCards(context, isDark),
      ],
    );
  }

  Widget _buildBestScoreCard(BuildContext context, int bestScore, bool isDark) {
    if (bestScore == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(isDark ? 0.2 : 0.15),
            const Color(0xFFFF8C00).withOpacity(isDark ? 0.1 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ベストスコア',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  '$bestScore',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.emoji_events,
            color: Color(0xFFFFD700),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCards(BuildContext context, bool isDark) {
    // _LevelAccordionsと同じ色合いを使用
    return Column(
      children: [
        _DifficultyCard(
          difficulty: 'beginner',
          label: '初級',
          description: '基本的な単語 / 制限時間 60秒',
          color: AppColors.primaryBright,
          icon: Icons.bolt,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _DifficultyCard(
          difficulty: 'intermediate',
          label: '中級',
          description: '日常会話レベル / 制限時間 90秒',
          color: AppColors.secondary,
          icon: Icons.trending_up,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _DifficultyCard(
          difficulty: 'advanced',
          label: '高級',
          description: '上級表現 / 制限時間 120秒',
          color: AppColors.accentEnd,
          icon: Icons.star,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.difficulty,
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
    required this.isDark,
  });

  final String difficulty;
  final String label;
  final String description;
  final Color color;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RankingGameScreen(difficulty: difficulty),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_fill,
              color: color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
