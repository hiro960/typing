import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/domain/providers/auth_providers.dart';
import '../../features/lessons/data/models/lesson_index.dart'
    as lesson_index;
import '../../features/lessons/data/models/lesson_models.dart';
import '../../features/lessons/data/models/lesson_progress.dart';
import '../../features/lessons/domain/providers/lesson_progress_providers.dart';
import '../../features/lessons/domain/providers/lesson_providers.dart';
import '../app_theme.dart';
import 'lesson_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _accordionController = FAccordionController(max: 1);

  @override
  void dispose() {
    _accordionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(lessonCatalogProvider);
    final statsAsync = ref.watch(lessonStatsProvider(level: null));
    final progressAsync = ref.watch(lessonProgressControllerProvider);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'Guest';

    return catalogAsync.when(
      data: (catalog) {
        final stats = statsAsync.value ?? const LessonStatsSummary();
        final progress =
            progressAsync.value ?? const <String, LessonProgress>{};
        final focusLesson = _findNextLesson(catalog, progress);
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FHeader(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '안녕하세요, $displayName',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          suffixes: [
                            FHeaderAction(
                              icon: const Icon(Icons.settings_outlined),
                              onPress: widget.onOpenSettings,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ProgressHero(stats: stats),
                        const SizedBox(height: 16),
                        _StatHighlights(stats: stats),
                        const SizedBox(height: 24),
                        _LevelAccordions(
                          controller: _accordionController,
                          catalog: catalog,
                          progress: progress,
                          onLessonTap: _onLessonTap,
                        ),
                        const SizedBox(height: 24),
                        _QuickActions(
                          focusLesson: focusLesson,
                          onFocusTap: focusLesson == null
                              ? null
                              : () => _onLessonTap(focusLesson, false),
                          onCustomPracticeTap: _showCustomPracticeHint,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }

  void _onLessonTap(lesson_index.LessonMeta lesson, bool isLocked) {
    if (!mounted) return;
    if (isLocked) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('レッスンがロックされています'),
          content: const Text('前のレッスンを完了すると、このレッスンが解除されます。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LessonDetailScreen(lessonId: lesson.id),
      ),
    );
  }

  lesson_index.LessonMeta? _findNextLesson(
    Map<LessonLevel, List<lesson_index.LessonMeta>> catalog,
    Map<String, LessonProgress> progress,
  ) {
    for (final level in LessonLevel.values) {
      final lessons = catalog[level] ?? const [];
      for (final lesson in lessons) {
        final rate = progress[lesson.id]?.normalizedCompletionRate ?? 0;
        if (rate < 100) {
          return lesson;
        }
      }
    }
    return null;
  }

  void _showCustomPracticeHint() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('カスタム練習は近日公開予定です。')),
    );
  }
}

class _StatHighlights extends StatelessWidget {
  const _StatHighlights({required this.stats});

  final LessonStatsSummary stats;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (
        label: '正解率',
        value: '${(stats.accuracyAvg * 100).toStringAsFixed(1)}%',
        caption: '過去7日平均',
        icon: Icons.verified_outlined,
      ),
      (
        label: 'WPM',
        value: stats.wpmAvg.toStringAsFixed(0),
        caption: 'ベスト更新を目指そう',
        icon: Icons.speed,
      ),
      (
        label: '継続日数',
        value: '${stats.streakDays}日',
        caption: '連続記録',
        icon: Icons.local_fire_department_outlined,
      ),
    ];
    final theme = Theme.of(context);
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
                      const SizedBox(height: 12),
                      Text(
                        tiles[i].value,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tiles[i].label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
              const SizedBox(width: 12),
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
class _ProgressHero extends StatelessWidget {
  const _ProgressHero({required this.stats});

  final LessonStatsSummary stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Text(
                    '${stats.lessonsCompleted} レッスン完了',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '累計 ${_formatDuration(stats.totalTime)} 練習',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.focusLesson,
    required this.onFocusTap,
    required this.onCustomPracticeTap,
  });

  final lesson_index.LessonMeta? focusLesson;
  final VoidCallback? onFocusTap;
  final VoidCallback onCustomPracticeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      const Text('弱点強化'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    focusLesson?.title ?? '全レッスン制覇まであと少し',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FButton(
                    onPress: onFocusTap,
                    style: FButtonStyle.secondary(),
                    child: Text(
                      focusLesson == null ? '完了済み' : '今すぐ開始',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune, color: theme.colorScheme.secondary),
                      const SizedBox(width: 6),
                      const Text('カスタム練習'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '好きな単語で練習（近日公開）',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  FButton(
                    onPress: onCustomPracticeTap,
                    style: FButtonStyle.ghost(),
                    child: const Text('通知を受け取る'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
