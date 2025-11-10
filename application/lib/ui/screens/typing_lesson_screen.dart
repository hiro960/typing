import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';
import '../widgets/typing_keyboard_mock.dart';

class TypingLessonScreen extends StatefulWidget {
  const TypingLessonScreen({super.key, required this.lesson});

  final LessonInfo lesson;

  @override
  State<TypingLessonScreen> createState() => _TypingLessonScreenState();
}

class _TypingLessonScreenState extends State<TypingLessonScreen> {
  late final Stopwatch _stopwatch;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String get _timerLabel {
    final tenths = (_stopwatch.elapsedMilliseconds / 100).floor();
    final seconds = tenths ~/ 10;
    final decimal = tenths % 10;
    final secondsLabel =
        seconds >= 100 ? '$seconds' : seconds.toString().padLeft(2, '0');
    return '$secondsLabel.$decimal秒';
  }

  bool get _shouldShowMeaning {
    final word = widget.lesson.sampleWord.trim();
    final meaning = widget.lesson.sampleMeaning.trim();
    final isSingleCharacter = word.runes.length <= 1;
    return meaning.isNotEmpty && !isSingleCharacter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = widget.lesson;
    final mediaQuery = MediaQuery.of(context);

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: Text(lesson.title),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.volume_up_outlined),
            onPress: () {},
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: lesson.progress,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.primary
                            .withValues(alpha: 0.12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '進捗 ${(lesson.progress * 100).round()}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _LessonPrompt(
                      word: lesson.sampleWord,
                      meaning: lesson.sampleMeaning,
                      showMeaning: _shouldShowMeaning,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    0,
                    0,
                    16 + mediaQuery.padding.bottom,
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: TypingKeyboardMock(
                      highlightedKeys: const {'ㅎ', 'ㅏ', 'ㄴ', 'ㄱ'},
                      highlightShift: false,
                      nextKeyLabel: '次は ㄴ',
                      timerLabel: _timerLabel,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LessonPrompt extends StatelessWidget {
  const _LessonPrompt({
    required this.word,
    required this.meaning,
    required this.showMeaning,
  });

  final String word;
  final String meaning;
  final bool showMeaning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
        gradient: LinearGradient(
          colors: [
            colors.surfaceContainerHighest.withValues(alpha: 0.2),
            colors.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 20),
            color: colors.primary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            word,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 40,
              letterSpacing: 6,
              fontWeight: FontWeight.w700,
              height: 1.1,
              fontFamily: 'RobotoMono',
            ),
          ),
          const SizedBox(height: 16),
          if (showMeaning)
            Text(
              meaning,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.secondary,
              ),
            )
          else
            const SizedBox(height: 20),
        ],
      ),
    );
  }
}
