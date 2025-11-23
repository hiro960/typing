// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WritingEntry _$WritingEntryFromJson(Map<String, dynamic> json) =>
    _WritingEntry(
      id: json['id'] as String,
      level: $enumDecode(_$EntryLevelEnumMap, json['level']),
      jpText: json['jpText'] as String,
      koText: json['koText'] as String,
    );

Map<String, dynamic> _$WritingEntryToJson(_WritingEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': _$EntryLevelEnumMap[instance.level]!,
      'jpText': instance.jpText,
      'koText': instance.koText,
    };

const _$EntryLevelEnumMap = {
  EntryLevel.template: 'template',
  EntryLevel.basic: 'basic',
  EntryLevel.advanced: 'advanced',
  EntryLevel.sentence: 'sentence',
};

_WritingTopic _$WritingTopicFromJson(Map<String, dynamic> json) =>
    _WritingTopic(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      patternId: json['patternId'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => WritingEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WritingTopicToJson(_WritingTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'patternId': instance.patternId,
      'entries': instance.entries,
    };

_WritingPattern _$WritingPatternFromJson(Map<String, dynamic> json) =>
    _WritingPattern(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => WritingTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WritingPatternToJson(_WritingPattern instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'topics': instance.topics,
    };

_EntryResult _$EntryResultFromJson(Map<String, dynamic> json) => _EntryResult(
  entryId: json['entryId'] as String,
  correct: json['correct'] as bool,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$EntryResultToJson(_EntryResult instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'correct': instance.correct,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_WritingCompletion _$WritingCompletionFromJson(Map<String, dynamic> json) =>
    _WritingCompletion(
      id: json['id'] as String,
      patternId: json['patternId'] as String,
      topicId: json['topicId'] as String,
      mode: $enumDecode(_$WritingModeEnumMap, json['mode']),
      timeSpent: (json['timeSpent'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      results: (json['results'] as List<dynamic>)
          .map((e) => EntryResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WritingCompletionToJson(_WritingCompletion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patternId': instance.patternId,
      'topicId': instance.topicId,
      'mode': _$WritingModeEnumMap[instance.mode]!,
      'timeSpent': instance.timeSpent,
      'completedAt': instance.completedAt.toIso8601String(),
      'results': instance.results,
    };

const _$WritingModeEnumMap = {
  WritingMode.typing: 'typing',
  WritingMode.list: 'list',
};

_WritingStats _$WritingStatsFromJson(Map<String, dynamic> json) =>
    _WritingStats(
      totalCompletions: (json['totalCompletions'] as num?)?.toInt() ?? 0,
      totalCorrect: (json['totalCorrect'] as num?)?.toInt() ?? 0,
      totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
      patternCompletions:
          (json['patternCompletions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$WritingStatsToJson(_WritingStats instance) =>
    <String, dynamic>{
      'totalCompletions': instance.totalCompletions,
      'totalCorrect': instance.totalCorrect,
      'totalAttempts': instance.totalAttempts,
      'patternCompletions': instance.patternCompletions,
    };
