import 'dart:convert';

class TypingSettings {
  const TypingSettings({
    this.hintsEnabled = true,
    this.hapticsEnabled = true,
    this.useCustomKeyboard = true,
  });

  final bool hintsEnabled;
  final bool hapticsEnabled;
  final bool useCustomKeyboard;

  TypingSettings copyWith({
    bool? hintsEnabled,
    bool? hapticsEnabled,
    bool? useCustomKeyboard,
  }) {
    return TypingSettings(
      hintsEnabled: hintsEnabled ?? this.hintsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      useCustomKeyboard: useCustomKeyboard ?? this.useCustomKeyboard,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hintsEnabled': hintsEnabled,
      'hapticsEnabled': hapticsEnabled,
      'useCustomKeyboard': useCustomKeyboard,
    };
  }

  static TypingSettings fromJson(Map<String, dynamic> json) {
    return TypingSettings(
      hintsEnabled: json['hintsEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      useCustomKeyboard: json['useCustomKeyboard'] as bool? ?? true,
    );
  }

  static TypingSettings fromRaw(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const TypingSettings();
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return TypingSettings.fromJson(decoded);
    } catch (_) {
      return const TypingSettings();
    }
  }
}
