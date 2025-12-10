part of 'home_screen.dart';

/// 機能アイテムのデータクラス
class _FeatureItem {
  const _FeatureItem({
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.textIcon,
  });

  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final String? textIcon; // カナダラ表用
}

/// 8機能を2行×4列で表示（Row/Column実装）
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.features});

  final List<_FeatureItem> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 8アイテムを2行に分割
    final row1 = features.take(4).toList();
    final row2 = features.skip(4).take(4).toList();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.3)
              : AppColors.lightBorder.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFB8A9C9).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          // Row 1
          Row(
            children: row1
                .map((feature) => Expanded(
                      child: _PastelFeatureCard(feature: feature),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          // Row 2
          Row(
            children: row2
                .map((feature) => Expanded(
                      child: _PastelFeatureCard(feature: feature),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.lg,),
        ],
      ),
    );
  }
}
