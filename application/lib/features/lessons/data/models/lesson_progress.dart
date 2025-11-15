class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    this.completionRate = 0,
    this.lastCompletedAt,
    this.bestWpm,
    this.bestAccuracy,
  });

  final String lessonId;
  final int completionRate;
  final DateTime? lastCompletedAt;
  final int? bestWpm;
  final double? bestAccuracy;

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String? ?? '',
      completionRate: json['completionRate'] as int? ?? 0,
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.tryParse(json['lastCompletedAt'] as String)
          : null,
      bestWpm: json['bestWpm'] as int?,
      bestAccuracy: (json['bestAccuracy'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'completionRate': completionRate,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'bestWpm': bestWpm,
      'bestAccuracy': bestAccuracy,
    };
  }

  LessonProgress copyWith({
    int? completionRate,
    DateTime? lastCompletedAt,
    int? bestWpm,
    double? bestAccuracy,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      completionRate: completionRate ?? this.completionRate,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      bestWpm: bestWpm ?? this.bestWpm,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
    );
  }

  int get normalizedCompletionRate {
    if (completionRate <= 0) {
      return 0;
    }
    if (completionRate >= 100) {
      return 100;
    }
    final steps = (completionRate / 25).round();
    final normalized = steps * 25;
    if (normalized < 0) {
      return 0;
    }
    if (normalized > 100) {
      return 100;
    }
    return normalized;
  }
}

class LessonStatsSummary {
  const LessonStatsSummary({
    this.wpmAvg = 0,
    this.accuracyAvg = 0,
    this.lessonsCompleted = 0,
    this.streakDays = 0,
    this.totalTime = Duration.zero,
  });

  final double wpmAvg;
  final double accuracyAvg;
  final int lessonsCompleted;
  final int streakDays;
  final Duration totalTime;
}
