import 'package:flutter/material.dart';
import '../data/models/display_settings.dart';

/// 数値のfontSizeに問題文スケールを適用する拡張
extension PromptFontScaleDoubleExtension on double {
  /// 問題文用のスケールを適用
  double withPromptScale(DisplaySettings settings) {
    return this * settings.promptFontScale;
  }

  /// 辞典・単語帳用のスケールを適用
  double withDictionaryScale(DisplaySettings settings) {
    return this * settings.dictionaryFontScale;
  }
}

/// TextStyleに問題文スケールを適用する拡張
extension PromptTextStyleScaleExtension on TextStyle {
  /// 問題文用のスケールを適用
  TextStyle withPromptScale(DisplaySettings settings) {
    final currentSize = fontSize ?? 14.0;
    return copyWith(fontSize: currentSize * settings.promptFontScale);
  }

  /// 辞典・単語帳用のスケールを適用
  TextStyle withDictionaryScale(DisplaySettings settings) {
    final currentSize = fontSize ?? 14.0;
    return copyWith(fontSize: currentSize * settings.dictionaryFontScale);
  }
}

/// TextStyleをnull許容で扱う拡張
extension NullableTextStyleScaleExtension on TextStyle? {
  /// 問題文用のスケールを適用（nullの場合はnullを返す）
  TextStyle? withPromptScale(DisplaySettings settings) {
    if (this == null) return null;
    final currentSize = this!.fontSize ?? 14.0;
    return this!.copyWith(fontSize: currentSize * settings.promptFontScale);
  }

  /// 辞典・単語帳用のスケールを適用（nullの場合はnullを返す）
  TextStyle? withDictionaryScale(DisplaySettings settings) {
    if (this == null) return null;
    final currentSize = this!.fontSize ?? 14.0;
    return this!.copyWith(fontSize: currentSize * settings.dictionaryFontScale);
  }
}
