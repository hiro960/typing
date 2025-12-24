import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/app_theme.dart';
import 'ui/shell/app_shell.dart';
import 'core/config/env_config.dart';
import 'core/utils/logger.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/theme/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferencesを事前に初期化（起動時間短縮）
  late final SharedPreferences prefs;

  try {
    // 環境変数を読み込み
    await dotenv.load(fileName: '.env');

    // 環境変数の検証
    EnvConfig.validate();

    // SharedPreferencesを1回だけ初期化
    prefs = await SharedPreferences.getInstance();
  } catch (e, stackTrace) {
    AppLogger.error(
      'Failed to load environment variables',
      error: e,
      stackTrace: stackTrace,
    );
    // 開発環境でのみエラーを表示
    if (EnvConfig.isDevelopment) {
      runApp(ErrorApp(error: e.toString()));
      return;
    }
    // SharedPreferencesが初期化されていない場合はここで初期化
    prefs = await SharedPreferences.getInstance();
  }

  runApp(
    // RiverpodのProviderScopeでアプリ全体をラップ
    ProviderScope(
      overrides: [
        // 事前初期化したSharedPreferencesを注入
        sharedPreferencesProvider.overrideWith((ref) async => prefs),
      ],
      child: const TypingApp(),
    ),
  );
}

class TypingApp extends ConsumerWidget {
  const TypingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.dark;
    final foruiTheme =
        themeMode == ThemeMode.dark ? AppTheme.foruiDark() : AppTheme.foruiLight();

    return MaterialApp(
      title: '韓国語タイピング',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) => FTheme(
        data: foruiTheme,
        child: FToaster(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // AndroidのみSafeAreaのbottomを有効化（iPhoneは適用しない）
              bottom: Platform.isAndroid,
              top: false,
              left: false,
              right: false,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      // AppShellが認証状態に基づいて画面を切り替え
      home: const AppShell(),
    );
  }
}

/// 環境変数読み込みエラー時に表示するアプリ
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.warning_2,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  '環境設定エラー',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  '.envファイルを確認してください',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
