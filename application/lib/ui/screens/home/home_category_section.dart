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

/// 機能グリッド（4列で表示）
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.features});

  final List<_FeatureItem> features;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 4列ずつに分割
    final rows = <List<_FeatureItem>>[];
    for (var i = 0; i < features.length; i += 4) {
      rows.add(features.skip(i).take(4).toList());
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg * 2,
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
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (final feature in rows[i])
                  Expanded(child: _PastelFeatureCard(feature: feature)),
                // 最後の行が4未満の場合、空のExpandedで埋める
                for (var j = rows[i].length; j < 4; j++)
                  const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
