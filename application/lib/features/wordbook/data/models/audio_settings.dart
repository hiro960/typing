// ignore_for_file: non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_settings.freezed.dart';
part 'audio_settings.g.dart';

@freezed
abstract class AudioSettings with _$AudioSettings {
  /// speechRate は倍速表記（1.0 = 標準速度、0.5 = 半分、2.0 = 2倍速）
  /// プラットフォームごとの実際のTTS値への変換はWordAudioServiceで行う
  const factory AudioSettings({
    @Default(1.0) double speechRate,
    @Default(false) bool autoPlay,
    String? voiceEngine,
  }) = _AudioSettings;

  /// speechRate の有効範囲
  static const double minRate = 0.5;
  static const double maxRate = 2.0;

  factory AudioSettings.fromJson(Map<String, dynamic> json) =>
      _$AudioSettingsFromJson(json);
}
