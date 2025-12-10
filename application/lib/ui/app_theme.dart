import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

/// カラーパレット - ティールブルー系の清潔感あるデザイン
class AppColors {
  // === プライマリカラー（ティールブルー系） ===
  static const Color primary = Color(0xFF2DBFBF); // ティールブルー
  static const Color primaryBright = Color(0xFF50D0D0); // 明るいティール
  static const Color secondary = Color(0xFF36B7C7); // セカンダリティール

  // === アクセントカラー ===
  static const Color accentPink = Color(0xFFFFB7C5); // 桜ピンク
  static const Color accentPeach = Color(0xFFFFDFBA); // ピーチ
  static const Color accentStart = Color(0xFF2DBFBF); // ティール開始
  static const Color accentEnd = Color(0xFF50D0D0); // ティール終了

  // === ステータスカラー ===
  static const Color success = Color(0xFF2DBFBF); // ティール（成功）
  static const Color warning = Color(0xFFFFD93D); // イエロー
  static const Color error = Color(0xFFFF6B6B); // レッド

  // === ダークモード ===
  static const Color background = Color(0xFF1A2634); // ダークティール
  static const Color surface = Color(0xFF243442); // ティールグレー
  static const Color surfaceAlt = Color(0xFF2E3E4C); // ミディアムティール
  static const Color border = Color(0xFF3A4A58); // ボーダーティール
  static const Color foreground = Color(0xFFF8FCFC); // オフホワイト
  static const Color mutedForeground = Color(0xFF8BA5A5); // ミュートティール

  // === ライトモード（白基調 + ティールアクセント） ===
  static const Color lightBackground = Color(0xFFF8FCFC); // ごく薄いティール白
  static const Color lightSurface = Color(0xFFFFFFFF); // 純白
  static const Color lightSurfaceAlt = Color(0xFFF0F8F8); // 薄いティール
  static const Color lightBorder = Color(0xFFE0EEEE); // ティールボーダー
  static const Color lightForeground = Color(0xFF2C3E50); // ダークグレー
  static const Color lightMutedForeground = Color(0xFF7F8C8D); // ミュートグレー
}

/// 機能カード用グラデーション（ティール系）
class FeatureGradients {
  // 1. カナダラ表 - ティールグリーン
  static const kanadara = [Color(0xFF2DBFBF), Color(0xFF5DD3D3)];
  // 2. 瞬間作文 - ミントティール
  static const quickTranslation = [Color(0xFF36B7C7), Color(0xFF6DD5E0)];
  // 3. 書き取り - スカイティール
  static const writing = [Color(0xFF4FC3C3), Color(0xFF7DD8D8)];
  // 4. タイピング - ソフトティール
  static const typing = [Color(0xFF3CC9C9), Color(0xFF6BDCDC)];
  // 5. 発音 - ライトティール
  static const pronunciation = [Color(0xFF45CBCB), Color(0xFF75DEDE)];
  // 6. 漢字語クイズ - アクアティール
  static const hanjaQuiz = [Color(0xFF2BC0C0), Color(0xFF5AD4D4)];
  // 7. 文法 - シーグリーン
  static const grammar = [Color(0xFF38BDBD), Color(0xFF68D2D2)];
  // 8. 漢字語辞典 - ディープティール
  static const hanjaDictionary = [Color(0xFF30B8B8), Color(0xFF60CDCD)];
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
