import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

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
      childPad: false,
      header: FHeader.nested(
        title: Row(
          children: [
            Icon(
              pattern.getIconData(),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(pattern.name),
          ],
        ),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
      ),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _TopicCard(
                      topic: topic,
                      patternId: pattern.id,
                    ),
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

/// トピックカード
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              topic.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${topic.entries.where((e) => e.level != EntryLevel.sentence).length}項目',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: FButton(
                    style: FButtonStyle.primary(),
                    onPress: () => _navigateToTypingPractice(context),
                    child: const Text('タイピング練習'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => _navigateToListView(context),
                    child: const Text('一覧で確認'),
                  ),
                ),
              ],
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
