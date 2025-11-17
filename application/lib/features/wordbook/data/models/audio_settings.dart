// ignore_for_file: non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_settings.freezed.dart';
part 'audio_settings.g.dart';

@freezed
abstract class AudioSettings with _$AudioSettings {
  const factory AudioSettings({
    @Default(0.5) double speechRate,
    @Default(false) bool autoPlay,
    String? voiceEngine,
  }) = _AudioSettings;

  factory AudioSettings.fromJson(Map<String, dynamic> json) =>
      _$AudioSettingsFromJson(json);
}
