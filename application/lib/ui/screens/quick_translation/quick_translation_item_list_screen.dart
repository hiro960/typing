import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
import '../../app_theme.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import 'quick_translation_practice_screen.dart';

/// 項目選択画面
class QuickTranslationItemListScreen extends ConsumerStatefulWidget {
  const QuickTranslationItemListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;

  @override
  ConsumerState<QuickTranslationItemListScreen> createState() =>
      _QuickTranslationItemListScreenState();
}

class _QuickTranslationItemListScreenState
    extends ConsumerState<QuickTranslationItemListScreen> {
  PracticeMode _practiceMode = PracticeMode.sequential;
  InputMode _inputMode = InputMode.voice; // デフォルトを音声入力に

  @override
  Widget build(BuildContext context) {
    final itemsAsync =
        ref.watch(availableGrammarItemsProvider(widget.categoryId));

    return AppPageScaffold(
      title: widget.categoryName,
      titleIcon: Iconsax.task_square,
      showBackButton: true,
      child: itemsAsync.when(
        data: (items) => _buildContent(context, items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<AvailableGrammarItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('利用可能な項目がありません'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // モード選択
        _buildModeSelectors(context),
        const SizedBox(height: AppSpacing.lg),

        // セクションヘッダー
        _buildSectionHeader(context, '項目を選んでください（各10問）'),
        const SizedBox(height: AppSpacing.sm),

        // 項目一覧
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _GrammarItemCard(
                item: item,
                onTap: () => _startPractice(item),
              ),
            )),
      ],
    );
  }

  Widget _buildModeSelectors(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 出題モード
        Text(
          '出題モード',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: '順番',
                icon: Iconsax.row_vertical,
                isSelected: _practiceMode == PracticeMode.sequential,
                onTap: () => setState(() => _practiceMode = PracticeMode.sequential),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ModeButton(
                label: 'ランダム',
                icon: Iconsax.shuffle,
                isSelected: _practiceMode == PracticeMode.random,
                onTap: () => setState(() => _practiceMode = PracticeMode.random),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // 入力モード
        Text(
          '入力モード',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: '音声入力',
                icon: Iconsax.microphone,
                isSelected: _inputMode == InputMode.voice,
                onTap: () => setState(() => _inputMode = InputMode.voice),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ModeButton(
                label: '手動モード',
                icon: Iconsax.eye,
                isSelected: _inputMode == InputMode.manual,
                onTap: () => setState(() => _inputMode = InputMode.manual),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.lightBorder.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryBright],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startPractice(AvailableGrammarItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuickTranslationPracticeScreen(
          grammarRef: item.grammarRef,
          practiceMode: _practiceMode,
          inputMode: _inputMode,
        ),
      ),
    );
  }
}

/// モード選択ボタン
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryBright],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected
                ? null
                : isDark
                    ? AppColors.surfaceAlt
                    : AppColors.lightSurfaceAlt,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.6)
                  : isDark
                      ? AppColors.border.withValues(alpha: 0.5)
                      : AppColors.lightBorder,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 文法項目カード
class _GrammarItemCard extends StatelessWidget {
  const _GrammarItemCard({
    required this.item,
    required this.onTap,
  });

  final AvailableGrammarItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = item.isCleared ? AppColors.success : AppColors.primary;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isCleared
                  ? accent.withValues(alpha: 0.35)
                  : isDark
                      ? AppColors.border.withValues(alpha: 0.4)
                      : AppColors.lightBorder.withValues(alpha: 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: item.isCleared ? 0.2 : 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // クリア状況アイコン
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent,
                      accent == AppColors.success
                          ? AppColors.primaryBright
                          : accent.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: item.isCleared
                      ? const Icon(
                          Iconsax.tick_square,
                          size: 18,
                          color: Colors.white,
                        )
                      : Icon(
                          Iconsax.record_circle,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 項目情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.grammarTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.foreground : AppColors.lightForeground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.grammarSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (item.progress != null && item.progress!.bestCorrectCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '最高記録: ${item.progress!.bestCorrectCount}/10',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 矢印
              Icon(
                Iconsax.arrow_right_3,
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
