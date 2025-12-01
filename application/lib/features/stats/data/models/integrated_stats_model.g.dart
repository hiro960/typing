// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integrated_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IntegratedStats _$IntegratedStatsFromJson(
  Map<String, dynamic> json,
) => _IntegratedStats(
  totalTimeSpent: (json['totalTimeSpent'] as num).toInt(),
  streakDays: (json['streakDays'] as num).toInt(),
  maxWpm: (json['maxWpm'] as num).toDouble(),
  avgWpm: (json['avgWpm'] as num).toDouble(),
  maxAccuracy: (json['maxAccuracy'] as num).toDouble(),
  avgAccuracy: (json['avgAccuracy'] as num).toDouble(),
  activeDays: (json['activeDays'] as num).toInt(),
  breakdown: StatsBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
  dailyTrend:
      (json['dailyTrend'] as List<dynamic>?)
          ?.map((e) => DailyActivityTrend.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DailyActivityTrend>[],
);

Map<String, dynamic> _$IntegratedStatsToJson(_IntegratedStats instance) =>
    <String, dynamic>{
      'totalTimeSpent': instance.totalTimeSpent,
      'streakDays': instance.streakDays,
      'maxWpm': instance.maxWpm,
      'avgWpm': instance.avgWpm,
      'maxAccuracy': instance.maxAccuracy,
      'avgAccuracy': instance.avgAccuracy,
      'activeDays': instance.activeDays,
      'breakdown': instance.breakdown,
      'dailyTrend': instance.dailyTrend,
    };

_StatsBreakdown _$StatsBreakdownFromJson(Map<String, dynamic> json) =>
    _StatsBreakdown(
      lesson: ActivityBreakdown.fromJson(
        json['lesson'] as Map<String, dynamic>,
      ),
      rankingGame: ActivityBreakdown.fromJson(
        json['rankingGame'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$StatsBreakdownToJson(_StatsBreakdown instance) =>
    <String, dynamic>{
      'lesson': instance.lesson,
      'rankingGame': instance.rankingGame,
    };

_ActivityBreakdown _$ActivityBreakdownFromJson(Map<String, dynamic> json) =>
    _ActivityBreakdown(
      count: (json['count'] as num).toInt(),
      timeSpent: (json['timeSpent'] as num).toInt(),
      avgAccuracy: (json['avgAccuracy'] as num).toDouble(),
    );

Map<String, dynamic> _$ActivityBreakdownToJson(_ActivityBreakdown instance) =>
    <String, dynamic>{
      'count': instance.count,
      'timeSpent': instance.timeSpent,
      'avgAccuracy': instance.avgAccuracy,
    };

_DailyActivityTrend _$DailyActivityTrendFromJson(Map<String, dynamic> json) =>
    _DailyActivityTrend(
      date: json['date'] as String,
      lessonTime: (json['lessonTime'] as num).toInt(),
      rankingGameTime: (json['rankingGameTime'] as num).toInt(),
      wpm: (json['wpm'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DailyActivityTrendToJson(_DailyActivityTrend instance) =>
    <String, dynamic>{
      'date': instance.date,
      'lessonTime': instance.lessonTime,
      'rankingGameTime': instance.rankingGameTime,
      'wpm': instance.wpm,
      'accuracy': instance.accuracy,
    };
