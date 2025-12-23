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
    required this.activityBreakdown,
    required this.dailyActivityBreakdown,
    required this.diaryCalendar,
  });

  final List<WeakKey> weakKeys;
  final List<DailyTrend> trends;
  final LearningHabits habits;
  final PracticeTimeStats practiceTime;
  final VocabularyStatus vocabularyStatus;
  final List<VocabularyGrowthPoint> vocabularyGrowth;
  final ActivityBreakdown activityBreakdown;
  final List<DailyActivityBreakdown> dailyActivityBreakdown;
  final DiaryCalendar diaryCalendar;

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
      activityBreakdown: ActivityBreakdown.fromJson(
        json['activityBreakdown'] as Map<String, dynamic>? ?? {},
      ),
      dailyActivityBreakdown: (json['dailyActivityBreakdown'] as List<dynamic>?)
              ?.map((e) => DailyActivityBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      diaryCalendar: DiaryCalendar.fromJson(
        json['diaryCalendar'] as Map<String, dynamic>? ?? {},
      ),
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

/// アクティビティ種別の時間エントリ
class ActivityTimeEntry {
  const ActivityTimeEntry({
    this.timeSpentMs = 0,
    this.sessionCount = 0,
  });

  final int timeSpentMs;
  final int sessionCount;

  factory ActivityTimeEntry.fromJson(Map<String, dynamic> json) {
    return ActivityTimeEntry(
      timeSpentMs: json['timeSpentMs'] as int? ?? 0,
      sessionCount: json['sessionCount'] as int? ?? 0,
    );
  }
}

/// アクティビティ種別ごとの時間内訳
class ActivityBreakdown {
  const ActivityBreakdown({
    this.lesson = const ActivityTimeEntry(),
    this.rankingGame = const ActivityTimeEntry(),
    this.pronunciationGame = const ActivityTimeEntry(),
    this.quickTranslation = const ActivityTimeEntry(),
    this.writing = const ActivityTimeEntry(),
    this.hanjaQuiz = const ActivityTimeEntry(),
  });

  final ActivityTimeEntry lesson;
  final ActivityTimeEntry rankingGame;
  final ActivityTimeEntry pronunciationGame;
  final ActivityTimeEntry quickTranslation;
  final ActivityTimeEntry writing;
  final ActivityTimeEntry hanjaQuiz;

  factory ActivityBreakdown.fromJson(Map<String, dynamic> json) {
    return ActivityBreakdown(
      lesson: ActivityTimeEntry.fromJson(
        json['lesson'] as Map<String, dynamic>? ?? {},
      ),
      rankingGame: ActivityTimeEntry.fromJson(
        json['rankingGame'] as Map<String, dynamic>? ?? {},
      ),
      pronunciationGame: ActivityTimeEntry.fromJson(
        json['pronunciationGame'] as Map<String, dynamic>? ?? {},
      ),
      quickTranslation: ActivityTimeEntry.fromJson(
        json['quickTranslation'] as Map<String, dynamic>? ?? {},
      ),
      writing: ActivityTimeEntry.fromJson(
        json['writing'] as Map<String, dynamic>? ?? {},
      ),
      hanjaQuiz: ActivityTimeEntry.fromJson(
        json['hanjaQuiz'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// 記録があるアクティビティのみを取得
  List<MapEntry<String, ActivityTimeEntry>> get activeEntries {
    final all = {
      'lesson': lesson,
      'rankingGame': rankingGame,
      'pronunciationGame': pronunciationGame,
      'quickTranslation': quickTranslation,
      'writing': writing,
      'hanjaQuiz': hanjaQuiz,
    };
    return all.entries.where((e) => e.value.timeSpentMs > 0).toList();
  }

  /// 総時間（ミリ秒）
  int get totalTimeMs =>
      lesson.timeSpentMs +
      rankingGame.timeSpentMs +
      pronunciationGame.timeSpentMs +
      quickTranslation.timeSpentMs +
      writing.timeSpentMs +
      hanjaQuiz.timeSpentMs;
}

/// 日記カレンダー
class DiaryCalendar {
  const DiaryCalendar({
    required this.year,
    required this.month,
    required this.postDates,
    this.totalPosts = 0,
  });

  final int year;
  final int month;
  final List<String> postDates; // ['2025-01-01', '2025-01-03', ...]
  final int totalPosts;

  factory DiaryCalendar.fromJson(Map<String, dynamic> json) {
    return DiaryCalendar(
      year: json['year'] as int? ?? DateTime.now().year,
      month: json['month'] as int? ?? DateTime.now().month,
      postDates: (json['postDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      totalPosts: json['totalPosts'] as int? ?? 0,
    );
  }

  /// Check if diary was posted on a specific date
  bool hasPostOn(DateTime date) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return postDates.contains(dateKey);
  }
}

/// 日別アクティビティ内訳
class DailyActivityBreakdown {
  const DailyActivityBreakdown({
    required this.date,
    this.lessonTimeMs = 0,
    this.rankingGameTimeMs = 0,
    this.pronunciationGameTimeMs = 0,
    this.quickTranslationTimeMs = 0,
    this.writingTimeMs = 0,
    this.hanjaQuizTimeMs = 0,
  });

  final String date;
  final int lessonTimeMs;
  final int rankingGameTimeMs;
  final int pronunciationGameTimeMs;
  final int quickTranslationTimeMs;
  final int writingTimeMs;
  final int hanjaQuizTimeMs;

  factory DailyActivityBreakdown.fromJson(Map<String, dynamic> json) {
    return DailyActivityBreakdown(
      date: json['date'] as String? ?? '',
      lessonTimeMs: json['lessonTimeMs'] as int? ?? 0,
      rankingGameTimeMs: json['rankingGameTimeMs'] as int? ?? 0,
      pronunciationGameTimeMs: json['pronunciationGameTimeMs'] as int? ?? 0,
      quickTranslationTimeMs: json['quickTranslationTimeMs'] as int? ?? 0,
      writingTimeMs: json['writingTimeMs'] as int? ?? 0,
      hanjaQuizTimeMs: json['hanjaQuizTimeMs'] as int? ?? 0,
    );
  }

  int get totalTimeMs =>
      lessonTimeMs +
      rankingGameTimeMs +
      pronunciationGameTimeMs +
      quickTranslationTimeMs +
      writingTimeMs +
      hanjaQuizTimeMs;

  /// アクティビティキーから時間を取得
  int getTimeForActivity(String activityKey) {
    switch (activityKey) {
      case 'lesson':
        return lessonTimeMs;
      case 'rankingGame':
        return rankingGameTimeMs;
      case 'pronunciationGame':
        return pronunciationGameTimeMs;
      case 'quickTranslation':
        return quickTranslationTimeMs;
      case 'writing':
        return writingTimeMs;
      case 'hanjaQuiz':
        return hanjaQuizTimeMs;
      default:
        return 0;
    }
  }
}
