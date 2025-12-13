import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/wordbook/domain/providers/bulk_add_words_provider.dart';
import '../app_theme.dart';

/// 単語一括追加の進捗ダイアログ
class BulkAddProgressDialog extends ConsumerWidget {
  const BulkAddProgressDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showFDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context, style, animation) => const BulkAddProgressDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkAddState = ref.watch(bulkAddWordsProvider);
    final theme = Theme.of(context);

    return FDialog(
      title: const Text('単語を追加中'),
      body: bulkAddState.when(
        initial: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
        loading: (total, processed, added, skipped, failed) => _buildProgress(
          context,
          theme,
          total: total,
          processed: processed,
          added: added,
          skipped: skipped,
          failed: failed,
        ),
        success: (added, skipped, failed) => _buildSuccess(
          context,
          theme,
          added: added,
          skipped: skipped,
          failed: failed,
        ),
        error: (message) => _buildError(context, theme, message),
      ),
      actions: _buildActions(context, ref, bulkAddState),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    WidgetRef ref,
    BulkAddState state,
  ) {
    final showCloseButton = state is BulkAddSuccess || state is BulkAddError;
    if (!showCloseButton) return [];

    return [
      FButton(
        style: FButtonStyle.primary(),
        onPress: () {
          ref.read(bulkAddWordsProvider.notifier).reset();
          Navigator.of(context).pop();
        },
        child: const Text('閉じる'),
      ),
    ];
  }

  Widget _buildProgress(
    BuildContext context,
    ThemeData theme, {
    required int total,
    required int processed,
    required int added,
    required int skipped,
    required int failed,
  }) {
    final progress = total > 0 ? processed / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          '処理中: $processed / $total',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(theme, '追加', added, AppColors.success),
            _buildStatItem(theme, 'スキップ', skipped, AppColors.warning),
            if (failed > 0) _buildStatItem(theme, '失敗', failed, AppColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccess(
    BuildContext context,
    ThemeData theme, {
    required int added,
    required int skipped,
    required int failed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          '追加完了',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(theme, '追加', added, AppColors.success),
            _buildStatItem(theme, 'スキップ', skipped, AppColors.warning),
            if (failed > 0) _buildStatItem(theme, '失敗', failed, AppColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, ThemeData theme, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error,
          color: AppColors.error,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          'エラーが発生しました',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          '$value',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
