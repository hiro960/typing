import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../app_theme.dart';
import '../../../features/lessons/data/models/lesson_index.dart'
    as lesson_index;
import '../../../features/lessons/data/models/lesson_models.dart';
import '../../../features/lessons/domain/providers/lesson_providers.dart';
import '../../../features/typing/data/models/typing_models.dart';
import 'typing_lesson_screen.dart';

class TypingCompletionScreen extends ConsumerStatefulWidget {
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
  ConsumerState<TypingCompletionScreen> createState() =>
      _TypingCompletionScreenState();
}

class _TypingCompletionScreenState
    extends ConsumerState<TypingCompletionScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    )..play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weakCharacters = _weakCharacters(widget.records);
    final catalogAsync = ref.watch(lessonCatalogProvider);
    final nextLessonId = catalogAsync.maybeWhen(
      data: (catalog) => _findNextLessonId(widget.lesson, catalog),
      orElse: () => null,
    );

    return FScaffold(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: 1.5708, // π/2 ラジアン = 下向き
                emissionFrequency: 0.04,
                numberOfParticles: 28,
                maxBlastForce: 12,
                minBlastForce: 5,
                gravity: 0.2,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text('🎉 完了！ 🎉',
                            style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text(
                          widget.lesson.title,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(stats: widget.stats),
                  const SizedBox(height: 16),
                  _WeakCharactersCard(weakCharacters: weakCharacters),
                  const Spacer(),
                  _ActionButtons(
                    lessonId: widget.lessonId,
                    nextLessonId: nextLessonId,
                  ),
                ],
              ),
            ),
          ),
        ],
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
    final score = stats.wpm * 10 + (stats.accuracy * 100).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('あなたの結果', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _AnimatedStatRow(label: 'スコア', value: score, suffix: '点'),
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

class _AnimatedStatRow extends StatelessWidget {
  const _AnimatedStatRow({
    required this.label,
    required this.value,
    this.suffix = '',
  });

  final String label;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value.toDouble()),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (context, animated, child) {
              return Text(
                '${animated.round()}$suffix',
                style: theme.textTheme.titleMedium,
              );
            },
          ),
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
    return SizedBox(
      width: double.infinity,
      child: Card(
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
        // プライマリアクション: 次のレッスンへ
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
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
            child: const Text(
              '次のレッスンへ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // セカンダリアクション: もう一度挑戦
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
              foregroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => TypingLessonScreen(lessonId: lessonId),
                ),
              );
            },
            child: const Text(
              'もう一度挑戦',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // サブアクション: ホームに戻る
        SizedBox(
          width: double.infinity,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.mutedForeground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'ホームに戻る',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

String? _findNextLessonId(
  Lesson lesson,
  Map<LessonLevel, List<lesson_index.LessonMeta>> catalog,
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
