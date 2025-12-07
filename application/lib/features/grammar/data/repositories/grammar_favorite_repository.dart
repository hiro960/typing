import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import '../models/grammar_favorite.dart';

class GrammarFavoriteRepository {
  GrammarFavoriteRepository({SharedPreferences? preferences})
    : _prefs = preferences;

  static const _favoritesKey = 'grammar_favorites_v1';

  SharedPreferences? _prefs;
  List<GrammarFavorite>? _cache;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// お気に入り一覧を取得
  Future<List<GrammarFavorite>> loadFavorites() async {
    if (_cache != null) {
      return List.unmodifiable(_cache!);
    }

    final prefs = await _preferences;
    final json = prefs.getString(_favoritesKey);
    if (json == null) {
      _cache = [];
      return const [];
    }

    try {
      final data = jsonDecode(json) as List<dynamic>;
      final favorites =
          data
              .whereType<Map<String, dynamic>>()
              .map(GrammarFavorite.fromJson)
              .toList();
      _cache = favorites;
      return List.unmodifiable(favorites);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse grammar favorites',
        tag: 'GrammarFavoriteRepository',
        error: error,
        stackTrace: stackTrace,
      );
      _cache = [];
      return const [];
    }
  }

  /// お気に入りに追加
  Future<void> addFavorite(String grammarId, {String? note}) async {
    final favorites = await loadFavorites();
    if (favorites.any((f) => f.grammarId == grammarId)) {
      return;
    }

    final favorite = GrammarFavorite(
      grammarId: grammarId,
      addedAt: DateTime.now(),
      note: note,
    );
    final updated = [...favorites, favorite];
    await _saveFavorites(updated);
  }

  /// お気に入りから削除
  Future<void> removeFavorite(String grammarId) async {
    final favorites = await loadFavorites();
    final updated = favorites.where((f) => f.grammarId != grammarId).toList();
    await _saveFavorites(updated);
  }

  /// お気に入りかどうかを確認
  Future<bool> isFavorite(String grammarId) async {
    final favorites = await loadFavorites();
    return favorites.any((f) => f.grammarId == grammarId);
  }

  /// お気に入りをトグル
  Future<bool> toggleFavorite(String grammarId) async {
    final isFav = await isFavorite(grammarId);
    if (isFav) {
      await removeFavorite(grammarId);
      return false;
    } else {
      await addFavorite(grammarId);
      return true;
    }
  }

  /// メモを更新
  Future<void> updateNote(String grammarId, String? note) async {
    final favorites = await loadFavorites();
    final updated =
        favorites.map((f) {
          if (f.grammarId == grammarId) {
            return f.copyWith(note: note);
          }
          return f;
        }).toList();
    await _saveFavorites(updated);
  }

  /// お気に入りIDのセットを取得（高速判定用）
  Future<Set<String>> getFavoriteIds() async {
    final favorites = await loadFavorites();
    return favorites.map((f) => f.grammarId).toSet();
  }

  Future<void> _saveFavorites(List<GrammarFavorite> favorites) async {
    final prefs = await _preferences;
    final json = jsonEncode(favorites.map((f) => f.toJson()).toList());
    await prefs.setString(_favoritesKey, json);
    _cache = favorites;
  }

  /// キャッシュをクリア
  void clearCache() {
    _cache = null;
  }
}
