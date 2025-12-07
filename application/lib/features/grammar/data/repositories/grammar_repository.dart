import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/utils/logger.dart';
import '../models/grammar_detail.dart';
import '../models/grammar_index.dart';
import '../models/grammar_models.dart';

class GrammarRepository {
  GrammarRepository({AssetBundle? bundle, SharedPreferences? preferences})
    : _bundle = bundle ?? rootBundle,
      _prefs = preferences;

  static const _indexAssetPath = 'assets/grammar/grammar_index.json';
  static const _indexCacheKey = 'grammar_index_cache';
  static const _grammarCachePrefix = 'grammar_cache_';

  final AssetBundle _bundle;
  SharedPreferences? _prefs;

  GrammarIndex? _indexCache;
  final Map<String, GrammarMeta> _metaCache = {};
  final Map<String, GrammarDetail> _detailCache = {};

  Future<SharedPreferences> get _preferences async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// インデックスを読み込み
  Future<GrammarIndex> loadIndex() async {
    if (_indexCache != null) {
      return _indexCache!;
    }

    try {
      final jsonString = await _bundle.loadString(_indexAssetPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final index = GrammarIndex.fromJson(jsonMap);
      _cacheIndexJson(jsonString);
      _hydrateMetaCache(index);
      _indexCache = index;
      return index;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load grammar index from assets',
        tag: 'GrammarRepository',
        error: error,
        stackTrace: stackTrace,
      );
      final cached = await _loadIndexFromCache();
      if (cached != null) {
        _hydrateMetaCache(cached);
        _indexCache = cached;
        return cached;
      }
      throw GrammarLoadException.indexNotFound(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// カテゴリ別の文法一覧を取得
  Future<List<GrammarMeta>> itemsByCategory(GrammarCategory category) async {
    final index = await loadIndex();
    return index.itemsByCategory(category);
  }

  /// 全カテゴリのカタログを取得
  Future<Map<GrammarCategory, List<GrammarMeta>>> loadCatalog() async {
    final index = await loadIndex();
    return {
      for (final entry in index.categories.entries) entry.key: entry.value.items,
    };
  }

  /// 文法詳細を取得
  Future<GrammarDetail> loadGrammar(String grammarId) async {
    if (_detailCache.containsKey(grammarId)) {
      return _detailCache[grammarId]!;
    }

    final meta = await _findMeta(grammarId);
    final detail = await _loadGrammarFromAsset(meta);
    _detailCache[grammarId] = detail;
    return detail;
  }

  /// 検索機能
  Future<List<GrammarMeta>> search(String query) async {
    if (query.trim().isEmpty) {
      return const [];
    }
    final index = await loadIndex();
    return index.allItems.where((meta) => meta.matchesSearch(query)).toList();
  }

  /// レベル別にフィルタリング
  Future<List<GrammarMeta>> filterByLevel(GrammarLevel level) async {
    final index = await loadIndex();
    return index.allItems.where((meta) => meta.level == level).toList();
  }

  /// カテゴリとレベルでフィルタリング
  Future<List<GrammarMeta>> filter({
    GrammarCategory? category,
    GrammarLevel? level,
    String? searchQuery,
  }) async {
    final index = await loadIndex();
    var items = index.allItems;

    if (category != null) {
      items = items.where((m) => m.category == category).toList();
    }

    if (level != null) {
      items = items.where((m) => m.level == level).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      items = items.where((m) => m.matchesSearch(searchQuery)).toList();
    }

    return items;
  }

  /// カテゴリのプリロード
  Future<void> preloadCategory(GrammarCategory category) async {
    final grammars = await itemsByCategory(category);
    for (final meta in grammars) {
      if (_detailCache.containsKey(meta.id)) {
        continue;
      }
      try {
        final detail = await _loadGrammarFromAsset(meta);
        _detailCache[meta.id] = detail;
      } catch (error, stackTrace) {
        AppLogger.error(
          'Failed to preload grammar ${meta.id}',
          tag: 'GrammarRepository',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<GrammarIndex?> _loadIndexFromCache() async {
    final prefs = await _preferences;
    final cached = prefs.getString(_indexCacheKey);
    if (cached == null) {
      return null;
    }
    try {
      final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
      return GrammarIndex.fromJson(jsonMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse cached grammar index',
        tag: 'GrammarRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<GrammarMeta> _findMeta(String grammarId) async {
    if (_metaCache.containsKey(grammarId)) {
      return _metaCache[grammarId]!;
    }
    final index = await loadIndex();
    final meta = index.findGrammarMeta(grammarId);
    if (meta == null) {
      throw GrammarLoadException.grammarNotFound(grammarId);
    }
    _metaCache[grammarId] = meta;
    return meta;
  }

  Future<GrammarDetail> _loadGrammarFromAsset(GrammarMeta meta) async {
    final path = 'assets/grammar/${meta.file}';
    try {
      final jsonString = await _bundle.loadString(path);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final detail = GrammarDetail.fromJson(jsonMap);
      await _cacheGrammarJson(meta.id, jsonString);
      return detail;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load grammar ${meta.id} from asset',
        tag: 'GrammarRepository',
        error: error,
        stackTrace: stackTrace,
      );
      final cached = await _loadGrammarFromCache(meta.id);
      if (cached != null) {
        return cached;
      }
      throw GrammarLoadException.grammarNotFound(
        meta.id,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _cacheIndexJson(String jsonString) async {
    final prefs = await _preferences;
    await prefs.setString(_indexCacheKey, jsonString);
  }

  Future<void> _cacheGrammarJson(String grammarId, String jsonString) async {
    final prefs = await _preferences;
    await prefs.setString('$_grammarCachePrefix$grammarId', jsonString);
  }

  Future<GrammarDetail?> _loadGrammarFromCache(String grammarId) async {
    final prefs = await _preferences;
    final cached = prefs.getString('$_grammarCachePrefix$grammarId');
    if (cached == null) {
      return null;
    }
    try {
      final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
      return GrammarDetail.fromJson(jsonMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse cached grammar $grammarId',
        tag: 'GrammarRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  void _hydrateMetaCache(GrammarIndex index) {
    if (_metaCache.isNotEmpty) {
      return;
    }
    for (final catalog in index.categories.values) {
      for (final meta in catalog.items) {
        _metaCache[meta.id] = meta;
      }
    }
  }
}
