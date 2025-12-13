// ignore_for_file: non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'listening_settings.freezed.dart';
part 'listening_settings.g.dart';

@freezed
abstract class ListeningSettings with _$ListeningSettings {
  const factory ListeningSettings({
    /// 再生速度 (0.5 ~ 1.5)
    @Default(1.0) double speechRate,

    /// 日本語から韓国語への間隔 (ミリ秒)
    @Default(500) int japaneseToKoreanMs,

    /// 単語間の間隔 (ミリ秒)
    @Default(1000) int wordToWordMs,
  }) = _ListeningSettings;

  factory ListeningSettings.fromJson(Map<String, dynamic> json) =>
      _$ListeningSettingsFromJson(json);
}
