class UserStatsModel {
  const UserStatsModel({
    required this.wpmAvg,
    required this.accuracyAvg,
    required this.lessonsCompleted,
    required this.streakDays,
    required this.histories,
  });

  final double wpmAvg;
  final double accuracyAvg;
  final int lessonsCompleted;
  final int streakDays;
  final List<StatsHistory> histories;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      wpmAvg: (json['wpmAvg'] as num?)?.toDouble() ?? 0.0,
      accuracyAvg: (json['accuracyAvg'] as num?)?.toDouble() ?? 0.0,
      lessonsCompleted: (json['lessonsCompleted'] as int?) ?? 0,
      streakDays: (json['streakDays'] as int?) ?? 0,
      histories: (json['histories'] as List<dynamic>?)
              ?.map((e) => StatsHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wpmAvg': wpmAvg,
      'accuracyAvg': accuracyAvg,
      'lessonsCompleted': lessonsCompleted,
      'streakDays': streakDays,
      'histories': histories.map((e) => e.toJson()).toList(),
    };
  }
}

class StatsHistory {
  const StatsHistory({
    required this.date,
    required this.wpm,
    required this.accuracy,
  });

  final String date; // "YYYY-MM-DD"
  final double wpm;
  final double accuracy;

  factory StatsHistory.fromJson(Map<String, dynamic> json) {
    return StatsHistory(
      date: json['date'] as String? ?? '',
      wpm: (json['wpm'] as num?)?.toDouble() ?? 0.0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'wpm': wpm,
      'accuracy': accuracy,
    };
  }
}
