import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
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
                return _EntryCard(entry: entry);
              }, childCount: topic.entries.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    );
  }
}

/// コンパクトなエントリ行
class _EntryCard extends ConsumerWidget {
  const _EntryCard({required this.entry});

  final WritingEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSentence = entry.level == EntryLevel.sentence;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1行目: バッジ + 日本語 + アクション
            Row(
              children: [
                _buildLevelBadge(context, entry.level),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    entry.jpText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSentence
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                // 再生ボタン
                GestureDetector(
                  onTap: () {
                    ref.read(wordAudioServiceProvider.notifier).speak(entry.koText);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      Icons.volume_up_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                // 単語帳追加ボタン
                GestureDetector(
                  onTap: () => _openWordForm(context),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      size: 20,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            // 2行目: 韓国語（インデント付き）
            Padding(
              padding: const EdgeInsets.only(
                left: 52, // バッジ幅 + 余白に合わせる
                top: AppSpacing.xs,
              ),
              child: Text(
                entry.koText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context, EntryLevel level) {
    final (label, color) = switch (level) {
      EntryLevel.template => ('型', Colors.blue),
      EntryLevel.basic => ('基', Colors.green),
      EntryLevel.advanced => ('高', Colors.orange),
      EntryLevel.sentence => ('例', Colors.grey),
    };

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
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
