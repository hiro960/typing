import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/hanja/data/models/hanja_models.dart';
import '../../../features/hanja/data/models/hanja_word.dart';
import '../../../features/hanja/domain/providers/hanja_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_error_view.dart';
import 'hanja_character_detail_screen.dart';

/// 漢字語詳細画面
class HanjaWordDetailScreen extends ConsumerWidget {
  const HanjaWordDetailScreen({
    super.key,
    required this.wordId,
  });

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordAsync = ref.watch(hanjaWordDetailProvider(wordId));

    return AppPageScaffold(
      title: '漢字語',
      titleIcon: Icons.library_books,
      showBackButton: true,
      child: wordAsync.when(
        data: (word) {
          if (word == null) {
            return const PageErrorView(
              message: '漢字語が見つかりませんでした',
            );
          }
          return _WordDetailContent(word: word);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(hanjaWordDetailProvider(wordId)),
        ),
      ),
    );
  }
}

class _WordDetailContent extends StatelessWidget {
  const _WordDetailContent({required this.word});

  final HanjaWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // メイン表示
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: word.level.color.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // ハングル
                Text(
                  word.word,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // 漢字
                Text(
                  word.hanja,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // バッジ
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LevelBadge(level: word.level),
                    const SizedBox(width: AppSpacing.sm),
                    _CategoryBadge(category: word.category),
                    if (word.frequency != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      _FrequencyBadge(frequency: word.frequency!),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 意味
          _InfoSection(
            title: '意味',
            icon: Icons.info_outline,
            child: Text(
              word.meaning,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 発音・品詞
          _InfoSection(
            title: '基本情報',
            icon: Icons.format_list_numbered,
            child: Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    label: '発音',
                    value: word.pronunciation,
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    label: '品詞',
                    value: word.partOfSpeech,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 構成漢字
          if (word.components.isNotEmpty)
            _InfoSection(
              title: '構成漢字',
              icon: Icons.dashboard,
              child: _ComponentsView(components: word.components),
            ),
          if (word.components.isNotEmpty) const SizedBox(height: AppSpacing.lg),

          // 例文
          if (word.examples.isNotEmpty)
            _InfoSection(
              title: '例文',
              icon: Icons.format_quote,
              child: Column(
                children: word.examples
                    .map((example) => _ExampleTile(example: example))
                    .toList(),
              ),
            ),
          if (word.examples.isNotEmpty) const SizedBox(height: AppSpacing.lg),

          // 類義語
          if (word.synonyms.isNotEmpty)
            _InfoSection(
              title: '類義語',
              icon: Icons.compare_arrows,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: word.synonyms
                    .map((w) => _RelatedWordChip(word: w))
                    .toList(),
              ),
            ),
          if (word.synonyms.isNotEmpty) const SizedBox(height: AppSpacing.lg),

          // 対義語
          if (word.antonyms.isNotEmpty)
            _InfoSection(
              title: '対義語',
              icon: Icons.swap_horiz,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: word.antonyms
                    .map((w) => _RelatedWordChip(word: w, isAntonym: true))
                    .toList(),
              ),
            ),
          if (word.antonyms.isNotEmpty) const SizedBox(height: AppSpacing.lg),

          // 関連語
          if (word.relatedWords.isNotEmpty)
            _InfoSection(
              title: '関連語',
              icon: Icons.link,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: word.relatedWords
                    .map((w) => _RelatedWordChip(word: w))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

/// 情報セクション
class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// 情報タイル
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// 構成漢字ビュー
class _ComponentsView extends StatelessWidget {
  const _ComponentsView({required this.components});

  final List<HanjaComponent> components;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: components
          .map((component) => _ComponentTile(component: component))
          .toList(),
    );
  }
}

/// 構成漢字タイル
class _ComponentTile extends ConsumerWidget {
  const _ComponentTile({required this.component});

  final HanjaComponent component;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        // 漢字から詳細画面へ遷移
        final characterAsync =
            await ref.read(hanjaCharacterByCharProvider(component.character).future);
        if (characterAsync != null && context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  HanjaCharacterDetailScreen(characterId: characterAsync.id),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Text(
              component.character,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              component.korean,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              component.meaning,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 例文タイル
class _ExampleTile extends StatelessWidget {
  const _ExampleTile({required this.example});

  final HanjaExample example;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.sentence,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            example.meaning,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// レベルバッジ
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final HanjaLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: level.color,
        ),
      ),
    );
  }
}

/// カテゴリバッジ
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final HanjaWordCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 頻度バッジ
class _FrequencyBadge extends StatelessWidget {
  const _FrequencyBadge({required this.frequency});

  final HanjaFrequency frequency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        frequency.label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

/// 関連語チップ
class _RelatedWordChip extends StatelessWidget {
  const _RelatedWordChip({
    required this.word,
    this.isAntonym = false,
  });

  final String word;
  final bool isAntonym;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAntonym
            ? Colors.red.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAntonym
              ? Colors.red.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        word,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isAntonym ? Colors.red : null,
        ),
      ),
    );
  }
}
