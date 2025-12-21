import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/wordbook/data/models/word_model.dart';
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

/// エントリ行（文字・ボタンを大きく）
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
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1行目: バッジ + 日本語 + アクション
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLevelBadge(context, entry.level),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    entry.jpText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isSentence
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                // 単語帳追加ボタン
                _ActionButton(
                  icon: Iconsax.bookmark_2,
                  color: theme.colorScheme.secondary,
                  onTap: () => _openWordForm(context),
                ),
                const SizedBox(width: AppSpacing.xs),
                // 再生ボタン
                _ActionButton(
                  icon: Iconsax.volume_high,
                  color: theme.colorScheme.primary,
                  onTap: () {
                    ref.read(wordAudioServiceProvider.notifier).speak(entry.koText);
                  },
                ),
              ],
            ),
            // 2行目: 韓国語（インデント付き）
            Padding(
              padding: const EdgeInsets.only(
                left: 44, // バッジ幅 + 余白に合わせる
                top: AppSpacing.sm,
              ),
              child: Text(
                entry.koText,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
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
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
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
          initialCategory: WordCategory.WORDS,
        ),
      ),
    );
  }
}

/// 押しやすいアクションボタン
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
      ),
    );
  }
}
