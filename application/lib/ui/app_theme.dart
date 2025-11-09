import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

class AppColors {
  static const Color primary = Color(0xFF3A8DFF);
  static const Color primaryBright = Color(0xFF5AA2FF);
  static const Color secondary = Color(0xFF27C3FF);
  static const Color accentStart = Color(0xFF1B57F1);
  static const Color accentEnd = Color(0xFF30A8FF);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFF87171);
  static const Color background = Color(0xFF080B12);
  static const Color surface = Color(0xFF111726);
  static const Color surfaceAlt = Color(0xFF151C2C);
  static const Color border = Color(0xFF1F2634);
  static const Color foreground = Color(0xFFF4F7FF);
  static const Color mutedForeground = Color(0xFF94A3B8);
}

class AppTheme {
  static ThemeData light() => _materialTheme();
  static ThemeData dark() => _materialTheme();

  static FThemeData foruiLight() => _foruiTheme();
  static FThemeData foruiDark() => _foruiTheme();

  static ThemeData _materialTheme() {
    final base = _foruiTheme().toApproximateMaterialTheme();
    final colorScheme = _colorScheme();

    return base.copyWith(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primaryBright,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: const TextStyle(
          color: AppColors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceAlt,
        elevation: 12,
        indicatorColor: AppColors.primary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 78,
        shadowColor: Colors.black.withValues(alpha: 0.2),
      ),
    );
  }

  static ColorScheme _colorScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.foreground,
      tertiary: AppColors.success,
      onTertiary: Colors.black,
      surfaceTint: AppColors.primary,
    );
  }

  static FThemeData _foruiTheme() {
    final base = FThemes.slate.dark;

    return base.copyWith(
      debugLabel: 'AppTheme Midnight',
      colors: base.colors.copyWith(
        brightness: Brightness.dark,
        background: AppColors.background,
        foreground: AppColors.foreground,
        primary: AppColors.primary,
        primaryForeground: Colors.white,
        secondary: AppColors.secondary,
        secondaryForeground: Colors.black,
        muted: AppColors.surface,
        mutedForeground: AppColors.mutedForeground,
        destructive: AppColors.error,
        destructiveForeground: Colors.white,
        error: AppColors.error,
        errorForeground: Colors.white,
        border: AppColors.border,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      style: (style) => style.copyWith(
        borderRadius: BorderRadius.circular(24),
        pagePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        iconStyle: style.iconStyle.copyWith(color: AppColors.primary),
      ),
      cardStyle: (card) => card.copyWith(
        decoration: card.decoration.copyWith(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
      ),
      bottomNavigationBarStyle: (nav) => nav.copyWith(
        decoration: nav.decoration.copyWith(
          color: AppColors.surfaceAlt,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
      ),
    );
  }
}
