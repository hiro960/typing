import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_game_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/screens/ranking_leaderboard_screen.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';

/// ホーム画面用ランキングゲームセクション
class RankingGameSection extends ConsumerWidget {
  const RankingGameSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(myRankingStatsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションヘッダー
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.sports_esports,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'ランキングゲーム',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const RankingLeaderboardScreen(),
                  ),
                );
              },
              child: const Text(
                'ランキング →',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
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
          ScoreBasedCharacterWidget(
            score: bestScore,
            pixelSize: 1.5,
            showName: false,
          ),
          const SizedBox(width: 12),
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
    return Column(
      children: [
        _DifficultyCard(
          difficulty: 'beginner',
          label: '初級',
          description: '基本的な単語 / 制限時間 60秒',
          color: const Color(0xFF4CAF50),
          icon: Icons.star_border,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _DifficultyCard(
          difficulty: 'intermediate',
          label: '中級',
          description: '日常会話レベル / 制限時間 90秒',
          color: const Color(0xFFFFEB3B),
          icon: Icons.star_half,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _DifficultyCard(
          difficulty: 'advanced',
          label: '高級',
          description: '上級表現 / 制限時間 120秒',
          color: const Color(0xFFFF5722),
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
