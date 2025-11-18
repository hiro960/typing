import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/word_quiz_controller.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import 'word_quiz_result_screen.dart';

class WordQuizScreen extends ConsumerStatefulWidget {
  const WordQuizScreen({super.key, required this.words});

  final List<Word> words;

  @override
  ConsumerState<WordQuizScreen> createState() => _WordQuizScreenState();
}

class _WordQuizScreenState extends ConsumerState<WordQuizScreen> {
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(wordQuizControllerProvider.notifier).start(widget.words);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordQuizControllerProvider);
    ref.listen<WordQuizState>(
      wordQuizControllerProvider,
      (previous, next) {
        if (!mounted) return;
        if (next.isCompleted && !_navigating) {
          _openResultScreen(completedAllCards: true);
        }
      },
    );
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _handleEarlyExit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _handleBackPressed,
                    ),
                    const Spacer(),
                    Text(
                      '${state.totalCards == 0 ? 0 : state.currentPosition}/${state.totalCards}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: state.hasCurrentCard
                      ? _QuizCard(
                          word: state.currentWord!,
                          meaningVisible: state.isMeaningRevealed(
                            state.currentWord!.id,
                          ),
                          onSpeak: () => ref
                              .read(wordAudioServiceProvider.notifier)
                              .speak(state.currentWord!.word),
                          onSwiped: _handleSwipe,
                        )
                      : const _QuizEmptyState(),
                ),
                const SizedBox(height: 16),
                _ActionButtons(
                  onUnknownPressed:
                      state.hasCurrentCard ? () => _handleUnknownPressed(state) : null,
                  onKnownPressed: state.hasCurrentCard ? _handleKnownPressed : null,
                  meaningVisible: state.currentWord != null &&
                      state.isMeaningRevealed(state.currentWord!.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleBackPressed() => _handleEarlyExit();

  Future<bool> _handleEarlyExit() async {
    if (_navigating) return false;
    await _openResultScreen(completedAllCards: false);
    return false;
  }

  void _handleSwipe(DismissDirection direction) {
    if (!mounted || _navigating) return;
    final notifier = ref.read(wordQuizControllerProvider.notifier);
    if (direction == DismissDirection.startToEnd) {
      notifier.markKnown();
    } else if (direction == DismissDirection.endToStart) {
      notifier.markUnknown();
    }
  }

  void _handleKnownPressed() {
    if (!mounted || _navigating) return;
    ref.read(wordQuizControllerProvider.notifier).markKnown();
  }

  void _handleUnknownPressed(WordQuizState state) {
    if (!mounted || _navigating) return;
    final current = state.currentWord;
    if (current == null) return;
    if (!state.isMeaningRevealed(current.id)) {
      ref.read(wordQuizControllerProvider.notifier).revealMeaning();
      return;
    }
    ref.read(wordQuizControllerProvider.notifier).markUnknown();
  }

  Future<void> _openResultScreen({required bool completedAllCards}) async {
    final quizState = ref.read(wordQuizControllerProvider);
    if (!quizState.hasSession) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }
    if (_navigating) return;
    _navigating = true;
    final results = quizState.results;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => WordQuizResultScreen(
          results: results,
          sourceWords: widget.words,
          completedAllCards: completedAllCards && quizState.isCompleted,
          onReplay: (context) async {
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => WordQuizScreen(words: widget.words),
              ),
            );
          },
        ),
      ),
    );

    if (!mounted) return;
    _navigating = false;
    ref.read(wordQuizControllerProvider.notifier).reset();
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({
    required this.word,
    required this.meaningVisible,
    required this.onSpeak,
    required this.onSwiped,
  });

  final Word word;
  final bool meaningVisible;
  final VoidCallback onSpeak;
  final ValueChanged<DismissDirection> onSwiped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(word.id),
      direction: DismissDirection.horizontal,
      onDismissed: onSwiped,
      background: const _SwipeBackground(
        alignment: Alignment.centerLeft,
        color: Color(0x3328a745),
        icon: Icons.sentiment_very_satisfied_outlined,
        label: 'わかる',
      ),
      secondaryBackground: const _SwipeBackground(
        alignment: Alignment.centerRight,
        color: Color(0x33c62828),
        icon: Icons.sentiment_very_dissatisfied_outlined,
        label: 'わからない',
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: onSpeak,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      word.word,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: meaningVisible
                          ? Text(
                              word.meaning,
                              key: ValueKey('meaning_${word.id}'),
                              style: theme.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              '',
                              key: ValueKey('hint_${word.id}'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onUnknownPressed,
    required this.onKnownPressed,
    required this.meaningVisible,
  });

  final VoidCallback? onUnknownPressed;
  final VoidCallback? onKnownPressed;
  final bool meaningVisible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: meaningVisible ? scheme.error : scheme.errorContainer,
              foregroundColor: meaningVisible ? scheme.onError : scheme.onErrorContainer,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            onPressed: onUnknownPressed,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sentiment_very_dissatisfied_outlined, size: 28),
                SizedBox(height: 4),
                Text('わからない'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primaryContainer,
              foregroundColor: scheme.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            onPressed: onKnownPressed,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sentiment_very_satisfied_outlined, size: 28),
                SizedBox(height: 4),
                Text('わかる'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizEmptyState extends StatelessWidget {
  const _QuizEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'クイズの単語がありません。',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
