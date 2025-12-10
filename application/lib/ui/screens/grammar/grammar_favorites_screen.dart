import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/grammar/data/models/grammar_favorite.dart';
import '../../../features/grammar/data/models/grammar_index.dart';
import '../../../features/grammar/data/models/grammar_models.dart';
import '../../../features/grammar/domain/providers/grammar_providers.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_empty_view.dart';
import '../../widgets/page_error_view.dart';
import 'grammar_detail_screen.dart';

/// お気に入り文法一覧画面
class GrammarFavoritesScreen extends ConsumerWidget {
  const GrammarFavoritesScreen({super.key});

  void _navigateToDetail(BuildContext context, String grammarId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GrammarDetailScreen(grammarId: grammarId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(grammarFavoritesProvider);
    final indexAsync = ref.watch(grammarIndexProvider);

    return AppPageScaffold(
      title: 'お気に入り文法',
      titleIcon: Iconsax.heart,
      showBackButton: true,
      child: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const PageEmptyView(
              icon: Iconsax.heart,
              title: 'お気に入りがありません',
              description: '文法詳細画面でハートをタップすると\nお気に入りに追加できます',
            );
          }

          return indexAsync.when(
            data: (index) {
              final items = _buildFavoriteItems(favorites, index);

              if (items.isEmpty) {
                return const PageEmptyView(
                  icon: Iconsax.heart,
                  title: 'お気に入りがありません',
                  description: '文法詳細画面でハートをタップすると\nお気に入りに追加できます',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _FavoriteGrammarTile(
                    meta: item.meta,
                    favorite: item.favorite,
                    onTap: () => _navigateToDetail(context, item.meta.id),
                    onRemove: () => ref
                        .read(grammarFavoritesProvider.notifier)
                        .remove(item.meta.id),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => PageErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(grammarIndexProvider),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(grammarFavoritesProvider),
        ),
      ),
    );
  }

  List<_FavoriteItem> _buildFavoriteItems(
    List<GrammarFavorite> favorites,
    GrammarIndex index,
  ) {
    final items = <_FavoriteItem>[];
    for (final favorite in favorites) {
      final meta = index.findGrammarMeta(favorite.grammarId);
      if (meta != null) {
        items.add(_FavoriteItem(meta: meta, favorite: favorite));
      }
    }
    // 追加日時の降順でソート
    items.sort((a, b) => b.favorite.addedAt.compareTo(a.favorite.addedAt));
    return items;
  }
}

class _FavoriteItem {
  const _FavoriteItem({required this.meta, required this.favorite});
  final GrammarMeta meta;
  final GrammarFavorite favorite;
}

/// お気に入り文法タイル
class _FavoriteGrammarTile extends StatelessWidget {
  const _FavoriteGrammarTile({
    required this.meta,
    required this.favorite,
    required this.onTap,
    required this.onRemove,
  });

  final GrammarMeta meta;
  final GrammarFavorite favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(meta.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // レベルインジケーター
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: meta.level.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // メインコンテンツ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          meta.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _LevelBadge(level: meta.level),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          meta.category.icon,
                          size: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          meta.category.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(favorite.addedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // 削除ボタン
              IconButton(
                icon: const Icon(Iconsax.heart, color: Colors.red),
                onPressed: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

/// レベルバッジ
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final GrammarLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: level.color,
        ),
      ),
    );
  }
}
