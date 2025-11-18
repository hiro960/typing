import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/word_model.dart';

part 'word_quiz_controller.g.dart';

enum WordQuizAnswerStatus {
  known,
  unknown,
}

extension WordQuizAnswerLabel on WordQuizAnswerStatus {
  String get label => switch (this) {
        WordQuizAnswerStatus.known => 'わかる',
        WordQuizAnswerStatus.unknown => 'わからない',
      };
}

class WordQuizState {
  const WordQuizState({
    required this.cards,
    required this.currentIndex,
    required this.answers,
    required this.revealedWordIds,
  });

  const WordQuizState.initial()
      : cards = const <Word>[],
        currentIndex = 0,
        answers = const <String, WordQuizAnswerStatus>{},
        revealedWordIds = const <String>{};

  final List<Word> cards;
  final int currentIndex;
  final Map<String, WordQuizAnswerStatus> answers;
  final Set<String> revealedWordIds;

  bool get hasSession => cards.isNotEmpty;

  bool get isCompleted => hasSession && currentIndex >= cards.length;

  bool get hasCurrentCard => hasSession && currentIndex < cards.length;

  Word? get currentWord =>
      currentIndex >= 0 && currentIndex < cards.length ? cards[currentIndex] : null;

  int get totalCards => cards.length;

  int get currentPosition => hasCurrentCard ? currentIndex + 1 : cards.length;

  bool isMeaningRevealed(String wordId) => revealedWordIds.contains(wordId);

  List<WordQuizResult> get results => [
        for (final word in cards)
          if (answers.containsKey(word.id))
            WordQuizResult(word: word, status: answers[word.id]!),
      ];

  WordQuizState copyWith({
    List<Word>? cards,
    int? currentIndex,
    Map<String, WordQuizAnswerStatus>? answers,
    Set<String>? revealedWordIds,
  }) {
    return WordQuizState(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      revealedWordIds: revealedWordIds ?? this.revealedWordIds,
    );
  }
}

class WordQuizResult {
  const WordQuizResult({required this.word, required this.status});

  final Word word;
  final WordQuizAnswerStatus status;
}

@Riverpod(keepAlive: false)
class WordQuizController extends _$WordQuizController {
  @override
  WordQuizState build() => const WordQuizState.initial();

  void start(List<Word> words) {
    final shuffled = [...words]..shuffle(Random());
    state = WordQuizState(
      cards: shuffled,
      currentIndex: 0,
      answers: {},
      revealedWordIds: {},
    );
  }

  void revealMeaning() {
    final current = state.currentWord;
    if (current == null) return;
    state = state.copyWith(
      revealedWordIds: {...state.revealedWordIds, current.id},
    );
  }

  void answerCurrent(WordQuizAnswerStatus status) {
    final current = state.currentWord;
    if (current == null) return;
    final updatedAnswers = {...state.answers, current.id: status};
    final remainingReveal = {...state.revealedWordIds}..remove(current.id);
    state = state.copyWith(
      answers: updatedAnswers,
      revealedWordIds: remainingReveal,
      currentIndex: state.currentIndex + 1,
    );
  }

  void markKnown() => answerCurrent(WordQuizAnswerStatus.known);

  void markUnknown() => answerCurrent(WordQuizAnswerStatus.unknown);

  void reset() {
    state = const WordQuizState.initial();
  }
}
