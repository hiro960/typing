import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/hanja_quiz/data/models/hanja_quiz_models.dart';
import '../../../features/hanja_quiz/domain/providers/hanja_quiz_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import 'hanja_quiz_screen.dart';
import 'mastered_words_screen.dart';

/// 漢字語クイズ開始画面
class HanjaQuizStartScreen extends ConsumerWidget {
  const HanjaQuizStartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final masteredCountAsync = ref.watch(masteredWordsCountProvider);
    final totalCountAsync = ref.watch(totalWordsCountProvider);
    final availableWordsAsync = ref.watch(availableQuizWordsProvider);

    return AppPageScaffold(
      title: '漢字語クイズ',
      showBackButton: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // タイトルセクション
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          '漢',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '漢字の韓国語読みを当てよう',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // 問題数選択
              Text(
                '問題数を選んでください',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // 問題数ボタン
              availableWordsAsync.when(
                data: (availableWords) {
                  final availableCount = availableWords.length;
                  return Column(
                    children: QuizQuestionCount.values.map((count) {
                      final isEnabled = availableCount >= count.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _QuestionCountButton(
                          count: count,
                          isEnabled: isEnabled,
                          availableCount: availableCount,
                          onPressed: isEnabled
                              ? () => _startQuiz(context, ref, count)
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const Text('エラーが発生しました'),
              ),

              const Spacer(),

              // 覚えた漢字語の統計
              Card(
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openMasteredWords(context),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '覚えた漢字語',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              masteredCountAsync.when(
                                data: (masteredCount) => totalCountAsync.when(
                                  data: (totalCount) => Text(
                                    '$masteredCount / $totalCount',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  loading: () => const Text('...'),
                                  error: (_, __) => const Text('-'),
                                ),
                                loading: () => const Text('...'),
                                error: (_, __) => const Text('-'),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuiz(
    BuildContext context,
    WidgetRef ref,
    QuizQuestionCount count,
  ) async {
    await ref.read(hanjaQuizProvider.notifier).startGame(count);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const HanjaQuizScreen(),
        ),
      );
    }
  }

  void _openMasteredWords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MasteredWordsScreen(),
      ),
    );
  }
}

class _QuestionCountButton extends StatelessWidget {
  const _QuestionCountButton({
    required this.count,
    required this.isEnabled,
    required this.availableCount,
    this.onPressed,
  });

  final QuizQuestionCount count;
  final bool isEnabled;
  final int availableCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: FButton(
        style: isEnabled ? FButtonStyle.primary() : FButtonStyle.secondary(),
        onPress: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isEnabled
                    ? null
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            if (!isEnabled) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                '(${availableCount}問のみ出題可能)',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
