part of 'home_screen.dart';

/// パステルグラデーション付きの機能カード
class _PastelFeatureCard extends StatelessWidget {
  const _PastelFeatureCard({required this.feature});

  final _FeatureItem feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: feature.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アイコンコンテナ (パステルグラデーション)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: feature.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: feature.gradientColors.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: feature.textIcon != null
                    ? Text(
                        feature.textIcon!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        feature.icon,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // タイトル
            Text(
              feature.title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: -0.2,
                color: isDark ? AppColors.foreground : AppColors.lightForeground,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
