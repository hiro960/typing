class WeakKey {
  const WeakKey({
    required this.key,
    required this.count,
  });

  final String key;
  final int count;

  factory WeakKey.fromJson(Map<String, dynamic> json) {
    return WeakKey(
      key: json['key'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class DailyTrend {
  const DailyTrend({
    required this.date,
    required this.wpm,
    required this.accuracy,
  });

  final String date;
  final int wpm;
  final double accuracy;

  factory DailyTrend.fromJson(Map<String, dynamic> json) {
    return DailyTrend(
      date: json['date'] as String? ?? '',
      wpm: json['wpm'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LearningHabits {
  const LearningHabits({
    required this.byHour,
    required this.byDayOfWeek,
  });

  final List<int> byHour;
  final List<int> byDayOfWeek;

  factory LearningHabits.fromJson(Map<String, dynamic> json) {
    return LearningHabits(
      byHour: (json['byHour'] as List<dynamic>?)?.cast<int>() ?? [],
      byDayOfWeek: (json['byDayOfWeek'] as List<dynamic>?)?.cast<int>() ?? [],
    );
  }
}

class AnalysisDashboard {
  const AnalysisDashboard({
    required this.weakKeys,
    required this.trends,
    required this.habits,
  });

  final List<WeakKey> weakKeys;
  final List<DailyTrend> trends;
  final LearningHabits habits;

  factory AnalysisDashboard.fromJson(Map<String, dynamic> json) {
    return AnalysisDashboard(
      weakKeys: (json['weakKeys'] as List<dynamic>?)
              ?.map((e) => WeakKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trends: (json['trends'] as List<dynamic>?)
              ?.map((e) => DailyTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      habits: LearningHabits.fromJson(
        json['habits'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
