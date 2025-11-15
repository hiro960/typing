import 'dart:convert';

class TypingSettings {
  const TypingSettings({
    this.hintsEnabled = true,
    this.keySoundEnabled = false,
    this.hapticsEnabled = true,
  });

  final bool hintsEnabled;
  final bool keySoundEnabled;
  final bool hapticsEnabled;

  TypingSettings copyWith({
    bool? hintsEnabled,
    bool? keySoundEnabled,
    bool? hapticsEnabled,
  }) {
    return TypingSettings(
      hintsEnabled: hintsEnabled ?? this.hintsEnabled,
      keySoundEnabled: keySoundEnabled ?? this.keySoundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hintsEnabled': hintsEnabled,
      'keySoundEnabled': keySoundEnabled,
      'hapticsEnabled': hapticsEnabled,
    };
  }

  static TypingSettings fromJson(Map<String, dynamic> json) {
    return TypingSettings(
      hintsEnabled: json['hintsEnabled'] as bool? ?? true,
      keySoundEnabled: json['keySoundEnabled'] as bool? ?? false,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
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
