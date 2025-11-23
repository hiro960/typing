import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/writing_models.dart';

/// 書き取り学習履歴のローカルストレージ管理
class WritingStorageRepository {
  static const String _keyCompletions = 'writing_completions';
  static const String _keyStats = 'writing_stats';

  final SharedPreferences _prefs;

  WritingStorageRepository(this._prefs);

  /// 完了記録を保存
  Future<void> saveCompletion(WritingCompletion completion) async {
    final completions = await getCompletions();
    completions.add(completion);

    // 最新100件のみ保持
    if (completions.length > 100) {
      completions.removeRange(0, completions.length - 100);
    }

    final jsonList = completions.map((c) => c.toJson()).toList();
    await _prefs.setString(_keyCompletions, jsonEncode(jsonList));

    // 統計を更新
    await _updateStats(completion);
  }

  /// 全完了記録を取得
  Future<List<WritingCompletion>> getCompletions() async {
    final jsonString = _prefs.getString(_keyCompletions);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => WritingCompletion.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 特定パターンの完了記録を取得
  Future<List<WritingCompletion>> getCompletionsByPattern(
      String patternId) async {
    final completions = await getCompletions();
    return completions.where((c) => c.patternId == patternId).toList();
  }

  /// 統計情報を取得
  Future<WritingStats> getStats() async {
    final jsonString = _prefs.getString(_keyStats);
    if (jsonString == null) return const WritingStats();

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return WritingStats.fromJson(json);
  }

  /// 統計情報を更新
  Future<void> _updateStats(WritingCompletion completion) async {
    final stats = await getStats();

    final correctCount =
        completion.results.where((r) => r.correct).length;
    final totalAttempts = completion.results.length;

    final updatedPatternCompletions =
        Map<String, int>.from(stats.patternCompletions);
    updatedPatternCompletions[completion.patternId] =
        (updatedPatternCompletions[completion.patternId] ?? 0) + 1;

    final updatedStats = WritingStats(
      totalCompletions: stats.totalCompletions + 1,
      totalCorrect: stats.totalCorrect + correctCount,
      totalAttempts: stats.totalAttempts + totalAttempts,
      patternCompletions: updatedPatternCompletions,
    );

    await _prefs.setString(_keyStats, jsonEncode(updatedStats.toJson()));
  }

  /// 全データをクリア
  Future<void> clearAll() async {
    await _prefs.remove(_keyCompletions);
    await _prefs.remove(_keyStats);
  }
}
