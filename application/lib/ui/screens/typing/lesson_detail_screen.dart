import 'package:chaletta/features/lessons/data/models/lesson_models.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/lessons/data/models/lesson_index.dart'
    as lesson_index;
import '../../../features/lessons/data/models/lesson_progress.dart';
import '../../../features/lessons/domain/providers/lesson_progress_providers.dart';
import '../../../features/lessons/domain/providers/lesson_providers.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import 'typing_lesson_screen.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonDetailProvider(lessonId));
    final progressAsync = ref.watch(lessonProgressControllerProvider);
    return lessonAsync.when(
      data: (lesson) {
        final completionRate =
            progressAsync.value?[lesson.id]?.normalizedCompletionRate ?? 0;
        final bestRecord = progressAsync.value?[lesson.id];
        final levelLessonsAsync =
            ref.watch(lessonsByLevelProvider(lesson.level));
        final levelLessons =
            levelLessonsAsync.value ?? const <lesson_index.LessonMeta>[];
        final isLocked = _isLessonLocked(
          lesson,
          levelLessons,
          progressAsync.value ?? const {},
        );
        return AppPageScaffold(
          title: lesson.title,
          showBackButton: true,
          safeBottom: true,
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OverviewCard(lesson: lesson, completionRate: completionRate),
                  if (isLocked) ...[
                    const SizedBox(height: 12),
                    FAlert(
                      icon: const Icon(Icons.lock),
                      title: const Text('ロック中'),
                      subtitle: const Text('前のレッスンを完了すると解放されます'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _SectionList(sections: lesson.content.sections),
                  const SizedBox(height: 16),
                  _BestRecordCard(progress: bestRecord),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    onPressed: isLocked
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    TypingLessonScreen(lessonId: lesson.id),
                              ),
                            );
                          },
                    label: const Text('今すぐ開始'),
                  ),
                ),
                ],
              ),
          )
        );
      },
      loading: () => const AppPageScaffold(
        title: 'レッスン詳細',
        showBackButton: true,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AppPageScaffold(
        title: 'レッスン詳細',
        showBackButton: true,
        child: PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(lessonDetailProvider(lessonId)),
        ),
      ),
    );
  }
}

bool _isLessonLocked(
  Lesson lesson,
  List<lesson_index.LessonMeta> lessons,
  Map<String, LessonProgress> progress,
) {
  final index = lessons.indexWhere((meta) => meta.id == lesson.id);
  if (index <= 0) {
    return false;
  }
  final previous = lessons[index - 1];
  final prevRate = progress[previous.id]?.normalizedCompletionRate ?? 0;
  return prevRate < 100;
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.lesson, required this.completionRate});

  final Lesson lesson;
  final int completionRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('レッスン概要', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                lesson.description ?? 'このレッスンで韓国語の入力を練習します。',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text('完了率: $completionRate%'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionList extends StatelessWidget {
  const _SectionList({required this.sections});

  final List<LessonSection> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('学習内容', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final section in sections)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(section.title),
                        Text(
                          section.type.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    Text('${section.items.length} 項目'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BestRecordCard extends StatelessWidget {
  const _BestRecordCard({required this.progress});

  final LessonProgress? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (progress == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('あなたの最高記録', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text('まだ記録がありません。最初のチャレンジを始めましょう！'),
            ],
          ),
        ),
      );
    }

    final accuracy = progress!.bestAccuracy != null
        ? '${(progress!.bestAccuracy! * 100).toStringAsFixed(1)}%'
        : '--';
    final wpm = progress!.bestWpm?.toString() ?? '--';
    final last = progress!.lastCompletedAt != null
        ? '${progress!.lastCompletedAt!.year}/${progress!.lastCompletedAt!.month}/${progress!.lastCompletedAt!.day}'
        : '未実施';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('あなたの最高記録', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(label: 'WPM', value: wpm),
                _StatChip(label: '正解率', value: accuracy),
                _StatChip(label: '前回', value: last),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

