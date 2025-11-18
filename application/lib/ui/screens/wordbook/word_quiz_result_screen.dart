import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/word_quiz_controller.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';

class WordQuizResultScreen extends ConsumerStatefulWidget {
  const WordQuizResultScreen({
    super.key,
    required this.results,
    required this.sourceWords,
    required this.completedAllCards,
    required this.onReplay,
  });

  final List<WordQuizResult> results;
  final List<Word> sourceWords;
  final bool completedAllCards;
  final Future<void> Function(BuildContext context) onReplay;

  @override
  ConsumerState<WordQuizResultScreen> createState() => _WordQuizResultScreenState();
}

class _WordQuizResultScreenState extends ConsumerState<WordQuizResultScreen> {
  late final ConfettiController _confettiController;
  late final Map<String, WordStatus> _currentStatuses;
  final Set<String> _updatingIds = {};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (widget.completedAllCards) {
      _confettiController.play();
    }
    _currentStatuses = {
      for (final word in widget.sourceWords) word.id: word.status,
    };
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final knownCount = widget.results
        .where((result) => result.status == WordQuizAnswerStatus.known)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.completedAllCards ? 'お疲れさまでした！' : '途中結果',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '正解: $knownCount / ${widget.sourceWords.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: widget.results.isEmpty
                    ? const _EmptyResult()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        itemCount: widget.results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final result = widget.results[index];
                          final currentStatus =
                              _currentStatuses[result.word.id] ?? result.word.status;
                          final isUpdating = _updatingIds.contains(result.word.id);
                          return _ResultCard(
                            result: result,
                            currentStatus: currentStatus,
                            isUpdating: isUpdating,
                            onToggleMaster: () => _toggleMaster(result.word, currentStatus),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.onReplay(context),
                        child: const Text('もう一度クイズをする'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('単語帳に戻る'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.completedAllCards)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: 1.5708,
                emissionFrequency: 0.04,
                numberOfParticles: 28,
                maxBlastForce: 12,
                minBlastForce: 5,
                gravity: 0.2,
                colors: [
                  scheme.primary,
                  scheme.secondary,
                  scheme.tertiary,
                  scheme.error,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _toggleMaster(Word word, WordStatus currentStatus) async {
    final nextStatus =
        currentStatus == WordStatus.MASTERED ? WordStatus.REVIEWING : WordStatus.MASTERED;
    setState(() {
      _updatingIds.add(word.id);
    });
    try {
      await ref.read(wordbookProvider.notifier).updateWord(
            word.id,
            status: nextStatus,
          );
      setState(() {
        _currentStatuses[word.id] = nextStatus;
      });
    } finally {
      if (mounted) {
        setState(() {
          _updatingIds.remove(word.id);
        });
      }
    }
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.currentStatus,
    required this.isUpdating,
    required this.onToggleMaster,
  });

  final WordQuizResult result;
  final WordStatus currentStatus;
  final bool isUpdating;
  final VoidCallback onToggleMaster;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isKnown = result.status == WordQuizAnswerStatus.known;
    final statusColor = isKnown ? scheme.primary : scheme.error;
    final mastered = currentStatus == WordStatus.MASTERED;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.word.word,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              result.word.meaning,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(result.status.label),
                  backgroundColor: statusColor.withValues(alpha: 0.15),
                  labelStyle: TextStyle(color: statusColor),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(currentStatus.label),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isUpdating ? null : onToggleMaster,
                child: Text(mastered ? '復習中に戻す' : '覚えた'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'クイズ結果がまだありません。',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
