part of 'home_screen.dart';

class _LevelAccordions extends StatelessWidget {
  const _LevelAccordions({
    required this.controller,
    required this.catalog,
    required this.progress,
    required this.onLessonTap,
  });

  final FAccordionController controller;
  final Map<LessonLevel, List<lesson_index.LessonMeta>> catalog;
  final Map<String, LessonProgress> progress;
  final void Function(lesson_index.LessonMeta lesson, bool isLocked) onLessonTap;

  static const _laneMeta = [
    (
      level: LessonLevel.beginner,
      title: '初級レーン',
      subtitle: '子音・母音を身体に染み込ませるセッション',
      color: AppColors.primaryBright,
      icon: Icons.bolt,
    ),
    (
      level: LessonLevel.intermediate,
      title: '中級レーン',
      subtitle: '頻出単語とリズム練習でスピードアップ',
      color: AppColors.secondary,
      icon: Icons.trending_up,
    ),
    (
      level: LessonLevel.advanced,
      title: '上級レーン',
      subtitle: '文章入力と推し活フレーズで実戦モード',
      color: AppColors.accentEnd,
      icon: Icons.star,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FAccordion(
      controller: controller,
      children: _laneMeta.map((meta) {
        final lessons =
            catalog[meta.level] ?? const <lesson_index.LessonMeta>[];

        return FAccordionItem(
          initiallyExpanded: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: meta.color.withValues(alpha: 0.18),
                child: Icon(meta.icon, color: meta.color, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meta.title),
                    Text(
                      meta.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text('全${lessons.length}件'),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < lessons.length; i++) ...[
                Builder(
                  builder: (_) {
                    final lesson = lessons[i];
                    final completionRate =
                        progress[lesson.id]?.normalizedCompletionRate ?? 0;
                    final locked = _isLocked(lessons, i);
                    return _LessonTile(
                      lesson: lesson,
                      accent: meta.color,
                      completionRate: completionRate,
                      isLocked: locked,
                      onTap: () => onLessonTap(lesson, locked),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _isLocked(List<lesson_index.LessonMeta> lessons, int index) {
    if (index <= 0) {
      return lessons[index].isLocked;
    }
    final previous = lessons[index - 1];
    final prevProgress =
        progress[previous.id]?.normalizedCompletionRate ?? 0;
    return (lessons[index].isLocked) || prevProgress < 100;
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.lesson,
    required this.accent,
    required this.completionRate,
    required this.isLocked,
    required this.onTap,
  });

  final lesson_index.LessonMeta lesson;
  final Color accent;
  final int completionRate;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedRate = completionRate.clamp(0, 100) / 100;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Chip(
                    backgroundColor: accent.withValues(alpha: 0.15),
                    label: Text(
                      isLocked ? '未解放' : '$completionRate%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: normalizedRate,
                minHeight: 6,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.6,
                ),
                color: accent,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isLocked ? Icons.lock_outline : Icons.play_arrow,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isLocked
                        ? '前のレッスンを完了すると解除'
                        : normalizedRate >= 1
                            ? 'マスター済み'
                            : '残り ${(100 - completionRate).clamp(0, 100)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
