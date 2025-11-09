import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'ui/app_theme.dart';
import 'ui/shell/app_shell.dart';

void main() {
  runApp(const TypingApp());
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
      home: const AppShell(),
    );
  }
}
