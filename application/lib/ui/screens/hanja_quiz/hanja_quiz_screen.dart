import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/services/sound_service.dart';
import '../../../features/hanja_quiz/data/models/hanja_quiz_models.dart';
import '../../../features/hanja_quiz/domain/providers/hanja_quiz_providers.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import 'hanja_quiz_result_screen.dart';
import 'hanja_quiz_start_screen.dart';

/// 漢字語クイズメイン画面
class HanjaQuizScreen extends ConsumerStatefulWidget {
  const HanjaQuizScreen({super.key});

  @override
  ConsumerState<HanjaQuizScreen> createState() => _HanjaQuizScreenState();
}

class _HanjaQuizScreenState extends ConsumerState<HanjaQuizScreen> {
  String? _lastPlayedWordId;

  @override
  void initState() {
    super.initState();
    // 初回の音声再生
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playCurrentWordAudio();
    });
  }

  void _playCurrentWordAudio() {
    final quizState = ref.read(hanjaQuizProvider);
    if (quizState != null && !quizState.isGameComplete) {
      final wordId = quizState.currentWord.id;
      if (wordId != _lastPlayedWordId) {
        _lastPlayedWordId = wordId;
        final word = quizState.currentWord.word;
        ref.read(wordAudioServiceProvider.notifier).speak(word);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quizState = ref.watch(hanjaQuizProvider);

    // ゲーム完了時に結果画面へ遷移
    ref.listen<HanjaQuizState?>(hanjaQuizProvider, (previous, next) {
      if (next != null && next.isGameComplete && previous?.isGameComplete != true) {
        _navigateToResult();
      }
      // 新しい問題になったら音声再生
      if (next != null &&
          previous != null &&
          next.currentQuestionIndex != previous.currentQuestionIndex) {
        _lastPlayedWordId = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _playCurrentWordAudio();
        });
      }
      // 正解/不正解音を再生
      if (next != null &&
          previous != null &&
          next.isWordComplete &&
          !previous.isWordComplete) {
        final soundService = ref.read(soundServiceProvider);
        if (!next.hasWrongAnswer) {
          soundService.playCorrect();
        } else {
          soundService.playIncorrect();
        }
      }
    });

    if (quizState == null) {
      return AppPageScaffold(
        title: '漢字語クイズ',
        showBackButton: true,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentWord = quizState.currentWord;

    return AppPageScaffold(
      title: '漢字語クイズ',
      showBackButton: true,
      actions: [
        // 進捗表示
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            quizState.progressText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),

              // 問題表示
              _QuestionSection(
                hanja: currentWord.hanja,
                meaning: currentWord.meaning,
                onPlayAudio: () {
                  ref
                      .read(wordAudioServiceProvider.notifier)
                      .speak(currentWord.word);
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // 回答欄
              _AnswerSection(
                answeredChars: quizState.answeredChars,
                correctChars: quizState.correctChars,
                isWordComplete: quizState.isWordComplete,
                hasWrongAnswer: quizState.hasWrongAnswer,
              ),

              const SizedBox(height: AppSpacing.xl),

              // 選択肢または結果表示
              if (quizState.isWordComplete)
                _WordCompleteSection(
                  isCorrect: !quizState.hasWrongAnswer,
                  correctWord: currentWord.word,
                  onNext: () => _handleNext(false),
                  onMastered: () => _handleNext(true),
                )
              else
                _ChoicesSection(
                  choices: quizState.choices,
                  onSelect: _handleSelect,
                ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSelect(String selected) {
    ref.read(hanjaQuizProvider.notifier).selectAnswer(selected);
  }

  void _handleNext(bool markAsMastered) {
    ref.read(hanjaQuizProvider.notifier).nextQuestion(
          markAsMastered: markAsMastered,
        );
  }

  void _navigateToResult() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HanjaQuizResultScreen(),
      ),
    );
  }

  void _navigateToStart() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HanjaQuizStartScreen(),
      ),
    );
  }
}

/// 問題表示セクション
class _QuestionSection extends StatelessWidget {
  const _QuestionSection({
    required this.hanja,
    required this.meaning,
    required this.onPlayAudio,
  });

  final String hanja;
  final String meaning;
  final VoidCallback onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 漢字
        Text(
          hanja,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // 意味（日本語）
        Text(
          meaning,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // 音声再生ボタン
        IconButton(
          onPressed: onPlayAudio,
          icon: const Icon(Iconsax.volume_high),
          tooltip: '発音を聞く',
        ),
      ],
    );
  }
}

/// 回答欄セクション
class _AnswerSection extends StatelessWidget {
  const _AnswerSection({
    required this.answeredChars,
    required this.correctChars,
    required this.isWordComplete,
    required this.hasWrongAnswer,
  });

  final List<String> answeredChars;
  final List<String> correctChars;
  final bool isWordComplete;
  final bool hasWrongAnswer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWordComplete
              ? (hasWrongAnswer ? AppColors.error : AppColors.success)
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(correctChars.length, (index) {
          final isAnswered = index < answeredChars.length;
          final showCorrect = isWordComplete && hasWrongAnswer;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAnswered
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAnswered
                  ? answeredChars[index]
                  : (showCorrect ? correctChars[index] : '_'),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: showCorrect && !isAnswered
                    ? AppColors.error
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// 選択肢セクション（4x2グリッド）
class _ChoicesSection extends StatelessWidget {
  const _ChoicesSection({
    required this.choices,
    required this.onSelect,
  });

  final List<String> choices;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    // 4個ずつ2行に分割
    final firstRow = choices.take(4).toList();
    final secondRow = choices.length > 4 ? choices.skip(4).take(4).toList() : <String>[];

    return Column(
      children: [
        // 1行目
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: firstRow.map((choice) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _ChoiceButton(
                char: choice,
                onTap: () => onSelect(choice),
              ),
            );
          }).toList(),
        ),
        if (secondRow.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          // 2行目
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: secondRow.map((choice) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _ChoiceButton(
                  char: choice,
                  onTap: () => onSelect(choice),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// 選択肢ボタン
class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.char,
    required this.onTap,
  });

  final String char;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: Text(
            char,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// 単語完了セクション
class _WordCompleteSection extends StatelessWidget {
  const _WordCompleteSection({
    required this.isCorrect,
    required this.correctWord,
    required this.onNext,
    required this.onMastered,
  });

  final bool isCorrect;
  final String correctWord;
  final VoidCallback onNext;
  final VoidCallback onMastered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 正解/不正解表示
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Iconsax.tick_circle : Iconsax.close_circle,
                color: isCorrect ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? '正解！' : '不正解',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),

        if (!isCorrect) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            '正解: $correctWord',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],

        const SizedBox(height: AppSpacing.xl),

        // ボタン
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCorrect) ...[
              FButton(
                style: FButtonStyle.secondary(),
                onPress: onMastered,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.tick_square, size: 18),
                    SizedBox(width: 4),
                    Text('覚えた'),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              FButton(
                style: FButtonStyle.primary(),
                onPress: onNext,
                child: const Text('次の問題へ'),
              ),
            ] else ...[
              FButton(
                style: FButtonStyle.primary(),
                onPress: onNext,
                child: const Text('次の問題へ'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
