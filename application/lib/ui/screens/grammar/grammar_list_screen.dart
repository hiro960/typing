import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/grammar/data/models/grammar_index.dart';
import '../../../features/grammar/data/models/grammar_models.dart';
import '../../../features/grammar/domain/providers/grammar_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_empty_view.dart';
import '../../widgets/page_error_view.dart';
import 'grammar_detail_screen.dart';
import 'grammar_favorites_screen.dart';

/// 文法辞典一覧画面
class GrammarListScreen extends ConsumerStatefulWidget {
  const GrammarListScreen({super.key});

  @override
  ConsumerState<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends ConsumerState<GrammarListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // 「全て」+ カテゴリ数
    _tabController = TabController(
      length: GrammarCategory.values.length + 1,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final index = _tabController.index;
      if (index == 0) {
        ref.read(grammarFilterProvider.notifier).setCategory(null);
      } else {
        final category = GrammarCategory.values[index - 1];
        ref.read(grammarFilterProvider.notifier).setCategory(category);
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(grammarFilterProvider.notifier).setSearchQuery(query);
    });
  }

  void _navigateToDetail(String grammarId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GrammarDetailScreen(grammarId: grammarId),
      ),
    );
  }

  void _navigateToFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const GrammarFavoritesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: '文法辞典',
      titleIcon: Iconsax.book,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Iconsax.heart),
          onPressed: _navigateToFavorites,
          tooltip: 'お気に入り',
        ),
      ],
      child: Column(
        children: [
          // 検索バー
          _SearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          // レベルフィルター
          const _LevelFilterChips(),
          const SizedBox(height: AppSpacing.sm),
          // カテゴリタブ
          _CategoryTabBar(controller: _tabController),
          const SizedBox(height: AppSpacing.md),
          // 文法一覧
          Expanded(
            child: _GrammarListView(
              onTap: _navigateToDetail,
            ),
          ),
        ],
      ),
    );
  }
}

/// 検索バー
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '文法名や意味で検索',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Iconsax.search_normal,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                  : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}

/// レベルフィルターチップ
class _LevelFilterChips extends ConsumerWidget {
  const _LevelFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(grammarFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          _FilterChip(
            label: '全レベル',
            selected: filterState.selectedLevel == null,
            onTap: () =>
                ref.read(grammarFilterProvider.notifier).setLevel(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          ...GrammarLevel.values.map(
            (level) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: level.label,
                selected: filterState.selectedLevel == level,
                color: level.color,
                onTap: () => ref
                    .read(grammarFilterProvider.notifier)
                    .setLevel(level),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// フィルターチップ
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? chipColor.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: selected ? chipColor : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected ? chipColor : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// カテゴリタブバー
class _CategoryTabBar extends StatelessWidget {
  const _CategoryTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      labelColor: AppColors.primary,
      unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        const Tab(text: '全て'),
        ...GrammarCategory.values.map(
          (category) => Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(category.icon, size: 16),
                const SizedBox(width: 4),
                Text(category.label),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 文法一覧リスト
class _GrammarListView extends ConsumerWidget {
  const _GrammarListView({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredGrammarsProvider);

    return filteredAsync.when(
      data: (grammars) {
        if (grammars.isEmpty) {
          return const PageEmptyView(
            icon: Iconsax.search_status,
            title: '該当する文法がありません',
            description: '検索条件を変更してみてください',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg ),
          itemCount: grammars.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final grammar = grammars[index];
            return _GrammarListTile(
              grammar: grammar,
              onTap: () => onTap(grammar.id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => PageErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(filteredGrammarsProvider),
      ),
    );
  }
}

/// 文法リストタイル
class _GrammarListTile extends ConsumerWidget {
  const _GrammarListTile({
    required this.grammar,
    required this.onTap,
  });

  final GrammarMeta grammar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isFavoriteAsync = ref.watch(isGrammarFavoriteProvider(grammar.id));

    return GestureDetector(
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
              height: 48,
              decoration: BoxDecoration(
                color: grammar.level.color,
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
                        grammar.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _LevelBadge(level: grammar.level),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    grammar.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (grammar.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children:
                          grammar.tags.take(3).map((tag) => _TagChip(tag: tag)).toList(),
                    ),
                  ],
                ],
              ),
            ),
            // お気に入りボタン
            isFavoriteAsync.when(
              data: (isFavorite) => IconButton(
                icon: Icon(
                  Iconsax.heart,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () =>
                    ref.read(grammarFavoritesProvider.notifier).toggle(grammar.id),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
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

/// タグチップ
class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
