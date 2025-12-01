import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/shared_preferences_provider.dart';

class ThemeModeController extends AsyncNotifier<ThemeMode> {
  static const _prefsKey = 'theme_mode';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    // 共通プロバイダーから取得（main.dartで事前初期化済み）
    _prefs ??= await ref.read(sharedPreferencesProvider.future);
    return _prefs!;
  }

  @override
  Future<ThemeMode> build() async {
    final prefs = await _preferences;
    final stored = prefs.getString(_prefsKey);
    if (stored == 'light') return ThemeMode.light;
    // default dark
    return ThemeMode.dark;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncData(mode);
    final prefs = await _preferences;
    await prefs.setString(_prefsKey, mode == ThemeMode.light ? 'light' : 'dark');
  }

  Future<void> toggle(bool isDarkOn) => setMode(isDarkOn ? ThemeMode.dark : ThemeMode.light);
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
