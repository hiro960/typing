import 'dart:convert';

/// 表示設定（文字サイズのスケール係数）
class DisplaySettings {
  const DisplaySettings({
    this.promptFontScale = 1.0,
    this.dictionaryFontScale = 1.0,
  });

  /// 問題文の文字サイズスケール（0.8〜1.8、デフォルト1.0）
  final double promptFontScale;

  /// 辞典・単語帳の文字サイズスケール（0.8〜1.8、デフォルト1.0）
  final double dictionaryFontScale;

  /// スケールの最小値
  static const double minScale = 0.8;

  /// スケールの最大値
  static const double maxScale = 1.8;

  /// スケールのデフォルト値
  static const double defaultScale = 1.0;

  DisplaySettings copyWith({
    double? promptFontScale,
    double? dictionaryFontScale,
  }) {
    return DisplaySettings(
      promptFontScale: promptFontScale ?? this.promptFontScale,
      dictionaryFontScale: dictionaryFontScale ?? this.dictionaryFontScale,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promptFontScale': promptFontScale,
      'dictionaryFontScale': dictionaryFontScale,
    };
  }

  static DisplaySettings fromJson(Map<String, dynamic> json) {
    return DisplaySettings(
      promptFontScale: _clampScale(json['promptFontScale'] as double?),
      dictionaryFontScale: _clampScale(json['dictionaryFontScale'] as double?),
    );
  }

  static DisplaySettings fromRaw(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const DisplaySettings();
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return DisplaySettings.fromJson(decoded);
    } catch (_) {
      return const DisplaySettings();
    }
  }

  /// スケール値を有効範囲内に収める
  static double _clampScale(double? value) {
    if (value == null) return defaultScale;
    return value.clamp(minScale, maxScale);
  }
}
