import 'lesson_models.dart';

class LessonStatsResponse {
  const LessonStatsResponse({
    required this.totals,
    this.trend = const [],
    this.weakCharacters = const [],
    this.recommendedLessons = const [],
  });

  final LessonStatsTotals totals;
  final List<LessonTrendPoint> trend;
  final List<String> weakCharacters;
  final List<Lesson> recommendedLessons;

  factory LessonStatsResponse.fromJson(Map<String, dynamic> json) {
    final trendJson = json['trend'] as List<dynamic>? ?? const [];
    final lessonsJson =
        json['recommendedLessons'] as List<dynamic>? ?? const [];
    return LessonStatsResponse(
      totals: LessonStatsTotals.fromJson(
        json['totals'] as Map<String, dynamic>? ?? const {},
      ),
      trend: trendJson
          .whereType<Map<String, dynamic>>()
          .map(LessonTrendPoint.fromJson)
          .toList(),
      weakCharacters: (json['weakCharacters'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      recommendedLessons: lessonsJson
          .whereType<Map<String, dynamic>>()
          .map(Lesson.fromJson)
          .toList(),
    );
  }
}

class LessonStatsTotals {
  const LessonStatsTotals({this.lessons = 0, this.timeSpent = 0});

  final int lessons;
  final int timeSpent;

  factory LessonStatsTotals.fromJson(Map<String, dynamic> json) {
    return LessonStatsTotals(
      lessons: json['lessons'] as int? ?? 0,
      timeSpent: json['timeSpent'] as int? ?? 0,
    );
  }
}

class LessonTrendPoint {
  const LessonTrendPoint({
    required this.date,
    this.wpmAvg = 0,
    this.accuracyAvg = 0,
  });

  final String date;
  final double wpmAvg;
  final double accuracyAvg;

  factory LessonTrendPoint.fromJson(Map<String, dynamic> json) {
    return LessonTrendPoint(
      date: json['date'] as String? ?? '',
      wpmAvg: (json['wpmAvg'] as num?)?.toDouble() ?? 0,
      accuracyAvg: (json['accuracyAvg'] as num?)?.toDouble() ?? 0,
    );
  }
}
