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

  // Light palette
  static const Color lightBackground = Color(0xFFE6F7FA); // soft tiffany blue wash
  static const Color lightSurface = Color(0xFFF2FCFE); // lighter card/base
  static const Color lightSurfaceAlt = Color(0xFFD9F1F5); // section backgrounds
  static const Color lightBorder = Color(0xFFA8DDE6); // pale teal border
  static const Color lightForeground = Color(0xFF0F3945); // deep teal text
  static const Color lightMutedForeground = Color(0xFF3B6A77); // muted teal text
}

class AppTheme {
  static ThemeData light() => _materialTheme(isDark: false);
  static ThemeData dark() => _materialTheme(isDark: true);

  static FThemeData foruiLight() => _foruiTheme(isDark: false);
  static FThemeData foruiDark() => _foruiTheme(isDark: true);

  static ThemeData _materialTheme({required bool isDark}) {
    final base = _foruiTheme(isDark: isDark).toApproximateMaterialTheme();
    final colorScheme = _colorScheme(isDark: isDark);

    return base.copyWith(
      colorScheme: colorScheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:
          isDark ? AppColors.background : AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? AppColors.background : AppColors.lightBackground,
        foregroundColor: isDark ? AppColors.foreground : AppColors.lightForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
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
        backgroundColor:
            isDark ? AppColors.surfaceAlt : AppColors.lightSurfaceAlt,
        elevation: 12,
        indicatorColor: AppColors.primary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 78,
        shadowColor: Colors.black.withValues(alpha: 0.2),
      ),
    );
  }

  static ColorScheme _colorScheme({required bool isDark}) {
    if (isDark) {
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
    return const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightForeground,
      tertiary: AppColors.success,
      onTertiary: Colors.white,
      surfaceTint: AppColors.primary,
    );
  }

  static FThemeData _foruiTheme({required bool isDark}) {
    final base = isDark ? FThemes.slate.dark : FThemes.slate.light;

    return base.copyWith(
      debugLabel: isDark ? 'AppTheme Midnight' : 'AppTheme Light',
      colors: base.colors.copyWith(
        brightness: isDark ? Brightness.dark : Brightness.light,
        background: isDark ? AppColors.background : AppColors.lightBackground,
        foreground: isDark ? AppColors.foreground : AppColors.lightForeground,
        primary: AppColors.primary,
        primaryForeground: Colors.white,
        secondary: AppColors.secondary,
        secondaryForeground: Colors.black,
        muted: isDark ? AppColors.surface : AppColors.lightSurface,
        mutedForeground: isDark
            ? AppColors.mutedForeground
            : AppColors.lightMutedForeground,
        destructive: AppColors.error,
        destructiveForeground: Colors.white,
        error: AppColors.error,
        errorForeground: Colors.white,
        border: isDark ? AppColors.border : AppColors.lightBorder,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      style: (style) => style.copyWith(
        borderRadius: BorderRadius.circular(24),
        pagePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        iconStyle: style.iconStyle.copyWith(color: AppColors.primary),
      ),
      cardStyle: (card) => card.copyWith(
        decoration: card.decoration.copyWith(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.border : AppColors.lightBorder,
          ),
        ),
      ),
      bottomNavigationBarStyle: (nav) => nav.copyWith(
        decoration: nav.decoration.copyWith(
          color: isDark ? AppColors.surfaceAlt : AppColors.lightSurfaceAlt,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.border : AppColors.lightBorder),
          ),
        ),
      ),
    );
  }
}
