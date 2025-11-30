import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:uuid/uuid.dart';

import '../../../features/writing/data/models/writing_models.dart';
import '../../../features/writing/domain/providers/writing_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../app_spacing.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/typing/input_feedback_widget.dart';
import '../../widgets/typing/level_badge.dart';
import '../../widgets/typing/typing_progress_bar.dart';
import '../../widgets/typing/typing_prompt_card.dart';
import '../../widgets/typing_keyboard.dart';
import 'writing_completion_screen.dart';

/// タイピング練習画面の状態
class _PracticeState {
  final List<WritingEntry> entries;
  final int currentIndex;
  final String userInput;
  final List<EntryResult> results;
  final bool showAnswer;
  final DateTime startTime;
  final int elapsedSeconds;
  final bool? lastResult;

  _PracticeState({
    required this.entries,
    required this.currentIndex,
    required this.userInput,
    required this.results,
    required this.showAnswer,
    required this.startTime,
    required this.elapsedSeconds,
    this.lastResult,
  });

  _PracticeState copyWith({
    List<WritingEntry>? entries,
    int? currentIndex,
    String? userInput,
    List<EntryResult>? results,
    bool? showAnswer,
    DateTime? startTime,
    int? elapsedSeconds,
    bool? lastResult,
    bool clearLastResult = false,
  }) {
    return _PracticeState(
      entries: entries ?? this.entries,
      currentIndex: currentIndex ?? this.currentIndex,
      userInput: userInput ?? this.userInput,
      results: results ?? this.results,
      showAnswer: showAnswer ?? this.showAnswer,
      startTime: startTime ?? this.startTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
    );
  }

  WritingEntry? get currentEntry =>
      currentIndex < entries.length ? entries[currentIndex] : null;
}

/// タイピング練習画面
class TypingPracticeScreen extends ConsumerStatefulWidget {
  const TypingPracticeScreen({
    super.key,
    required this.patternId,
    required this.topicId,
  });

  final String patternId;
  final String topicId;

  @override
  ConsumerState<TypingPracticeScreen> createState() =>
      _TypingPracticeScreenState();
}

class _TypingPracticeScreenState extends ConsumerState<TypingPracticeScreen> {
  late final HangulComposer _composer;
  _PracticeState? _state;
  Timer? _feedbackTimer;
  Timer? _timer;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();
    _composer = HangulComposer();
    _initializePractice();
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _initializePractice() async {
    _feedbackTimer?.cancel();
    _timer?.cancel();
    _isFinishing = false;

    final topic = await ref.read(
      writingTopicProvider((
        patternId: widget.patternId,
        topicId: widget.topicId,
      )).future,
    );

    if (topic == null || !mounted) return;

    // 例文を除外してシャッフル
    final practiceEntries =
        topic.entries.where((e) => e.level != EntryLevel.sentence).toList()
          ..shuffle();

    setState(() {
      _state = _PracticeState(
        entries: practiceEntries,
        currentIndex: 0,
        userInput: '',
        results: [],
        showAnswer: false,
        startTime: DateTime.now(),
        elapsedSeconds: 0,
      );
    });

    _composer.reset();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _state == null) return;
      final now = DateTime.now();
      final elapsed = now.difference(_state!.startTime).inSeconds;
      if (elapsed != _state!.elapsedSeconds) {
        setState(() {
          _state = _state!.copyWith(elapsedSeconds: elapsed);
        });
      }
    });
  }

  void _onKeyboardTextInput(String text) {
    // 判定後は入力を無効化
    if (_state?.lastResult != null) return;
    _composer.input(text);
    setState(() {});
  }

  void _onKeyboardBackspace() {
    // 判定後は入力を無効化
    if (_state?.lastResult != null) return;
    _composer.backspace();
    setState(() {});
  }

  void _onKeyboardSpace() {
    // 判定後は入力を無効化
    if (_state?.lastResult != null) return;
    _composer.addSpace();
    setState(() {});
  }

  void _onKeyboardEnter() {
    // 判定後の場合は次の問題へ、判定前の場合は回答チェック
    if (_state?.lastResult != null) {
      _goToNextQuestion();
    } else {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    final currentState = _state;
    if (currentState == null || currentState.currentEntry == null) return;

    final currentEntry = currentState.currentEntry!;
    final userInput = _composer.text.trim();
    final isCorrect = _isAnswerCorrect(userInput, currentEntry.koText);

    final result = EntryResult(
      entryId: currentEntry.id,
      correct: isCorrect,
      timestamp: DateTime.now(),
    );

    final updatedResults = [...currentState.results, result];

    setState(() {
      _state = currentState.copyWith(
        results: updatedResults,
        lastResult: isCorrect,
      );
    });
  }

  /// 이/가, 와/과 のような可変パーティクルは両形/片方どちらでも正解にする
  bool _isAnswerCorrect(String input, String correct) {
    final trimmedInput = input.trim();
    final trimmedCorrect = correct.trim();

    // デバッグ: 入力と正解の比較
    developer.log('=== Answer Check ===');
    developer.log('Input: "$trimmedInput"');
    developer.log('Correct: "$trimmedCorrect"');
    developer.log('Exact match: ${trimmedInput == trimmedCorrect}');
    developer.log('Input codeUnits: ${trimmedInput.codeUnits}');
    developer.log('Correct codeUnits: ${trimmedCorrect.codeUnits}');

    if (trimmedInput == trimmedCorrect) return true;

    final pattern = _buildFlexibleAnswerPattern(trimmedCorrect);
    developer.log('Pattern: $pattern');
    final regexMatch = RegExp('^$pattern\$').hasMatch(trimmedInput);
    developer.log('Regex match: $regexMatch');

    return regexMatch;
  }

  String _buildFlexibleAnswerPattern(String correct) {
    var pattern = RegExp.escape(correct);
    // 注意: RegExp.escape は / をエスケープしないので、キーもエスケープなしで指定
    const replacements = <String, String>{
      '이/가': '(?:이/가|이|가)',
      '가/이': '(?:가/이|가|이)',
      '와/과': '(?:와/과|와|과)',
      '과/와': '(?:과/와|과|와)',
      '을/를': '(?:을/를|을|를)',
      '를/을': '(?:를/을|를|을)',
    };

    replacements.forEach((key, value) {
      pattern = pattern.replaceAll(key, value);
    });

    return pattern;
  }

  void _goToNextQuestion() {
    final currentState = _state;
    if (currentState == null) return;

    final isLast = currentState.currentIndex >= currentState.entries.length - 1;

    if (isLast) {
      _saveAndFinish();
    } else {
      final nextIndex = currentState.currentIndex + 1;
      _composer.reset();
      setState(() {
        _state = currentState.copyWith(
          currentIndex: nextIndex,
          userInput: '',
          clearLastResult: true,
        );
      });
    }
  }

  Future<void> _saveAndFinish() async {
    if (_state == null || _isFinishing) return;
    _isFinishing = true;

    _timer?.cancel();
    _feedbackTimer?.cancel();
    final timeSpent = DateTime.now().difference(_state!.startTime).inSeconds;

    final completion = WritingCompletion(
      id: const Uuid().v4(),
      patternId: widget.patternId,
      topicId: widget.topicId,
      mode: WritingMode.typing,
      timeSpent: timeSpent,
      completedAt: DateTime.now(),
      results: _state!.results,
    );

    try {
      final storage = await ref.read(writingStorageRepositoryProvider.future);
      await storage.saveCompletion(completion);

      if (!mounted) return;

      // パターンとトピック情報を取得
      final topic = await ref.read(
        writingTopicProvider((
          patternId: widget.patternId,
          topicId: widget.topicId,
        )).future,
      );

      final patterns = await ref.read(writingPatternsProvider.future);
      final pattern = patterns.firstWhere((p) => p.id == widget.patternId);

      if (!mounted) return;

      // 完了画面に遷移
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => WritingCompletionScreen(
            patternId: widget.patternId,
            topicId: widget.topicId,
            patternName: pattern.name,
            topicName: topic?.name ?? '',
            completion: completion,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // エラーダイアログを表示
      showFDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: (context, style, animation) => FDialog.adaptive(
          style: style,
          animation: animation,
          title: const Text('エラー'),
          body: Text('保存に失敗しました: $e'),
          actions: [
            FButton(
              style: FButtonStyle.primary(),
              onPress: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        ),
      );
      _isFinishing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      return const AppPageScaffold(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final topicAsync = ref.watch(
      writingTopicProvider((
        patternId: widget.patternId,
        topicId: widget.topicId,
      )),
    );

    return topicAsync.when(
      loading: () => const AppPageScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) =>
          AppPageScaffold(child: Center(child: Text('エラーが発生しました: $error'))),
      data: (topic) {
        if (topic == null) {
          return const AppPageScaffold(
            child: Center(child: Text('トピックが見つかりません')),
          );
        }

        return _buildContent(context, topic);
      },
    );
  }

  Widget _buildContent(BuildContext context, WritingTopic topic) {
    return AppPageScaffold(
      childPad: false,
      header: FHeader.nested(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(topic.name)],
        ),
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).pop()),
        ],
        suffixes: [
          FHeaderAction(
            icon: Icon(
              _state!.showAnswer ? Icons.visibility : Icons.visibility_off,
            ),
            onPress: () {
              setState(() {
                _state = _state!.copyWith(showAnswer: !_state!.showAnswer);
              });
            },
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProgressBar(),
          Expanded(child: _buildPracticeArea()),
          Padding(
            padding: EdgeInsets.only(
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            child: TypingKeyboard(
              onTextInput: _onKeyboardTextInput,
              onBackspace: _onKeyboardBackspace,
              onSpace: _onKeyboardSpace,
              onEnter: _onKeyboardEnter,
              highlightedKeys: const {},
              highlightShift: false,
              nextKeyLabel: null,
              enableHaptics: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final answered = _state!.results.length;
    final total = _state!.entries.length;
    final elapsedLabel = _formatElapsed(_state!.elapsedSeconds);

    return TypingProgressBar(
      current: answered,
      total: total,
      elapsedLabel: elapsedLabel,
    );
  }

  String _formatElapsed(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _buildPracticeArea() {
    final currentEntry = _state!.currentEntry;
    if (currentEntry == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LevelBadge.fromEntryLevel(currentEntry.level),
          const SizedBox(height: AppSpacing.md),
          TypingPromptCard(
            targetText: currentEntry.jpText,
            subText: _state!.showAnswer ? currentEntry.koText : null,
            fontSize: 22,
          ),
          const SizedBox(height: AppSpacing.xl),
          TypingInputCard(inputText: _composer.text),
          const SizedBox(height: AppSpacing.md),
          _buildShowAnswerButton(),
          const SizedBox(height: AppSpacing.md),
          if (_state!.lastResult != null) _buildFeedback(),
        ],
      ),
    );
  }

  Widget _buildShowAnswerButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _state = _state!.copyWith(showAnswer: !_state!.showAnswer);
          });
        },
        icon: Icon(
          _state!.showAnswer ? Icons.visibility : Icons.visibility_off,
          size: 18,
        ),
        label: Text(_state!.showAnswer ? 'ヒントを隠す' : 'ヒントを見る'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final isCorrect = _state!.lastResult!;
    final color = isCorrect ? Colors.green : Colors.red;
    final icon = isCorrect ? Icons.check_circle : Icons.cancel;
    final text = isCorrect ? '正解!' : '不正解';
    final isLast = _state!.currentIndex >= _state!.entries.length - 1;
    final buttonLabel = isLast ? '完了' : '次へ';

    final feedbackContainer = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '正解: ${_state!.currentEntry!.koText}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'あなたの回答: ${_composer.text.trim()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // アニメーション付きのフィードバック表示
    final animatedFeedback = isCorrect
        ? TweenAnimationBuilder<double>(
            key: ValueKey('correct_${_state!.results.length}'),
            duration: const Duration(milliseconds: 400),
            tween: Tween<double>(begin: 0.8, end: 1),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: feedbackContainer,
          )
        : ShakeContainer(
            key: ValueKey('wrong_${_state!.results.length}'),
            shouldShake: true,
            child: feedbackContainer,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        animatedFeedback,
        const SizedBox(height: AppSpacing.md),
        FButton(
          style: FButtonStyle.primary(),
          onPress: _goToNextQuestion,
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
