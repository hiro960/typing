import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/writing/data/models/writing_models.dart';
import '../../../features/writing/domain/providers/writing_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import 'topic_list_screen.dart';

/// パターン選択画面（WritingLane別）
class PatternListScreen extends ConsumerWidget {
  const PatternListScreen({
    super.key,
    required this.lane,
  });

  final WritingLane lane;

  String get _title {
    switch (lane) {
      case WritingLane.topik:
        return 'TOPIK対策';
      case WritingLane.beginner:
        return '単語';
      case WritingLane.travel:
        return '旅行';
      case WritingLane.hobby:
        return '趣味対策';
    }
  }

  String get _subtitle {
    switch (lane) {
      case WritingLane.topik:
        return 'タイピングで覚える論述パターン';
      case WritingLane.beginner:
        return 'カテゴリ別の基本単語をタイピング練習';
      case WritingLane.travel:
        return '韓国旅行で使える実践フレーズ';
      case WritingLane.hobby:
        return 'SNSや韓ドラ、推しなど気軽に書ける題材';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternsAsync = ref.watch(writingPatternsProvider);

    return AppPageScaffold(
      title: _title,
      showBackButton: true,
      childPad: false,
      child: patternsAsync.when(
        data: (allPatterns) {
          final patterns =
              allPatterns.where((p) => p.lane == lane).toList();

          if (patterns.isEmpty) {
            return Center(
              child: Text(
                'パターンがありません',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'パターンを選択',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final pattern = patterns[index];
                      return _PatternCard(pattern: pattern);
                    },
                    childCount: patterns.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'エラーが発生しました: $error',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

/// パターンカード
class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.pattern});

  final WritingPattern pattern;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topicCount = pattern.topics.length;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToTopicList(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  pattern.getIconData(),
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pattern.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$topicCount題材',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTopicList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TopicListScreen(pattern: pattern),
      ),
    );
  }
}
