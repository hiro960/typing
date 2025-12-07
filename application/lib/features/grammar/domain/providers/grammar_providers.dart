import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/grammar_detail.dart';
import '../../data/models/grammar_favorite.dart';
import '../../data/models/grammar_index.dart';
import '../../data/models/grammar_models.dart';
import '../../data/repositories/grammar_favorite_repository.dart';
import '../../data/repositories/grammar_repository.dart';

part 'grammar_providers.g.dart';

// ==================== Repository Providers ====================

@Riverpod(keepAlive: true)
GrammarRepository grammarRepository(Ref ref) {
  return GrammarRepository();
}

@Riverpod(keepAlive: true)
GrammarFavoriteRepository grammarFavoriteRepository(Ref ref) {
  return GrammarFavoriteRepository();
}

// ==================== Data Providers ====================

@riverpod
Future<GrammarIndex> grammarIndex(Ref ref) async {
  final repository = ref.watch(grammarRepositoryProvider);
  return repository.loadIndex();
}

@riverpod
Future<List<GrammarMeta>> grammarsByCategory(
  Ref ref,
  GrammarCategory category,
) async {
  final repository = ref.watch(grammarRepositoryProvider);
  return repository.itemsByCategory(category);
}

@riverpod
Future<GrammarDetail> grammarDetail(
  Ref ref,
  String grammarId,
) async {
  final repository = ref.watch(grammarRepositoryProvider);
  return repository.loadGrammar(grammarId);
}

@riverpod
Future<List<GrammarMeta>> grammarSearch(
  Ref ref,
  String query,
) async {
  final repository = ref.watch(grammarRepositoryProvider);
  return repository.search(query);
}

// ==================== Filter State ====================

class GrammarFilterState {
  const GrammarFilterState({
    this.selectedCategory,
    this.selectedLevel,
    this.searchQuery = '',
  });

  final GrammarCategory? selectedCategory;
  final GrammarLevel? selectedLevel;
  final String searchQuery;

  GrammarFilterState copyWith({
    GrammarCategory? selectedCategory,
    GrammarLevel? selectedLevel,
    String? searchQuery,
    bool clearCategory = false,
    bool clearLevel = false,
  }) {
    return GrammarFilterState(
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedLevel:
          clearLevel ? null : (selectedLevel ?? this.selectedLevel),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasFilters =>
      selectedCategory != null ||
      selectedLevel != null ||
      searchQuery.isNotEmpty;
}

@riverpod
class GrammarFilterNotifier extends _$GrammarFilterNotifier {
  @override
  GrammarFilterState build() {
    return const GrammarFilterState();
  }

  void setCategory(GrammarCategory? category) {
    state = state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
    );
  }

  void setLevel(GrammarLevel? level) {
    state = state.copyWith(
      selectedLevel: level,
      clearLevel: level == null,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = const GrammarFilterState();
  }
}

@riverpod
Future<List<GrammarMeta>> filteredGrammars(Ref ref) async {
  final filterState = ref.watch(grammarFilterProvider);
  final repository = ref.watch(grammarRepositoryProvider);

  return repository.filter(
    category: filterState.selectedCategory,
    level: filterState.selectedLevel,
    searchQuery:
        filterState.searchQuery.isNotEmpty ? filterState.searchQuery : null,
  );
}

// ==================== Favorites Providers ====================

@Riverpod(keepAlive: true)
class GrammarFavoritesNotifier extends _$GrammarFavoritesNotifier {
  @override
  FutureOr<List<GrammarFavorite>> build() async {
    final repository = ref.watch(grammarFavoriteRepositoryProvider);
    return repository.loadFavorites();
  }

  Future<void> toggle(String grammarId) async {
    final repository = ref.read(grammarFavoriteRepositoryProvider);
    await repository.toggleFavorite(grammarId);
    ref.invalidateSelf();
  }

  Future<void> add(String grammarId, {String? note}) async {
    final repository = ref.read(grammarFavoriteRepositoryProvider);
    await repository.addFavorite(grammarId, note: note);
    ref.invalidateSelf();
  }

  Future<void> remove(String grammarId) async {
    final repository = ref.read(grammarFavoriteRepositoryProvider);
    await repository.removeFavorite(grammarId);
    ref.invalidateSelf();
  }

  Future<void> updateNote(String grammarId, String? note) async {
    final repository = ref.read(grammarFavoriteRepositoryProvider);
    await repository.updateNote(grammarId, note);
    ref.invalidateSelf();
  }
}

@riverpod
Future<bool> isGrammarFavorite(
  Ref ref,
  String grammarId,
) async {
  final favorites = await ref.watch(grammarFavoritesProvider.future);
  return favorites.any((f) => f.grammarId == grammarId);
}

@riverpod
Future<Set<String>> grammarFavoriteIds(Ref ref) async {
  final favorites = await ref.watch(grammarFavoritesProvider.future);
  return favorites.map((f) => f.grammarId).toSet();
}

// ==================== Category Statistics ====================

@riverpod
Future<Map<GrammarCategory, int>> grammarCategoryCounts(Ref ref) async {
  final index = await ref.watch(grammarIndexProvider.future);
  return {
    for (final entry in index.categories.entries)
      entry.key: entry.value.totalItems,
  };
}

@riverpod
Future<Map<GrammarLevel, int>> grammarLevelCounts(Ref ref) async {
  final index = await ref.watch(grammarIndexProvider.future);
  final counts = <GrammarLevel, int>{};

  for (final level in GrammarLevel.values) {
    counts[level] = index.allItems.where((m) => m.level == level).length;
  }

  return counts;
}
