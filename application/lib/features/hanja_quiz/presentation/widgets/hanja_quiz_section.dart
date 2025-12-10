import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../../../ui/widgets/section_title.dart';
import '../../../../ui/screens/hanja_quiz/hanja_quiz_start_screen.dart';
import '../../../../ui/screens/hanja_quiz/mastered_words_screen.dart';
import '../../domain/providers/hanja_quiz_providers.dart';

/// ホーム画面用漢字語クイズセクション
class HanjaQuizSection extends ConsumerWidget {
  const HanjaQuizSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final masteredCountAsync = ref.watch(masteredWordsCountProvider);
    final totalCountAsync = ref.watch(totalWordsCountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // セクションヘッダー
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(
              iconData: Iconsax.receipt_text,
              text: '漢字語クイズ',
              color: Colors.orange,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const MasteredWordsScreen(),
                  ),
                );
              },
              child: Text(
                '覚えた一覧 →',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        // 習得状況表示
        masteredCountAsync.when(
          data: (masteredCount) => totalCountAsync.when(
            data: (totalCount) => _buildProgressCard(
              context,
              masteredCount,
              totalCount,
              isDark,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 12),

        // プレイカード
        _buildPlayCard(context, isDark),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    int masteredCount,
    int totalCount,
    bool isDark,
  ) {
    if (masteredCount == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final progress = totalCount > 0 ? masteredCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: isDark ? 0.2 : 0.15),
            Colors.teal.withValues(alpha: isDark ? 0.1 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '習得済み',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$masteredCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ' / $totalCount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Iconsax.tick_circle,
            color: Colors.green,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const HanjaQuizStartScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '漢',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '漢字語クイズ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '漢字の韓国語読みを1文字ずつ選択',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Iconsax.play_circle,
              color: Colors.orange,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
