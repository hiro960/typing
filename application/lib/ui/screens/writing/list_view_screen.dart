import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/writing/data/models/writing_models.dart';
import '../../../features/writing/domain/providers/writing_providers.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import '../wordbook/word_form_screen.dart';

/// 一覧確認画面
class ListViewScreen extends ConsumerWidget {
  const ListViewScreen({
    super.key,
    required this.patternId,
    required this.topicId,
  });

  final String patternId;
  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicAsync = ref.watch(
      writingTopicProvider((patternId: patternId, topicId: topicId)),
    );

    return topicAsync.when(
      loading: () => const AppPageScaffold(
        title: '一覧確認',
        showBackButton: true,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppPageScaffold(
        title: '一覧確認',
        showBackButton: true,
        child: Center(child: Text('エラーが発生しました: $error')),
      ),
      data: (topic) {
        if (topic == null) {
          return const AppPageScaffold(
            title: '一覧確認',
            showBackButton: true,
            child: Center(child: Text('トピックが見つかりません')),
          );
        }

        return _buildContent(context, topic);
      },
    );
  }

  Widget _buildContent(BuildContext context, WritingTopic topic) {
    return AppPageScaffold(
      title: topic.name,
      showBackButton: true,
      childPad: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Text(
                topic.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final entry = topic.entries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _EntryCard(entry: entry),
                );
              }, childCount: topic.entries.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

/// エントリカード
class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final WritingEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSentence = entry.level == EntryLevel.sentence;

    return Card(
      elevation: isSentence ? 0 : null,
      color: isSentence
          ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildLevelBadge(context, entry.level),
                      if (isSentence) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '(参照のみ)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => _openWordForm(context),
                  icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    foregroundColor: theme.colorScheme.onSecondaryContainer,
                    minimumSize: const Size(24, 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTextRow(
              context: context,
              label: '日本語',
              text: entry.jpText,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildTextRow(
              context: context,
              label: '韓国語',
              text: entry.koText,
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context, EntryLevel level) {
    final (label, color) = switch (level) {
      EntryLevel.template => ('テンプレート', Colors.blue),
      EntryLevel.basic => ('基礎', Colors.green),
      EntryLevel.advanced => ('高級', Colors.orange),
      EntryLevel.sentence => ('例文', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextRow({
    required BuildContext context,
    required String label,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Future<void> _openWordForm(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordFormScreen(
          initialWord: entry.koText,
          initialMeaning: entry.jpText,
        ),
      ),
    );
  }
}
