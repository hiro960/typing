import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import '../models/quick_translation_models.dart';

class QuickTranslationRepository {
  QuickTranslationRepository({AssetBundle? bundle, SharedPreferences? preferences})
      : _bundle = bundle ?? rootBundle,
        _prefs = preferences;

  static const _progressCacheKey = 'quick_translation_progress';

  final AssetBundle _bundle;
  SharedPreferences? _prefs;

  // キャッシュ
  final Map<String, QuickTranslationQuestionSet> _questionSetCache = {};
  final Map<String, List<String>> _availableItemsCache = {};
  Map<String, GrammarItemProgress>? _progressCache;
  AssetManifest? _assetManifest;

  Future<SharedPreferences> get _preferences async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// カテゴリ別に利用可能な文法項目IDのリストを取得
  Future<List<String>> loadAvailableItems(String categoryId) async {
    if (_availableItemsCache.containsKey(categoryId)) {
      return _availableItemsCache[categoryId]!;
    }

    final items = <String>[];
    final assetPath = 'assets/quick_translation/$categoryId/';

    try {
      // Flutter 3.7+ 対応: AssetManifest.loadFromAssetBundle() を使用
      _assetManifest ??= await AssetManifest.loadFromAssetBundle(_bundle);
      final allAssets = _assetManifest!.listAssets();

      for (final key in allAssets) {
        if (key.startsWith(assetPath) && key.endsWith('.json')) {
          // ファイル名から grammarRef を抽出
          // 例: assets/quick_translation/particle/grm_particle_001.json -> grm_particle_001
          final fileName = key.split('/').last;
          final grammarRef = fileName.replaceAll('.json', '');
          items.add(grammarRef);
        }
      }

      items.sort();
      _availableItemsCache[categoryId] = items;
      return items;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load available items for category $categoryId',
        tag: 'QuickTranslationRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// 問題セットを読み込む
  Future<QuickTranslationQuestionSet?> loadQuestionSet(String grammarRef) async {
    if (_questionSetCache.containsKey(grammarRef)) {
      return _questionSetCache[grammarRef];
    }

    // grammarRef から category を抽出
    // 例: grm_particle_001 -> particle
    final parts = grammarRef.split('_');
    if (parts.length < 3) {
      AppLogger.error(
        'Invalid grammarRef format: $grammarRef',
        tag: 'QuickTranslationRepository',
      );
      return null;
    }
    final category = parts[1];
    final assetPath = 'assets/quick_translation/$category/$grammarRef.json';

    try {
      final jsonString = await _bundle.loadString(assetPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final questionSet = QuickTranslationQuestionSet.fromJson(jsonMap);
      _questionSetCache[grammarRef] = questionSet;
      return questionSet;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load question set for $grammarRef',
        tag: 'QuickTranslationRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// 全進捗を読み込む
  Future<Map<String, GrammarItemProgress>> loadAllProgress() async {
    if (_progressCache != null) {
      return _progressCache!;
    }

    final prefs = await _preferences;
    final jsonString = prefs.getString(_progressCacheKey);

    if (jsonString == null) {
      _progressCache = {};
      return _progressCache!;
    }

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      _progressCache = {};
      for (final entry in jsonMap.entries) {
        if (entry.value is Map<String, dynamic>) {
          _progressCache![entry.key] =
              GrammarItemProgress.fromJson(entry.value as Map<String, dynamic>);
        }
      }
      return _progressCache!;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse progress cache',
        tag: 'QuickTranslationRepository',
        error: error,
        stackTrace: stackTrace,
      );
      _progressCache = {};
      return _progressCache!;
    }
  }

  /// 特定項目の進捗を取得
  Future<GrammarItemProgress?> loadProgress(String grammarRef) async {
    final allProgress = await loadAllProgress();
    return allProgress[grammarRef];
  }

  /// 進捗を保存
  Future<void> saveProgress(GrammarItemProgress progress) async {
    final allProgress = await loadAllProgress();
    allProgress[progress.grammarRef] = progress;
    _progressCache = allProgress;

    final prefs = await _preferences;
    final jsonMap = <String, dynamic>{};
    for (final entry in allProgress.entries) {
      jsonMap[entry.key] = entry.value.toJson();
    }
    await prefs.setString(_progressCacheKey, jsonEncode(jsonMap));
  }

  /// セッション結果から進捗を更新
  Future<GrammarItemProgress> updateProgressFromSession(
    PracticeSessionState session,
  ) async {
    final grammarRef = session.questionSet.grammarRef;
    final existingProgress = await loadProgress(grammarRef);

    // 正解数（ほぼ正解も含む）
    final correctCount = session.correctCount + session.almostCorrectCount;
    final isCleared = correctCount >= 8; // 10問中8問以上正解でクリア

    final newProgress = GrammarItemProgress(
      grammarRef: grammarRef,
      isCleared: isCleared || (existingProgress?.isCleared ?? false),
      bestCorrectCount: correctCount > (existingProgress?.bestCorrectCount ?? 0)
          ? correctCount
          : existingProgress?.bestCorrectCount ?? correctCount,
      lastPracticedAt: DateTime.now(),
    );

    await saveProgress(newProgress);
    return newProgress;
  }

  /// カテゴリ別の進捗統計を取得
  Future<Map<String, int>> getClearedCountByCategory() async {
    final allProgress = await loadAllProgress();
    final counts = <String, int>{};

    for (final progress in allProgress.values) {
      if (progress.isCleared) {
        // grammarRef から category を抽出
        final parts = progress.grammarRef.split('_');
        if (parts.length >= 2) {
          final category = parts[1];
          counts[category] = (counts[category] ?? 0) + 1;
        }
      }
    }

    return counts;
  }

  /// キャッシュをクリア
  void clearCache() {
    _questionSetCache.clear();
    _availableItemsCache.clear();
    _progressCache = null;
    _assetManifest = null;
  }
}
