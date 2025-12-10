import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
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
      titleIcon: Iconsax.microphone,
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.15),
            Colors.indigo.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Iconsax.microphone,
            size: 48,
            color: Colors.purple,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '日本語を見て韓国語で話そう',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '音声入力または手動モードで練習できます',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToItemList(context),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getCategoryColor().withValues(alpha: isDark ? 0.2 : 0.1),
                _getCategoryColor().withValues(alpha: isDark ? 0.1 : 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // カテゴリアイコン
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(),
                    color: _getCategoryColor(),
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
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${category.clearedCount}クリア',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.green,
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

  Color _getCategoryColor() {
    switch (category.id) {
      case 'orthography':
        return Colors.blue;
      case 'substantive':
        return Colors.teal;
      case 'particle':
        return Colors.purple;
      case 'conjugation':
        return Colors.orange;
      case 'sentence_ending':
        return Colors.pink;
      case 'connective':
        return Colors.indigo;
      case 'adnominal':
        return Colors.cyan;
      case 'tense_aspect':
        return Colors.amber;
      case 'expression':
        return Colors.green;
      case 'quotation':
        return Colors.deepPurple;
      case 'word_formation':
        return Colors.brown;
      default:
        return Colors.grey;
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
        return Iconsax.repeat;
      case 'sentence_ending':
        return Iconsax.message_text;
      case 'connective':
        return Iconsax.convert;
      case 'adnominal':
        return Iconsax.edit;
      case 'tense_aspect':
        return Iconsax.clock;
      case 'expression':
        return Iconsax.lamp_charge;
      case 'quotation':
        return Iconsax.quote_up;
      case 'word_formation':
        return Iconsax.setting_2;
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
