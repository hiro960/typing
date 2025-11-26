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
    required this.practiceTime,
    required this.vocabularyStatus,
    required this.vocabularyGrowth,
  });

  final List<WeakKey> weakKeys;
  final List<DailyTrend> trends;
  final LearningHabits habits;
  final PracticeTimeStats practiceTime;
  final VocabularyStatus vocabularyStatus;
  final List<VocabularyGrowthPoint> vocabularyGrowth;

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
      practiceTime: PracticeTimeStats.fromJson(
        json['practiceTime'] as Map<String, dynamic>? ?? {},
      ),
      vocabularyStatus: VocabularyStatus.fromJson(
        json['vocabularyStatus'] as Map<String, dynamic>? ?? {},
      ),
      vocabularyGrowth: (json['vocabularyGrowth'] as List<dynamic>?)
              ?.map((e) => VocabularyGrowthPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 練習時間統計
class PracticeTimeStats {
  const PracticeTimeStats({
    this.totalTimeMs = 0,
    this.sessionCount = 0,
    this.averageTimeMs = 0,
    this.dailyPracticeTime = const [],
  });

  final int totalTimeMs;
  final int sessionCount;
  final int averageTimeMs;
  final List<DailyPracticeTime> dailyPracticeTime;

  factory PracticeTimeStats.fromJson(Map<String, dynamic> json) {
    return PracticeTimeStats(
      totalTimeMs: json['totalTimeMs'] as int? ?? 0,
      sessionCount: json['sessionCount'] as int? ?? 0,
      averageTimeMs: json['averageTimeMs'] as int? ?? 0,
      dailyPracticeTime: (json['dailyPracticeTime'] as List<dynamic>?)
              ?.map((e) => DailyPracticeTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DailyPracticeTime {
  const DailyPracticeTime({
    required this.date,
    required this.timeMs,
  });

  final String date;
  final int timeMs;

  factory DailyPracticeTime.fromJson(Map<String, dynamic> json) {
    return DailyPracticeTime(
      date: json['date'] as String? ?? '',
      timeMs: json['timeMs'] as int? ?? 0,
    );
  }
}

/// 語彙習得状況
class VocabularyStatus {
  const VocabularyStatus({
    this.mastered = 0,
    this.reviewing = 0,
    this.needsReview = 0,
    this.total = 0,
  });

  final int mastered;
  final int reviewing;
  final int needsReview;
  final int total;

  factory VocabularyStatus.fromJson(Map<String, dynamic> json) {
    return VocabularyStatus(
      mastered: json['mastered'] as int? ?? 0,
      reviewing: json['reviewing'] as int? ?? 0,
      needsReview: json['needsReview'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

/// 語彙成長推移
class VocabularyGrowthPoint {
  const VocabularyGrowthPoint({
    required this.month,
    required this.added,
    required this.mastered,
  });

  final String month;
  final int added;
  final int mastered;

  factory VocabularyGrowthPoint.fromJson(Map<String, dynamic> json) {
    return VocabularyGrowthPoint(
      month: json['month'] as String? ?? '',
      added: json['added'] as int? ?? 0,
      mastered: json['mastered'] as int? ?? 0,
    );
  }
}
