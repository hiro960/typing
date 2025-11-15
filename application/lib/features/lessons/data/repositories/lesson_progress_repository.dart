import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/services/api_client_service.dart';
import '../models/lesson_models.dart';
import '../models/lesson_progress.dart';
import '../models/lesson_stats_response.dart';

class LessonProgressRepository {
  LessonProgressRepository({
    required ApiClientService apiClient,
    SharedPreferences? preferences,
  }) : _apiClient = apiClient,
       _prefs = preferences;

  static const _progressKey = 'lesson_progress_cache_v1';

  final ApiClientService _apiClient;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, LessonProgress>> loadLocalProgress() async {
    final prefs = await _preferences;
    final raw = prefs.getString(_progressKey);
    if (raw == null) {
      return {};
    }
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return data.map(
        (key, value) => MapEntry(
          key,
          LessonProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse progress cache',
        tag: 'LessonProgressRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return {};
    }
  }

  Future<Map<String, LessonProgress>> markCompleted(
    String lessonId, {
    required int completedItems,
    required int totalItems,
    required int wpm,
    required double accuracy,
  }) async {
    final progress = await loadLocalProgress();
    final existing = progress[lessonId];
    final updatedRate = _calculateCompletionRate(completedItems, totalItems);
    final updated = LessonProgress(
      lessonId: lessonId,
      completionRate: updatedRate,
      lastCompletedAt: DateTime.now(),
      bestWpm: _betterWpm(existing?.bestWpm, wpm),
      bestAccuracy: _betterAccuracy(existing?.bestAccuracy, accuracy),
    );
    progress[lessonId] = updated;
    await _saveLocalProgress(progress);
    return progress;
  }

  Future<void> _saveLocalProgress(Map<String, LessonProgress> progress) async {
    final prefs = await _preferences;
    final jsonMap = progress.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_progressKey, jsonEncode(jsonMap));
  }

  int _calculateCompletionRate(int completedItems, int totalItems) {
    if (totalItems <= 0) {
      return 0;
    }
    final rate = (completedItems / totalItems * 100).round();
    return rate.clamp(0, 100);
  }

  int? _betterWpm(int? existing, int value) {
    if (existing == null || value > existing) {
      return value;
    }
    return existing;
  }

  double? _betterAccuracy(double? existing, double value) {
    if (existing == null || value > existing) {
      return value;
    }
    return existing;
  }

  Future<LessonStatsSummary> fetchStats({LessonLevel? level}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.lessonStats,
        queryParameters: level != null ? {'level': level.name} : null,
      );
      final stats = LessonStatsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
      return _toSummary(stats);
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  LessonStatsSummary _toSummary(LessonStatsResponse response) {
    final trend = response.trend;
    final lessons = response.totals.lessons;
    final totalTime = Duration(milliseconds: response.totals.timeSpent);
    final double avgWpm = trend.isEmpty
        ? 0
        : trend.map((e) => e.wpmAvg).reduce((a, b) => a + b) / trend.length;
    final double avgAccuracy = trend.isEmpty
        ? 0
        : trend.map((e) => e.accuracyAvg).reduce((a, b) => a + b) /
              trend.length;
    final streak = _calculateStreakDays(trend);

    return LessonStatsSummary(
      wpmAvg: avgWpm,
      accuracyAvg: avgAccuracy,
      lessonsCompleted: lessons,
      streakDays: streak,
      totalTime: totalTime,
    );
  }

  int _calculateStreakDays(List<LessonTrendPoint> trend) {
    if (trend.isEmpty) {
      return 0;
    }
    final sorted = [...trend]..sort((a, b) => b.date.compareTo(a.date));
    var streak = 0;
    DateTime? previous;
    for (final point in sorted) {
      final date = DateTime.tryParse(point.date);
      if (date == null) {
        continue;
      }
      if (previous == null) {
        streak = 1;
        previous = date;
        continue;
      }
      final expected = previous.subtract(const Duration(days: 1));
      if (_isSameDate(date, expected)) {
        streak += 1;
        previous = date;
      } else if (date.isBefore(expected)) {
        break;
      }
    }
    return streak;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
