import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/hanja_quiz/data/models/hanja_quiz_models.dart';
import '../../../features/hanja_quiz/domain/providers/hanja_quiz_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import 'hanja_quiz_start_screen.dart';

/// 漢字語クイズ結果画面
class HanjaQuizResultScreen extends ConsumerWidget {
  const HanjaQuizResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final quizNotifier = ref.watch(hanjaQuizProvider.notifier);
    final resultSummary = quizNotifier.getResultSummary();

    if (resultSummary == null) {
      return AppPageScaffold(
        title: '結果',
        showBackButton: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('結果がありません'),
              const SizedBox(height: AppSpacing.md),
              FButton(
                onPress: () => _navigateToStart(context, ref),
                child: const Text('スタート画面へ'),
              ),
            ],
          ),
        ),
      );
    }

    return AppPageScaffold(
      title: '結果',
      showBackButton: false,
      child: SafeArea(
        child: Column(
          children: [
            // スコアセクション
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // 正解数
                  Text(
                    '${resultSummary.correctCount} / ${resultSummary.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '正答率: ${resultSummary.accuracyPercent}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 評価
                  _ResultBadge(accuracy: resultSummary.accuracy),
                ],
              ),
            ),

            // 学習した単語一覧
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.task_square,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '学習した単語',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 単語リスト
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: resultSummary.answerHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final record = resultSummary.answerHistory[index];
                  return _WordResultCard(
                    record: record,
                    onMarkAsMastered: () {
                      ref
                          .read(masteredWordsProvider.notifier)
                          .markAsMastered(record.word.id);
                    },
                  );
                },
              ),
            ),

            // ボタン
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.secondary(),
                      onPress: () => _navigateToHome(context, ref),
                      child: const Text('ホームへ'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.primary(),
                      onPress: () => _navigateToStart(context, ref),
                      child: const Text('もう一度'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStart(BuildContext context, WidgetRef ref) {
    ref.read(hanjaQuizProvider.notifier).resetGame();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HanjaQuizStartScreen(),
      ),
    );
  }

  void _navigateToHome(BuildContext context, WidgetRef ref) {
    ref.read(hanjaQuizProvider.notifier).resetGame();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

/// 結果バッジ
class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.accuracy});

  final double accuracy;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _getResultInfo();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  (String, Color, IconData) _getResultInfo() {
    if (accuracy >= 0.9) {
      return ('素晴らしい！', AppColors.success, Iconsax.star);
    } else if (accuracy >= 0.7) {
      return ('よくできました！', Colors.orange, Iconsax.like_1);
    } else if (accuracy >= 0.5) {
      return ('もう少し！', Colors.amber, Iconsax.trend_up);
    } else {
      return ('頑張りましょう！', AppColors.error, Iconsax.refresh);
    }
  }
}

/// 単語結果カード
class _WordResultCard extends ConsumerWidget {
  const _WordResultCard({
    required this.record,
    required this.onMarkAsMastered,
  });

  final QuizAnswerRecord record;
  final VoidCallback onMarkAsMastered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final masteredIdsAsync = ref.watch(masteredWordsProvider);
    final isMastered = masteredIdsAsync.maybeWhen(
      data: (ids) => ids.contains(record.word.id),
      orElse: () => record.isMastered,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // 正解/不正解アイコン
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: record.isCorrect
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                record.isCorrect ? Iconsax.tick_square : Iconsax.close_circle,
                size: 18,
                color: record.isCorrect ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // 単語情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        record.word.hanja,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        record.word.word,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    record.word.meaning,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // 覚えたボタン
            if (isMastered)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.tick_circle,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '済',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              )
            else
              FButton(
                style: FButtonStyle.ghost(),
                onPress: onMarkAsMastered,
                child: const Text(
                  '覚えた',
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
