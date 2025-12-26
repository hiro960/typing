import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shadowing_models.dart';

/// シャドーイングリポジトリ
class ShadowingRepository {
  static const _progressKey = 'shadowing_progress';

  /// レベル別コンテンツを読み込む
  Future<List<ShadowingContent>> loadContents(ShadowingLevel level) async {
    final fileName = _getLevelFileName(level);
    final jsonString = await rootBundle.loadString('assets/shadowing/$fileName');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final dataFile = ShadowingDataFile.fromJson(jsonData);
    return dataFile.contents;
  }

  /// 全進捗を読み込む
  Future<Map<String, ShadowingProgress>> loadAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString == null) {
      return {};
    }
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return jsonData.map((key, value) {
      return MapEntry(
        key,
        ShadowingProgress.fromJson(value as Map<String, dynamic>),
      );
    });
  }

  /// 進捗を保存
  Future<void> saveProgress(ShadowingProgress progress) async {
    final allProgress = await loadAllProgress();
    allProgress[progress.contentId] = progress;
    await _saveAllProgress(allProgress);
  }

  /// 練習回数をインクリメント
  Future<ShadowingProgress> incrementPracticeCount(String contentId) async {
    final allProgress = await loadAllProgress();
    final existing = allProgress[contentId];
    final updated = ShadowingProgress(
      contentId: contentId,
      practiceCount: (existing?.practiceCount ?? 0) + 1,
      lastPracticed: DateTime.now(),
    );
    allProgress[contentId] = updated;
    await _saveAllProgress(allProgress);
    return updated;
  }

  /// 特定コンテンツの進捗を取得
  Future<ShadowingProgress?> getProgress(String contentId) async {
    final allProgress = await loadAllProgress();
    return allProgress[contentId];
  }

  /// レベル別統計を計算
  Future<ShadowingLevelStats> getLevelStats(
    ShadowingLevel level,
    List<ShadowingContent> contents,
  ) async {
    final allProgress = await loadAllProgress();
    int masteredCount = 0;
    int practicedCount = 0;

    for (final content in contents) {
      final progress = allProgress[content.id];
      if (progress != null) {
        if (progress.isMastered) {
          masteredCount++;
        }
        if (progress.isPracticed) {
          practicedCount++;
        }
      }
    }

    return ShadowingLevelStats(
      level: level,
      totalCount: contents.length,
      masteredCount: masteredCount,
      practicedCount: practicedCount,
    );
  }

  /// 全進捗を保存（内部メソッド）
  Future<void> _saveAllProgress(Map<String, ShadowingProgress> allProgress) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = allProgress.map((key, value) {
      return MapEntry(key, value.toJson());
    });
    await prefs.setString(_progressKey, json.encode(jsonData));
  }

  /// レベルからファイル名を取得
  String _getLevelFileName(ShadowingLevel level) {
    switch (level) {
      case ShadowingLevel.beginner:
        return 'beginner.json';
      case ShadowingLevel.intermediate:
        return 'intermediate.json';
      case ShadowingLevel.advanced:
        return 'advanced.json';
    }
  }
}
