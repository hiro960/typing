import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/typing_settings.dart';

extension _AsyncValueTypings<T> on AsyncValue<T> {
  T? get valueOrNull => when(
        data: (value) => value,
        error: (_, __) => null,
        loading: () => null,
      );
}

class TypingSettingsController extends AsyncNotifier<TypingSettings> {
  static const _prefsKey = 'typing_settings_v1';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<TypingSettings> build() async {
    final prefs = await _preferences;
    final stored = prefs.getString(_prefsKey);
    return TypingSettings.fromRaw(stored);
  }

  Future<void> toggleHints(bool value) async {
    final current = state.valueOrNull ?? const TypingSettings();
    await _save(current.copyWith(hintsEnabled: value));
  }

  Future<void> toggleKeySound(bool value) async {
    final current = state.valueOrNull ?? const TypingSettings();
    await _save(current.copyWith(keySoundEnabled: value));
  }

  Future<void> toggleHaptics(bool value) async {
    final current = state.valueOrNull ?? const TypingSettings();
    await _save(current.copyWith(hapticsEnabled: value));
  }

  Future<void> _save(TypingSettings settings) async {
    state = AsyncData(settings);
    final prefs = await _preferences;
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));
  }
}

final typingSettingsProvider =
    AsyncNotifierProvider<TypingSettingsController, TypingSettings>(
  TypingSettingsController.new,
);
