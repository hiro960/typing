import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/hanja/data/models/hanja_character.dart';
import '../../../features/hanja/data/models/hanja_models.dart';
import '../../../features/hanja/data/models/hanja_word.dart';
import '../../../features/hanja/domain/providers/hanja_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_empty_view.dart';
import '../../widgets/page_error_view.dart';
import 'hanja_character_detail_screen.dart';
import 'hanja_word_detail_screen.dart';

/// 漢字語辞典一覧画面
class HanjaListScreen extends ConsumerStatefulWidget {
  const HanjaListScreen({super.key});

  @override
  ConsumerState<HanjaListScreen> createState() => _HanjaListScreenState();
}

class _HanjaListScreenState extends ConsumerState<HanjaListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // 「単漢字」「漢字語」「全て」
    _tabController = TabController(length: 3, vsync: this);
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
      final types = [
        HanjaSearchType.characters,
        HanjaSearchType.words,
        HanjaSearchType.all,
      ];
      ref.read(hanjaFilterProvider.notifier).setSearchType(types[index]);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(hanjaFilterProvider.notifier).setSearchQuery(query);
    });
  }

  void _navigateToCharacterDetail(String characterId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HanjaCharacterDetailScreen(characterId: characterId),
      ),
    );
  }

  void _navigateToWordDetail(String wordId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HanjaWordDetailScreen(wordId: wordId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: '漢字語辞典',
      titleIcon: Icons.translate,
      showBackButton: true,
      child: Column(
        children: [
          // 検索バー
          _SearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          // 五十音インデックス
          const _JapaneseOnIndexChips(),
          const SizedBox(height: AppSpacing.xs),
          // 韓国語初声インデックス
          const _KoreanChoseongIndexChips(),
          const SizedBox(height: AppSpacing.sm),
          // 検索タイプタブ
          _SearchTypeTabBar(controller: _tabController),
          const SizedBox(height: AppSpacing.md),
          // 結果一覧
          Expanded(
            child: _HanjaResultView(
              onCharacterTap: _navigateToCharacterDetail,
              onWordTap: _navigateToWordDetail,
            ),
          ),
        ],
      ),
    );
  }
}

/// 五十音インデックスチップ
class _JapaneseOnIndexChips extends ConsumerWidget {
  const _JapaneseOnIndexChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(hanjaFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // 「全て」ボタン
          _IndexChip(
            label: '全て',
            selected: filterState.japaneseOnIndex == null &&
                filterState.koreanChoseongIndex == null,
            onTap: () =>
                ref.read(hanjaFilterProvider.notifier).setJapaneseOnIndex(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          // 五十音インデックス（ア〜ワ）
          ...JapaneseOnIndex.values.map(
            (index) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _IndexChip(
                label: index.label,
                selected: filterState.japaneseOnIndex == index,
                onTap: () => ref
                    .read(hanjaFilterProvider.notifier)
                    .setJapaneseOnIndex(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 韓国語初声インデックスチップ
class _KoreanChoseongIndexChips extends ConsumerWidget {
  const _KoreanChoseongIndexChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(hanjaFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // 「全て」ボタン（韓国語）
          _IndexChip(
            label: '전체',
            selected: filterState.koreanChoseongIndex == null &&
                filterState.japaneseOnIndex == null,
            onTap: () =>
                ref.read(hanjaFilterProvider.notifier).setKoreanChoseongIndex(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          // 韓国語初声インデックス（ㄱ〜ㅎ）
          ...KoreanChoseongIndex.values.map(
            (index) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _IndexChip(
                label: index.label,
                selected: filterState.koreanChoseongIndex == index,
                onTap: () => ref
                    .read(hanjaFilterProvider.notifier)
                    .setKoreanChoseongIndex(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// インデックスチップ（共通）
class _IndexChip extends StatelessWidget {
  const _IndexChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: selected ? AppColors.primary : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
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
          hintText: '漢字・ハングル・意味で検索',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
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

/// 検索タイプタブバー
class _SearchTypeTabBar extends StatelessWidget {
  const _SearchTypeTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: controller,
      labelColor: AppColors.primary,
      unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.text_fields, size: 16),
              SizedBox(width: 4),
              Text('単漢字'),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.library_books, size: 16),
              SizedBox(width: 4),
              Text('漢字語'),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.all_inclusive, size: 16),
              SizedBox(width: 4),
              Text('全て'),
            ],
          ),
        ),
      ],
    );
  }
}

/// 検索結果表示
class _HanjaResultView extends ConsumerWidget {
  const _HanjaResultView({
    required this.onCharacterTap,
    required this.onWordTap,
  });

  final ValueChanged<String> onCharacterTap;
  final ValueChanged<String> onWordTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(hanjaFilterProvider);
    final searchResultAsync = ref.watch(filteredHanjaSearchProvider);

    return searchResultAsync.when(
      data: (result) {
        if (result.isEmpty) {
          return const PageEmptyView(
            icon: Icons.search_off,
            title: '該当する漢字がありません',
            description: '検索条件を変更してみてください',
          );
        }

        final showCharacters = filterState.searchType == HanjaSearchType.all ||
            filterState.searchType == HanjaSearchType.characters;
        final showWords = filterState.searchType == HanjaSearchType.all ||
            filterState.searchType == HanjaSearchType.words;

        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          children: [
            // 単漢字セクション
            if (showCharacters && result.characters.isNotEmpty) ...[
              _SectionHeader(
                title: '単漢字',
                count: result.characters.length,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...result.characters.map(
                (character) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _HanjaCharacterTile(
                    character: character,
                    onTap: () => onCharacterTap(character.id),
                  ),
                ),
              ),
              if (showWords && result.words.isNotEmpty)
                const SizedBox(height: AppSpacing.lg),
            ],
            // 漢字語セクション
            if (showWords && result.words.isNotEmpty) ...[
              _SectionHeader(
                title: '漢字語',
                count: result.words.length,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...result.words.map(
                (word) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _HanjaWordTile(
                    word: word,
                    onTap: () => onWordTap(word.id),
                  ),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => PageErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(filteredHanjaSearchProvider),
      ),
    );
  }
}

/// セクションヘッダー
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count件',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 単漢字タイル
class _HanjaCharacterTile extends StatelessWidget {
  const _HanjaCharacterTile({
    required this.character,
    required this.onTap,
  });

  final HanjaCharacter character;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            // 漢字
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  character.character,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // 情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        character.korean,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _LevelBadge(level: character.level),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    character.meaning,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (character.japaneseOn.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '音読み: ${character.japaneseOn.join(", ")}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

/// 漢字語タイル
class _HanjaWordTile extends StatelessWidget {
  const _HanjaWordTile({
    required this.word,
    required this.onTap,
  });

  final HanjaWord word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              height: 56,
              decoration: BoxDecoration(
                color: word.level.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // 情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        word.word,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '(${word.hanja})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.meaning,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _CategoryBadge(category: word.category),
                      const SizedBox(width: AppSpacing.xs),
                      _LevelBadge(level: word.level),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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

  final HanjaLevel level;

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

/// カテゴリバッジ
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final HanjaWordCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 10),
          const SizedBox(width: 2),
          Text(
            category.label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
