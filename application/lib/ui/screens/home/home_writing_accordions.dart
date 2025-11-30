part of 'home_screen.dart';

class _WritingPatternAccordions extends ConsumerWidget {
  const _WritingPatternAccordions({
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.lane,
  });

  final FAccordionController controller;
  final String title;
  final String subtitle;
  final WritingLane lane;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternsAsync = ref.watch(writingPatternsProvider);

    return patternsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text('エラーが発生しました: $error'),
      ),
      data: (patterns) {
        final filtered = patterns.where((p) => p.lane == lane).toList();

        if (filtered.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text('データがありません'),
          );
        }

        return FAccordion(
          controller: controller,
          children: [
            FAccordionItem(
              initiallyExpanded: false,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.accentStart.withValues(
                      alpha: 0.18,
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: AppColors.accentStart,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text('全${filtered.length}件'),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final pattern in filtered) ...[
                    _PatternTile(
                      pattern: pattern,
                      onTap: () => _navigateToTopicList(context, pattern),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToTopicList(BuildContext context, WritingPattern pattern) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TopicListScreen(pattern: pattern)),
    );
  }
}

class _PatternTile extends StatelessWidget {
  const _PatternTile({required this.pattern, required this.onTap});

  final WritingPattern pattern;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accentStart.withValues(alpha: 0.15),
                child: Icon(
                  pattern.getIconData(),
                  color: AppColors.accentStart,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pattern.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pattern.topics.length}トピック',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
