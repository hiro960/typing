import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/writing/data/models/writing_models.dart';
import 'typing_practice_screen.dart';

/// 書き取り練習完了画面
class WritingCompletionScreen extends ConsumerStatefulWidget {
  const WritingCompletionScreen({
    super.key,
    required this.patternId,
    required this.topicId,
    required this.patternName,
    required this.topicName,
    required this.completion,
  });

  final String patternId;
  final String topicId;
  final String patternName;
  final String topicName;
  final WritingCompletion completion;

  @override
  ConsumerState<WritingCompletionScreen> createState() =>
      _WritingCompletionScreenState();
}

class _WritingCompletionScreenState
    extends ConsumerState<WritingCompletionScreen> {
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
    final correctCount =
        widget.completion.results.where((r) => r.correct).length;
    final totalCount = widget.completion.results.length;
    final accuracy = totalCount == 0 ? 0.0 : correctCount / totalCount;

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
                          widget.patternName,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.topicName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(
                    correctCount: correctCount,
                    totalCount: totalCount,
                    accuracy: accuracy,
                    timeSpent: widget.completion.timeSpent,
                  ),
                  const Spacer(),
                  _ActionButtons(
                    patternId: widget.patternId,
                    topicId: widget.topicId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.correctCount,
    required this.totalCount,
    required this.accuracy,
    required this.timeSpent,
  });

  final int correctCount;
  final int totalCount;
  final double accuracy;
  final int timeSpent;

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
              label: '正解数',
              value: '$correctCount / $totalCount',
            ),
            _AnimatedStatRow(
              label: '正解率',
              value: (accuracy * 100).round(),
              suffix: '%',
            ),
            _StatRow(
              label: '所要時間',
              value: _formatDuration(timeSpent),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes分$secs秒';
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.patternId,
    required this.topicId,
  });

  final String patternId;
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.secondaryContainer,
              foregroundColor: theme.colorScheme.onSecondaryContainer,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => TypingPracticeScreen(
                    patternId: patternId,
                    topicId: topicId,
                  ),
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
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
            ),
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
