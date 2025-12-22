import 'package:chaletta/ui/widgets/section_title.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:chaletta/core/services/sound_service.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/pronunciation_game/domain/providers/pronunciation_ranking_providers.dart';
import 'package:chaletta/features/pronunciation_game/presentation/screens/pronunciation_game_screen.dart';
import 'package:chaletta/features/pronunciation_game/presentation/screens/pronunciation_ranking_screen.dart';

/// ホーム画面用発音ゲームセクション
class PronunciationGameSection extends ConsumerStatefulWidget {
  const PronunciationGameSection({super.key});

  @override
  ConsumerState<PronunciationGameSection> createState() =>
      _PronunciationGameSectionState();
}

class _PronunciationGameSectionState
    extends ConsumerState<PronunciationGameSection> {
  @override
  void initState() {
    super.initState();
    // ホーム画面で発音ゲームセクションが表示されたら、サウンドを事前に初期化
    // これにより、ゲーム開始時の音声遅延を軽減
    _preloadSounds();
  }

  Future<void> _preloadSounds() async {
    final soundService = ref.read(soundServiceProvider);
    if (!soundService.isInitialized) {
      await soundService.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(myPronunciationStatsSummaryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションヘッダー
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle(
              iconData: Iconsax.microphone,
              text: '発音ゲーム',
              color: AppColors.accentEnd,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PronunciationRankingScreen(),
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

        // ベストスコア表示（データがある場合）
        statsAsync.when(
          data: (stats) =>
              _buildBestScoreCard(context, stats.bestScore.all, isDark),
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
                  '発音ベストスコア',
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
            Iconsax.microphone_2,
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
        _PronunciationDifficultyCard(
          difficulty: 'beginner',
          label: '初級',
          description: '基本的な単語 / 制限時間 30秒',
          color: AppColors.primaryBright,
          icon: Iconsax.microphone,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _PronunciationDifficultyCard(
          difficulty: 'intermediate',
          label: '中級',
          description: '日常会話レベル / 制限時間 45秒',
          color: AppColors.secondary,
          icon: Iconsax.microphone,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _PronunciationDifficultyCard(
          difficulty: 'advanced',
          label: '高級',
          description: '上級表現 / 制限時間 60秒',
          color: AppColors.accentEnd,
          icon: Iconsax.microphone_2,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _PronunciationDifficultyCard extends StatelessWidget {
  const _PronunciationDifficultyCard({
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

  void _startNormalGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PronunciationGameScreen(
          config: PronunciationGameConfig(difficulty: difficulty),
        ),
      ),
    );
  }

  void _showPracticeOptions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Iconsax.book_1, color: color, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '練習モード',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '時間無制限で練習できます（ランキング対象外）',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '問題数を選択',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuestionCountButton(context, 10),
                  _buildQuestionCountButton(context, 20),
                  _buildQuestionCountButton(context, 30),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCountButton(BuildContext context, int count) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // ボトムシートを閉じる
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PronunciationGameScreen(
              config: PronunciationGameConfig(
                difficulty: difficulty,
                isPracticeMode: true,
                targetQuestionCount: count,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          '$count問',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          // 練習ボタン
          GestureDetector(
            onTap: () => _showPracticeOptions(context),
            child: Tooltip(
              message: '練習モード',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.book_1,
                  color: color.withOpacity(0.7),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 通常プレイボタン
          GestureDetector(
            onTap: () => _startNormalGame(context),
            child: Icon(
              Iconsax.play_circle,
              color: color,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
