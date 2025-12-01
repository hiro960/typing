import 'package:freezed_annotation/freezed_annotation.dart';

part 'integrated_stats_model.freezed.dart';
part 'integrated_stats_model.g.dart';

/// 統合統計（レッスン + ランキングゲーム）
@freezed
abstract class IntegratedStats with _$IntegratedStats {
  const factory IntegratedStats({
    required int totalTimeSpent,
    required int streakDays,
    required double maxWpm,
    required double avgWpm,
    required double maxAccuracy,
    required double avgAccuracy,
    required int activeDays,
    required StatsBreakdown breakdown,
    @Default(<DailyActivityTrend>[]) List<DailyActivityTrend> dailyTrend,
  }) = _IntegratedStats;

  factory IntegratedStats.fromJson(Map<String, dynamic> json) =>
      _$IntegratedStatsFromJson(json);
}

/// アクティビティタイプ別の統計
@freezed
abstract class StatsBreakdown with _$StatsBreakdown {
  const factory StatsBreakdown({
    required ActivityBreakdown lesson,
    required ActivityBreakdown rankingGame,
  }) = _StatsBreakdown;

  factory StatsBreakdown.fromJson(Map<String, dynamic> json) =>
      _$StatsBreakdownFromJson(json);
}

/// 個別アクティビティの統計
@freezed
abstract class ActivityBreakdown with _$ActivityBreakdown {
  const factory ActivityBreakdown({
    required int count,
    required int timeSpent,
    required double avgAccuracy,
  }) = _ActivityBreakdown;

  factory ActivityBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ActivityBreakdownFromJson(json);
}

/// 日別のアクティビティトレンド
@freezed
abstract class DailyActivityTrend with _$DailyActivityTrend {
  const factory DailyActivityTrend({
    required String date,
    required int lessonTime,
    required int rankingGameTime,
    double? wpm,
    double? accuracy,
  }) = _DailyActivityTrend;

  factory DailyActivityTrend.fromJson(Map<String, dynamic> json) =>
      _$DailyActivityTrendFromJson(json);
}
