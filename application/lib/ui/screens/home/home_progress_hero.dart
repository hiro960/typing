part of 'home_screen.dart';

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({
    required this.stats,
    this.isLoading = false,
  });

  final LessonStatsSummary stats;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今週の進捗',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (isLoading)
                    ShimmerLoading(
                      child: Container(
                        width: 160,
                        height: 28,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  else
                    Text(
                      '${stats.lessonsCompleted} レッスン完了',
                      style: theme.textTheme.headlineSmall,
                    ),
                  const SizedBox(height: 4),
                  if (isLoading)
                    ShimmerLoading(
                      child: Container(
                        width: 120,
                        height: 18,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    )
                  else
                    Text(
                      '累計 ${_formatDuration(stats.totalTime)} 練習',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.emoji_events_outlined,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
