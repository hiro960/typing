import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/hanja/data/models/hanja_character.dart';
import '../../../features/hanja/data/models/hanja_models.dart';
import '../../../features/hanja/domain/providers/hanja_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_error_view.dart';

/// 単漢字詳細画面
class HanjaCharacterDetailScreen extends ConsumerWidget {
  const HanjaCharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(hanjaCharacterDetailProvider(characterId));

    return AppPageScaffold(
      title: '単漢字',
      titleIcon: Iconsax.text,
      showBackButton: true,
      child: characterAsync.when(
        data: (character) {
          if (character == null) {
            return const PageErrorView(
              message: '漢字が見つかりませんでした',
            );
          }
          return _CharacterDetailContent(character: character);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(hanjaCharacterDetailProvider(characterId)),
        ),
      ),
    );
  }
}

class _CharacterDetailContent extends StatelessWidget {
  const _CharacterDetailContent({required this.character});

  final HanjaCharacter character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // メイン漢字表示
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: character.level.color.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  character.character,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // レベルと頻度バッジ
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LevelBadge(level: character.level),
                if (character.frequency != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _FrequencyBadge(frequency: character.frequency!),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 韓国語読み
          _InfoSection(
            title: '韓国語読み',
            icon: Iconsax.microphone,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.korean,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (character.koreanAlt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '異読: ${character.koreanAlt.join(", ")}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 意味
          _InfoSection(
            title: '意味',
            icon: Iconsax.info_circle,
            child: Text(
              character.meaning,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 日本語読み
          if (character.japaneseOn.isNotEmpty ||
              character.japaneseKun.isNotEmpty)
            _InfoSection(
              title: '日本語読み',
              icon: Iconsax.translate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (character.japaneseOn.isNotEmpty) ...[
                    Text(
                      '音読み: ${character.japaneseOn.join(", ")}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (character.japaneseKun.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '訓読み: ${character.japaneseKun.join(", ")}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          if (character.japaneseOn.isNotEmpty ||
              character.japaneseKun.isNotEmpty)
            const SizedBox(height: AppSpacing.lg),

          // 部首・画数
          if (character.radical != null || character.strokeCount != null)
            _InfoSection(
              title: '基本情報',
              icon: Iconsax.textalign_justifyleft,
              child: Row(
                children: [
                  if (character.radical != null)
                    Expanded(
                      child: _InfoTile(
                        label: '部首',
                        value: character.radicalKorean != null
                            ? '${character.radical} (${character.radicalKorean})'
                            : character.radical!,
                      ),
                    ),
                  if (character.strokeCount != null)
                    Expanded(
                      child: _InfoTile(
                        label: '画数',
                        value: '${character.strokeCount}画',
                      ),
                    ),
                ],
              ),
            ),
          if (character.radical != null || character.strokeCount != null)
            const SizedBox(height: AppSpacing.lg),

          // Unicode
          _InfoSection(
            title: 'Unicode',
            icon: Iconsax.code,
            child: Text(
              character.unicode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 関連語
          if (character.relatedWords.isNotEmpty)
            _InfoSection(
              title: '関連語',
              icon: Iconsax.link,
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: character.relatedWords
                    .map((word) => _RelatedWordChip(word: word))
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
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: level.color,
        ),
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
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

/// 関連語チップ
class _RelatedWordChip extends StatelessWidget {
  const _RelatedWordChip({required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        word,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
