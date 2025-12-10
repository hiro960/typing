import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/hanja/data/models/hanja_word.dart';
import '../../../features/hanja/domain/providers/hanja_providers.dart';
import '../../../features/hanja_quiz/domain/providers/hanja_quiz_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';

/// 覚えた漢字語一覧画面
class MasteredWordsScreen extends ConsumerWidget {
  const MasteredWordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final masteredIdsAsync = ref.watch(masteredWordsProvider);
    final allWordsAsync = ref.watch(allHanjaWordsProvider);

    return AppPageScaffold(
      title: '覚えた漢字語',
      showBackButton: true,
      child: masteredIdsAsync.when(
        data: (masteredIds) => allWordsAsync.when(
          data: (allWords) {
            // 覚えた単語のみをフィルタリング
            final masteredWords = allWords
                .where((w) => masteredIds.contains(w.id))
                .toList();

            if (masteredWords.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.emoji_happy,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      '覚えた漢字語はまだありません',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'クイズで正解して「覚えた」を押すと\nここに追加されます',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // ヘッダー
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.tick_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${masteredWords.length}個の漢字語を習得',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // リスト
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: masteredWords.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final word = masteredWords[index];
                      return _MasteredWordCard(
                        word: word,
                        onRemove: () {
                          _showRemoveConfirmDialog(context, ref, word);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('エラーが発生しました')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('エラーが発生しました')),
      ),
    );
  }

  void _showRemoveConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    HanjaWord word,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => FDialog(
        title: const Text('覚えた記録を解除'),
        body: Text('「${word.hanja}（${word.word}）」の覚えた記録を解除しますか？\n\n解除すると、再びクイズに出題されるようになります。'),
        actions: [
          FButton(
            style: FButtonStyle.ghost(),
            onPress: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () {
              ref.read(masteredWordsProvider.notifier).unmarkAsMastered(word.id);
              Navigator.of(context).pop();
            },
            child: const Text('解除'),
          ),
        ],
      ),
    );
  }
}

/// 覚えた漢字語カード
class _MasteredWordCard extends StatelessWidget {
  const _MasteredWordCard({
    required this.word,
    required this.onRemove,
  });

  final HanjaWord word;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // 漢字アイコン
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  word.hanja.isNotEmpty ? word.hanja[0] : '漢',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
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
                        word.hanja,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        word.word,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    word.meaning,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // 削除ボタン
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Iconsax.minus_cirlce,
                color: theme.colorScheme.error,
              ),
              tooltip: '覚えた記録を解除',
            ),
          ],
        ),
      ),
    );
  }
}
