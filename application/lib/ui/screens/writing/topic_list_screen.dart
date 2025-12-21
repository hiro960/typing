import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/writing/data/models/writing_models.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import 'typing_practice_screen.dart';
import 'list_view_screen.dart';

/// トピック選択画面
class TopicListScreen extends ConsumerWidget {
  const TopicListScreen({
    super.key,
    required this.pattern,
  });

  final WritingPattern pattern;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageScaffold(
      title: pattern.name,
      titleIcon: pattern.getIconData(),
      showBackButton: true,
      childPad: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pattern.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'トピックを選択',
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
                  final topic = pattern.topics[index];
                  return _TopicCard(
                    topic: topic,
                    patternId: pattern.id,
                  );
                },
                childCount: pattern.topics.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }
}

/// コンパクトなトピック行
class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.patternId,
  });

  final WritingTopic topic;
  final String patternId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = topic.entries.where((e) => e.level != EntryLevel.sentence).length;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1行目: トピック名 + 項目数 + アクションアイコン
            Row(
              children: [
                Expanded(
                  child: Text(
                    topic.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 項目数
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
                    '$itemCount項',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // タイピング練習ボタン
                _ActionIconButton(
                  icon: Iconsax.keyboard,
                  tooltip: 'タイピング練習',
                  color: theme.colorScheme.primary,
                  onTap: () => _navigateToTypingPractice(context),
                ),
                const SizedBox(width: AppSpacing.xs),
                // 一覧確認ボタン
                _ActionIconButton(
                  icon: Iconsax.task_square,
                  tooltip: '一覧で確認',
                  color: theme.colorScheme.secondary,
                  onTap: () => _navigateToListView(context),
                ),
              ],
            ),
            // 2行目: 説明
            const SizedBox(height: AppSpacing.xs),
            Text(
              topic.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTypingPractice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TypingPracticeScreen(
          patternId: patternId,
          topicId: topic.id,
        ),
      ),
    );
  }

  void _navigateToListView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ListViewScreen(
          patternId: patternId,
          topicId: topic.id,
        ),
      ),
    );
  }
}

/// アクションアイコンボタン
class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
