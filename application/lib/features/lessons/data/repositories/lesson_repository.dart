import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/utils/logger.dart';
import '../models/lesson_index.dart';
import '../models/lesson_models.dart';

class LessonRepository {
  LessonRepository({AssetBundle? bundle, SharedPreferences? preferences})
    : _bundle = bundle ?? rootBundle,
      _prefs = preferences;

  static const _indexAssetPath = 'assets/lessons/lessons_index.json';
  static const _indexCacheKey = 'lessons_index_cache';
  static const _lessonCachePrefix = 'lesson_cache_';

  final AssetBundle _bundle;
  SharedPreferences? _prefs;

  LessonIndex? _indexCache;
  final Map<String, LessonMeta> _metaCache = {};
  final Map<String, Lesson> _lessonCache = {};

  Future<SharedPreferences> get _preferences async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<LessonIndex> loadIndex() async {
    if (_indexCache != null) {
      return _indexCache!;
    }

    try {
      final jsonString = await _bundle.loadString(_indexAssetPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final index = LessonIndex.fromJson(jsonMap);
      _cacheIndexJson(jsonString);
      _hydrateMetaCache(index);
      _indexCache = index;
      return index;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load lesson index from assets',
        tag: 'LessonRepository',
        error: error,
        stackTrace: stackTrace,
      );
      final cached = await _loadIndexFromCache();
      if (cached != null) {
        _hydrateMetaCache(cached);
        _indexCache = cached;
        return cached;
      }
      throw LessonLoadException.indexNotFound(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<LessonMeta>> lessonsByLevel(LessonLevel level) async {
    final index = await loadIndex();
    return index.lessonsByLevel(level);
  }

  Future<Map<LessonLevel, List<LessonMeta>>> loadCatalog() async {
    final index = await loadIndex();
    return {
      for (final entry in index.levels.entries) entry.key: entry.value.lessons,
    };
  }

  Future<Lesson> loadLesson(String lessonId) async {
    if (_lessonCache.containsKey(lessonId)) {
      return _lessonCache[lessonId]!;
    }

    final meta = await _findMeta(lessonId);
    final lesson = await _loadLessonFromAsset(meta);
    _lessonCache[lessonId] = lesson;
    return lesson;
  }

  Future<void> preloadLevel(LessonLevel level) async {
    final lessons = await lessonsByLevel(level);
    for (final meta in lessons) {
      if (_lessonCache.containsKey(meta.id)) {
        continue;
      }
      try {
        final lesson = await _loadLessonFromAsset(meta);
        _lessonCache[meta.id] = lesson;
      } catch (error, stackTrace) {
        AppLogger.error(
          'Failed to preload lesson ${meta.id}',
          tag: 'LessonRepository',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<LessonIndex?> _loadIndexFromCache() async {
    final prefs = await _preferences;
    final cached = prefs.getString(_indexCacheKey);
    if (cached == null) {
      return null;
    }
    try {
      final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
      return LessonIndex.fromJson(jsonMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse cached lesson index',
        tag: 'LessonRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<LessonMeta> _findMeta(String lessonId) async {
    if (_metaCache.containsKey(lessonId)) {
      return _metaCache[lessonId]!;
    }
    final index = await loadIndex();
    final meta = index.findLessonMeta(lessonId);
    if (meta == null) {
      throw LessonLoadException.lessonNotFound(lessonId);
    }
    _metaCache[lessonId] = meta;
    return meta;
  }

  Future<Lesson> _loadLessonFromAsset(LessonMeta meta) async {
    final path = 'assets/lessons/${meta.file}';
    try {
      final jsonString = await _bundle.loadString(path);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final lesson = Lesson.fromJson(jsonMap);
      await _cacheLessonJson(meta.id, jsonString);
      return lesson;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load lesson ${meta.id} from asset',
        tag: 'LessonRepository',
        error: error,
        stackTrace: stackTrace,
      );
      final cached = await _loadLessonFromCache(meta.id);
      if (cached != null) {
        return cached;
      }
      throw LessonLoadException.lessonNotFound(
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

  Future<void> _cacheLessonJson(String lessonId, String jsonString) async {
    final prefs = await _preferences;
    await prefs.setString('$_lessonCachePrefix$lessonId', jsonString);
  }

  Future<Lesson?> _loadLessonFromCache(String lessonId) async {
    final prefs = await _preferences;
    final cached = prefs.getString('$_lessonCachePrefix$lessonId');
    if (cached == null) {
      return null;
    }
    try {
      final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
      return Lesson.fromJson(jsonMap);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse cached lesson $lessonId',
        tag: 'LessonRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  void _hydrateMetaCache(LessonIndex index) {
    if (_metaCache.isNotEmpty) {
      return;
    }
    for (final catalog in index.levels.values) {
      for (final meta in catalog.lessons) {
        _metaCache[meta.id] = meta;
      }
    }
  }
}
