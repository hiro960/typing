// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioSettings _$AudioSettingsFromJson(Map<String, dynamic> json) =>
    _AudioSettings(
      speechRate: (json['speechRate'] as num?)?.toDouble() ?? 1.0,
      autoPlay: json['autoPlay'] as bool? ?? false,
      voiceEngine: json['voiceEngine'] as String?,
    );

Map<String, dynamic> _$AudioSettingsToJson(_AudioSettings instance) =>
    <String, dynamic>{
      'speechRate': instance.speechRate,
      'autoPlay': instance.autoPlay,
      'voiceEngine': instance.voiceEngine,
    };
