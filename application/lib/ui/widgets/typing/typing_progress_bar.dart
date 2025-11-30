import 'package:flutter/material.dart';

import '../../app_spacing.dart';

/// タイピング画面用のプログレスバー
class TypingProgressBar extends StatelessWidget {
  const TypingProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.elapsedLabel,
    this.showPercentage = false,
    this.showDivider = true,
    this.progressBarHeight = 8.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
  });

  /// 現在のアイテム番号（0-indexed または 1-indexed）
  final int current;

  /// 総アイテム数
  final int total;

  /// フォーマット済みの経過時間ラベル（例: "01:23" または "01:23.4"）
  final String elapsedLabel;

  /// パーセンテージ表示を使用するか
  final bool showPercentage;

  /// 下部のDividerを表示するか
  final bool showDivider;

  /// プログレスバーの高さ
  final double progressBarHeight;

  /// パディング
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: showPercentage
              ? _buildPercentageLayout(context, theme, progress)
              : _buildSimpleLayout(context, theme, progress),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }

  /// シンプルなレイアウト（TypingPracticeScreen用）
  /// [current / total] [========] [MM:SS]
  Widget _buildSimpleLayout(
    BuildContext context,
    ThemeData theme,
    double progress,
  ) {
    return Row(
      children: [
        Text(
          '$current / $total',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            minHeight: progressBarHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          elapsedLabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// パーセンテージ表示レイアウト（TypingLessonScreen用）
  /// [========]
  /// [進捗 XX% (n/total)]        [MM:SS.t]
  Widget _buildPercentageLayout(
    BuildContext context,
    ThemeData theme,
    double progress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: progressBarHeight,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '進捗 ${(progress * 100).round()}% ($current/$total)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              elapsedLabel,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
