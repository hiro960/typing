import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'shimmer_loading.dart';

/// 空状態表示（中央表示）
class PageEmptyView extends StatelessWidget {
  const PageEmptyView({
    super.key,
    required this.title,
    this.icon = Icons.inbox_outlined,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: FButton(
                    onPress: onAction,
                    child: Text(actionLabel!),
                  ),
                ),
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

/// エラー表示（中央表示）
class PageErrorView extends StatelessWidget {
  const PageErrorView({
    super.key,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.title = '読み込みに失敗しました',
    this.message,
    this.retryLabel = '再試行',
  });

  final IconData icon;
  final String title;
  final String? message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Icon(
            icon,
            size: 64,
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Center(
          child: FButton(onPress: onRetry, child: Text(retryLabel)),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

/// ローディング表示（スケルトンビルダー対応）
class PageLoadingView extends StatelessWidget {
  const PageLoadingView({
    super.key,
    this.skeleton,
  });

  final Widget? skeleton;

  @override
  Widget build(BuildContext context) {
    if (skeleton != null) {
      return skeleton!;
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// 汎用スケルトンリスト
class SkeletonListBuilder extends StatelessWidget {
  const SkeletonListBuilder({
    super.key,
    required this.itemBuilder,
    this.itemCount = 6,
    this.separatorHeight = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double separatorHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
