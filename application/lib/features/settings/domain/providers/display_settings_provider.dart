import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/models/display_settings.dart';

class DisplaySettingsController extends AsyncNotifier<DisplaySettings> {
  static const _prefsKey = 'display_settings_v1';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await ref.read(sharedPreferencesProvider.future);
    return _prefs!;
  }

  @override
  Future<DisplaySettings> build() async {
    final prefs = await _preferences;
    final stored = prefs.getString(_prefsKey);
    return DisplaySettings.fromRaw(stored);
  }

  /// 問題文の文字サイズスケールを設定
  Future<void> setPromptFontScale(double scale) async {
    final current = state.value ?? const DisplaySettings();
    final clampedScale = scale.clamp(
      DisplaySettings.minScale,
      DisplaySettings.maxScale,
    );
    await _save(current.copyWith(promptFontScale: clampedScale));
  }

  /// 辞典・単語帳の文字サイズスケールを設定
  Future<void> setDictionaryFontScale(double scale) async {
    final current = state.value ?? const DisplaySettings();
    final clampedScale = scale.clamp(
      DisplaySettings.minScale,
      DisplaySettings.maxScale,
    );
    await _save(current.copyWith(dictionaryFontScale: clampedScale));
  }

  Future<void> _save(DisplaySettings settings) async {
    state = AsyncData(settings);
    final prefs = await _preferences;
    await prefs.setString(_prefsKey, jsonEncode(settings.toJson()));
  }
}

final displaySettingsProvider =
    AsyncNotifierProvider<DisplaySettingsController, DisplaySettings>(
  DisplaySettingsController.new,
);
