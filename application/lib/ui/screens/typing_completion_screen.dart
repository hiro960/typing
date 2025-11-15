import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/lessons/data/models/lesson_models.dart';
import '../../features/lessons/domain/providers/lesson_providers.dart';
import '../../features/typing/data/models/typing_models.dart';
import 'typing_lesson_screen.dart';

class TypingCompletionScreen extends ConsumerWidget {
  const TypingCompletionScreen({
    super.key,
    required this.lesson,
    required this.stats,
    required this.records,
    required this.lessonId,
  });

  final Lesson lesson;
  final TypingStatsData stats;
  final List<InputRecord> records;
  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weakCharacters = _weakCharacters(records);
    final catalogAsync = ref.watch(lessonCatalogProvider);
    final nextLessonId = catalogAsync.maybeWhen(
      data: (catalog) => _findNextLessonId(lesson, catalog),
      orElse: () => null,
    );

    return FScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text('🎉 完了！ 🎉', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      lesson.title,
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _ResultCard(stats: stats),
              const SizedBox(height: 16),
              _WeakCharactersCard(weakCharacters: weakCharacters),
              const Spacer(),
              _ActionButtons(
                lessonId: lessonId,
                nextLessonId: nextLessonId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _weakCharacters(List<InputRecord> records) {
    final map = <String, int>{};
    for (final record in records) {
      if (!record.isCorrect && record.expectedChar != null) {
        map[record.expectedChar!] = (map[record.expectedChar!] ?? 0) + 1;
      }
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).toList();
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.stats});

  final TypingStatsData stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('あなたの結果', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _StatRow(
              label: 'スコア',
              value: '${stats.wpm * 10 + (stats.accuracy * 100).round()}点',
            ),
            _StatRow(
              label: '正解率',
              value: '${(stats.accuracy * 100).toStringAsFixed(1)}%',
            ),
            _StatRow(label: 'スピード', value: '${stats.wpm} 文字/分'),
            _StatRow(label: '所要時間', value: _formatDuration(stats.elapsedMs)),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int elapsedMs) {
    final duration = Duration(milliseconds: elapsedMs);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes分$seconds秒';
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _WeakCharactersCard extends StatelessWidget {
  const _WeakCharactersCard({required this.weakCharacters});

  final List<String> weakCharacters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('弱点文字', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            if (weakCharacters.isEmpty)
              const Text('全ての文字を完璧に入力できました 🎉')
            else
              Wrap(
                spacing: 12,
                children: weakCharacters
                    .map(
                      (char) => Chip(
                        label: Text(char, style: theme.textTheme.titleLarge),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.lessonId, this.nextLessonId});

  final String lessonId;
  final String? nextLessonId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: nextLessonId == null
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            TypingLessonScreen(lessonId: nextLessonId!),
                      ),
                    );
                  },
            child: const Text('次のレッスンへ'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => TypingLessonScreen(lessonId: lessonId),
                ),
              );
            },
            child: const Text('もう一度挑戦'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('ホームに戻る'),
          ),
        ),
      ],
    );
  }
}

String? _findNextLessonId(
  Lesson lesson,
  Map<LessonLevel, List<LessonMeta>> catalog,
) {
  final currentLevelList = catalog[lesson.level] ?? const [];
  final index = currentLevelList.indexWhere((meta) => meta.id == lesson.id);
  if (index != -1 && index + 1 < currentLevelList.length) {
    return currentLevelList[index + 1].id;
  }
  final currentLevelIndex = LessonLevel.values.indexOf(lesson.level);
  for (int i = currentLevelIndex + 1; i < LessonLevel.values.length; i++) {
    final nextLevel = LessonLevel.values[i];
    final lessons = catalog[nextLevel] ?? const [];
    if (lessons.isNotEmpty) {
      return lessons.first.id;
    }
  }
  return null;
}
