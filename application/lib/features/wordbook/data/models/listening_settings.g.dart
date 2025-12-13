// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListeningSettings _$ListeningSettingsFromJson(Map<String, dynamic> json) =>
    _ListeningSettings(
      speechRate: (json['speechRate'] as num?)?.toDouble() ?? 1.0,
      japaneseToKoreanMs: (json['japaneseToKoreanMs'] as num?)?.toInt() ?? 500,
      wordToWordMs: (json['wordToWordMs'] as num?)?.toInt() ?? 1000,
    );

Map<String, dynamic> _$ListeningSettingsToJson(_ListeningSettings instance) =>
    <String, dynamic>{
      'speechRate': instance.speechRate,
      'japaneseToKoreanMs': instance.japaneseToKoreanMs,
      'wordToWordMs': instance.wordToWordMs,
    };
