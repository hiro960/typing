part of 'home_screen.dart';

class _StatHighlights extends StatelessWidget {
  const _StatHighlights({
    required this.integratedStatsAsync,
  });

  final AsyncValue<IntegratedStats?> integratedStatsAsync;

  @override
  Widget build(BuildContext context) {
    final isLoading = integratedStatsAsync.isLoading;
    final stats = integratedStatsAsync.value;

    final tiles = [
      (
        label: '正解率',
        value: stats != null
            ? '${(stats.avgAccuracy * 100).toStringAsFixed(1)}%'
            : '-',
        caption: '過去7日平均',
        icon: Iconsax.verify,
      ),
      (
        label: 'WPM',
        value: stats != null ? stats.maxWpm.toStringAsFixed(0) : '-',
        caption: '最高記録',
        icon: Iconsax.flash_1,
      ),
      (
        label: '継続日数',
        value: stats != null ? '${stats.streakDays}日' : '-',
        caption: '連続記録',
        icon: Iconsax.flash_circle,
      ),
    ];
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return Row(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i != tiles.length - 1 ? 12 : 0),
              child: FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(tiles[i].icon, color: theme.colorScheme.primary),
                      const SizedBox(height: AppSpacing.md),
                      if (isLoading)
                        ShimmerLoading(
                          child: Container(
                            width: 48,
                            height: 28,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      else
                        Text(
                          tiles[i].value,
                          style: theme.textTheme.headlineSmall,
                        ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        tiles[i].label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        tiles[i].caption,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
