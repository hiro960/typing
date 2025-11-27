import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaletta/core/utils/logger.dart';

/// オフライン時のゲーム結果をキューに保存するサービス
class OfflineQueueService {
  OfflineQueueService();

  static const String _queueKey = 'ranking_game_offline_queue';

  /// 保留中のゲーム結果を保存
  Future<void> enqueue(PendingGameResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queue = await getPendingResults();
      queue.add(result);

      final jsonList = queue.map((r) => r.toJson()).toList();
      await prefs.setString(_queueKey, jsonEncode(jsonList));

      AppLogger.info(
        'Enqueued offline game result. Queue size: ${queue.length}',
        tag: 'OfflineQueue',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to enqueue offline game result',
        tag: 'OfflineQueue',
        error: e,
      );
    }
  }

  /// 保留中のゲーム結果を取得
  Future<List<PendingGameResult>> getPendingResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_queueKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => PendingGameResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error(
        'Failed to get pending results',
        tag: 'OfflineQueue',
        error: e,
      );
      return [];
    }
  }

  /// 保留中の結果数を取得
  Future<int> getPendingCount() async {
    final results = await getPendingResults();
    return results.length;
  }

  /// 特定の結果を削除（同期成功後）
  Future<void> remove(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queue = await getPendingResults();
      queue.removeWhere((r) => r.id == id);

      final jsonList = queue.map((r) => r.toJson()).toList();
      await prefs.setString(_queueKey, jsonEncode(jsonList));

      AppLogger.info(
        'Removed synced result. Queue size: ${queue.length}',
        tag: 'OfflineQueue',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to remove result from queue',
        tag: 'OfflineQueue',
        error: e,
      );
    }
  }

  /// キューをクリア
  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_queueKey);
      AppLogger.info('Cleared offline queue', tag: 'OfflineQueue');
    } catch (e) {
      AppLogger.error(
        'Failed to clear offline queue',
        tag: 'OfflineQueue',
        error: e,
      );
    }
  }
}

/// 保留中のゲーム結果
class PendingGameResult {
  PendingGameResult({
    required this.id,
    required this.difficulty,
    required this.score,
    required this.correctCount,
    required this.maxCombo,
    required this.totalBonusTime,
    required this.avgInputSpeed,
    required this.characterLevel,
    required this.playedAt,
  });

  final String id;
  final String difficulty;
  final int score;
  final int correctCount;
  final int maxCombo;
  final int totalBonusTime;
  final double avgInputSpeed;
  final int characterLevel;
  final DateTime playedAt;

  factory PendingGameResult.fromJson(Map<String, dynamic> json) {
    return PendingGameResult(
      id: json['id'] as String,
      difficulty: json['difficulty'] as String,
      score: json['score'] as int,
      correctCount: json['correctCount'] as int,
      maxCombo: json['maxCombo'] as int,
      totalBonusTime: json['totalBonusTime'] as int,
      avgInputSpeed: (json['avgInputSpeed'] as num).toDouble(),
      characterLevel: json['characterLevel'] as int,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'difficulty': difficulty,
      'score': score,
      'correctCount': correctCount,
      'maxCombo': maxCombo,
      'totalBonusTime': totalBonusTime,
      'avgInputSpeed': avgInputSpeed,
      'characterLevel': characterLevel,
      'playedAt': playedAt.toIso8601String(),
    };
  }
}
