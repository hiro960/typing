// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'original_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OriginalContent _$OriginalContentFromJson(Map<String, dynamic> json) =>
    _OriginalContent(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      audioPath: json['audioPath'] as String,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      practiceCount: (json['practiceCount'] as num?)?.toInt() ?? 0,
      segments:
          (json['segments'] as List<dynamic>?)
              ?.map((e) => TextSegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TextSegment>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastPracticed: json['lastPracticed'] == null
          ? null
          : DateTime.parse(json['lastPracticed'] as String),
    );

Map<String, dynamic> _$OriginalContentToJson(_OriginalContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'audioPath': instance.audioPath,
      'durationSeconds': instance.durationSeconds,
      'practiceCount': instance.practiceCount,
      'segments': instance.segments,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastPracticed': instance.lastPracticed?.toIso8601String(),
    };

_OriginalContentDataFile _$OriginalContentDataFileFromJson(
  Map<String, dynamic> json,
) => _OriginalContentDataFile(
  version: json['version'] as String? ?? '1.0.0',
  contents:
      (json['contents'] as List<dynamic>?)
          ?.map((e) => OriginalContent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OriginalContent>[],
);

Map<String, dynamic> _$OriginalContentDataFileToJson(
  _OriginalContentDataFile instance,
) => <String, dynamic>{
  'version': instance.version,
  'contents': instance.contents,
};
