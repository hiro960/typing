import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';

import 'ui/app_theme.dart';
import 'ui/shell/app_shell.dart';
import 'core/config/env_config.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 環境変数を読み込み
    await dotenv.load(fileName: '.env');
    AppLogger.info('Environment variables loaded');

    // 環境変数の検証
    EnvConfig.validate();
    AppLogger.info('Environment variables validated');
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
  }

  runApp(
    // RiverpodのProviderScopeでアプリ全体をラップ
    const ProviderScope(
      child: TypingApp(),
    ),
  );
}

class TypingApp extends StatelessWidget {
  const TypingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '韓国語タイピング',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) =>
          FTheme(data: AppTheme.foruiDark(), child: child!),
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
                  Icons.error_outline,
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
