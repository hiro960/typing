import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
import '../../app_theme.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import 'quick_translation_item_list_screen.dart';

/// 瞬間作文ホーム画面（カテゴリ選択）
class QuickTranslationHomeScreen extends ConsumerWidget {
  const QuickTranslationHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(quickTranslationCategoriesProvider);

    return AppPageScaffold(
      title: '瞬間作文',
      titleIcon: Iconsax.flash_1,
      showBackButton: true,
      child: categoriesAsync.when(
        data: (categories) => _buildCategoryList(context, categories),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<QuickTranslationCategory> categories,
  ) {
    if (categories.isEmpty) {
      return const Center(
        child: Text('利用可能なカテゴリがありません'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // ヘッダー説明
        _buildHeader(context),
        const SizedBox(height: AppSpacing.lg),

        // カテゴリカード一覧
        ...categories.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _CategoryCard(category: category),
            )),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surface, AppColors.background]
              : [
                  AppColors.primary.withValues(alpha: 0.14),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.lightBorder.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryBright],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Iconsax.flash_1,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '日本語を見て韓国語で話そう',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.foreground : AppColors.lightForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '音声入力または手動モードで練習できます',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

/// カテゴリカード
class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.category});

  final QuickTranslationCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradient = _getCategoryGradient();
    final accent = gradient.first;

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToItemList(context),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: gradient
                  .map(
                    (c) => c.withValues(alpha: isDark ? 0.28 : 0.16),
                  )
                  .toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.35 : 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // カテゴリアイコン
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.9),
                      gradient.last.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // カテゴリ情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // 進捗表示
                    Row(
                      children: [
                        Text(
                          '${category.itemCount}項目',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                        if (category.clearedCount > 0) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              '${category.clearedCount}クリア',
                              style: TextStyle(
                                fontSize: 10,
                                color: accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // 矢印
              Icon(
                Iconsax.arrow_right_3,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getCategoryGradient() {
    switch (category.id) {
      case 'orthography':
        return FeatureGradients.kanadara;
      case 'substantive':
        return FeatureGradients.quickTranslation;
      case 'particle':
        return FeatureGradients.writing;
      case 'conjugation':
        return FeatureGradients.typing;
      case 'sentence_ending':
        return FeatureGradients.pronunciation;
      case 'connective':
        return FeatureGradients.hanjaQuiz;
      case 'adnominal':
        return FeatureGradients.grammar;
      case 'tense_aspect':
        return FeatureGradients.hanjaDictionary;
      case 'expression':
        return FeatureGradients.pronunciation;
      case 'quotation':
        return FeatureGradients.typing;
      case 'word_formation':
        return FeatureGradients.grammar;
      default:
        return const [AppColors.primary, AppColors.primaryBright];
    }
  }

  IconData _getCategoryIcon() {
    switch (category.id) {
      case 'orthography':
        return Iconsax.text;
      case 'substantive':
        return Iconsax.category;
      case 'particle':
        return Iconsax.link;
      case 'conjugation':
        return Iconsax.convert;
      case 'sentence_ending':
        return Iconsax.message;
      case 'connective':
        return Iconsax.arrow_swap_horizontal;
      case 'adnominal':
        return Iconsax.edit_2;
      case 'tense_aspect':
        return Iconsax.clock;
      case 'expression':
        return Iconsax.lamp_charge;
      case 'quotation':
        return Iconsax.quote_up;
      case 'word_formation':
        return Iconsax.setting_3;
      default:
        return Iconsax.book;
    }
  }

  void _navigateToItemList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuickTranslationItemListScreen(
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
    );
  }
}
