// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadowing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextSegment _$TextSegmentFromJson(Map<String, dynamic> json) => _TextSegment(
  index: (json['index'] as num).toInt(),
  text: json['text'] as String,
  meaning: json['meaning'] as String,
  startTime: (json['startTime'] as num).toDouble(),
  endTime: (json['endTime'] as num).toDouble(),
);

Map<String, dynamic> _$TextSegmentToJson(_TextSegment instance) =>
    <String, dynamic>{
      'index': instance.index,
      'text': instance.text,
      'meaning': instance.meaning,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

_ShadowingContent _$ShadowingContentFromJson(Map<String, dynamic> json) =>
    _ShadowingContent(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      meaning: json['meaning'] as String,
      audioPath: json['audioPath'] as String,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      tip: json['tip'] as String?,
      segments:
          (json['segments'] as List<dynamic>?)
              ?.map((e) => TextSegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TextSegment>[],
    );

Map<String, dynamic> _$ShadowingContentToJson(_ShadowingContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'meaning': instance.meaning,
      'audioPath': instance.audioPath,
      'durationSeconds': instance.durationSeconds,
      'tip': instance.tip,
      'segments': instance.segments,
    };

_ShadowingDataFile _$ShadowingDataFileFromJson(Map<String, dynamic> json) =>
    _ShadowingDataFile(
      version: json['version'] as String,
      level: json['level'] as String,
      contents:
          (json['contents'] as List<dynamic>?)
              ?.map((e) => ShadowingContent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ShadowingContent>[],
    );

Map<String, dynamic> _$ShadowingDataFileToJson(_ShadowingDataFile instance) =>
    <String, dynamic>{
      'version': instance.version,
      'level': instance.level,
      'contents': instance.contents,
    };

_ShadowingProgress _$ShadowingProgressFromJson(Map<String, dynamic> json) =>
    _ShadowingProgress(
      contentId: json['contentId'] as String,
      practiceCount: (json['practiceCount'] as num?)?.toInt() ?? 0,
      lastPracticed: json['lastPracticed'] == null
          ? null
          : DateTime.parse(json['lastPracticed'] as String),
    );

Map<String, dynamic> _$ShadowingProgressToJson(_ShadowingProgress instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'practiceCount': instance.practiceCount,
      'lastPracticed': instance.lastPracticed?.toIso8601String(),
    };
