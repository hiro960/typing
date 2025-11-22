import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/utils/logger.dart';
import '../../features/lessons/data/models/lesson_models.dart';
import '../../features/lessons/domain/providers/lesson_progress_providers.dart';
import '../../features/typing/data/models/typing_models.dart';
import '../../features/typing/data/models/typing_settings.dart';
import '../../features/typing/domain/providers/typing_providers.dart';
import '../../features/typing/domain/providers/typing_session_provider.dart';
import '../../features/typing/domain/providers/typing_stats_provider.dart';
import '../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../features/typing/domain/services/hangul_composer.dart';
import '../widgets/typing_keyboard.dart';
import 'typing_completion_screen.dart';

class TypingLessonScreen extends ConsumerStatefulWidget {
  const TypingLessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<TypingLessonScreen> createState() => _TypingLessonScreenState();
}

class _TypingLessonScreenState extends ConsumerState<TypingLessonScreen>
    with WidgetsBindingObserver {
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(typingSessionProvider(widget.lessonId).notifier);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      notifier.pause();
    } else if (state == AppLifecycleState.resumed) {
      notifier.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(typingSessionProvider(widget.lessonId));
    final settingsAsync = ref.watch(typingSettingsProvider);
    final settings = settingsAsync.value ?? const TypingSettings();
    ref.listen<AsyncValue<TypingSessionState>>(
      typingSessionProvider(widget.lessonId),
      (previous, next) {
        final prevState = previous?.asData?.value;
        final current = next.asData?.value;

        // セッションがdataになった時点でタイマーを開始
        if (current != null && !_hasStarted && !current.isCompleted) {
          _hasStarted = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(typingSessionProvider(widget.lessonId).notifier).start();
          });
        }

        if (current != null &&
            current.isCompleted &&
            (prevState == null || !prevState.isCompleted)) {
          _handleCompletion(current);
        }
      },
    );
    return sessionAsync.when(
      data: (session) => _LessonView(
        session: session,
        onTextInput: _handleCharacter,
        onBackspace: _handleBackspace,
        onSpace: _handleSpace,
        onEnter: _handleEnter,
        onOpenSettings: _openSettings,
        settings: settings,
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => _ErrorScaffold(error: error.toString()),
    );
  }

  Future<void> _openSettings() async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _TypingSettingsSheet(),
    );
  }

  void _handleCharacter(String char) {
    ref
        .read(typingSessionProvider(widget.lessonId).notifier)
        .handleCharacter(char);
  }

  void _handleBackspace() {
    ref.read(typingSessionProvider(widget.lessonId).notifier).handleBackspace();
  }

  void _handleSpace() {
    ref.read(typingSessionProvider(widget.lessonId).notifier).handleSpace();
  }

  void _handleEnter() {
    ref
        .read(typingSessionProvider(widget.lessonId).notifier)
        .handleCharacter('\n');
  }

  Future<void> _handleCompletion(TypingSessionState session) async {
    final stats = ref.read(typingStatsProvider(widget.lessonId));

    // 画面遷移の前にcompletionを送信（エラーは無視）
    try {
      await _submitCompletion(session, stats);
    } catch (e) {
      // エラーはログに記録され、オフラインキューに追加済み
      // 画面遷移は続行
    }

    if (!mounted) {
      return;
    }

    // 画面遷移を実行
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => TypingCompletionScreen(
          lesson: session.lesson,
          stats: stats,
          records: session.records,
          lessonId: widget.lessonId,
        ),
      ),
    );
  }

  Future<void> _submitCompletion(
    TypingSessionState session,
    TypingStatsData stats,
  ) async {
    final repository = ref.read(typingRepositoryProvider);
    final completion = repository.buildPendingCompletion(
      lessonId: session.lessonId,
      wpm: stats.wpm,
      accuracy: stats.accuracy,
      timeSpentMs: session.elapsedMs,
      mistakeCharacters: session.mistakeHistory,
    );
    try {
      await repository.submitCompletion(
        lessonId: session.lessonId,
        wpm: stats.wpm,
        accuracy: stats.accuracy,
        timeSpentMs: session.elapsedMs,
        mistakeCharacters: session.mistakeHistory,
      );
    } on AppException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to submit completion, enqueueing',
        tag: 'TypingLessonScreen',
        error: error,
        stackTrace: stackTrace,
      );
      await repository.enqueueCompletion(completion);
      // エラーをthrowして呼び出し元で処理
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unknown error submitting completion',
        tag: 'TypingLessonScreen',
        error: error,
        stackTrace: stackTrace,
      );
      await repository.enqueueCompletion(completion);
      // エラーをthrowして呼び出し元で処理
      rethrow;
    }

    // 成功した場合のみ進捗を更新（100%完了）
    final totalItems = session.lesson.content.sections.fold<int>(
      0,
      (sum, section) => sum + section.items.length,
    );
    await ref
        .read(lessonProgressControllerProvider.notifier)
        .markCompleted(
          lessonId: session.lessonId,
          completedItems: totalItems,
          totalItems: totalItems,
          wpm: stats.wpm,
          accuracy: stats.accuracy,
        );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

}

class _LessonView extends StatelessWidget {
  const _LessonView({
    required this.session,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSpace,
    required this.onEnter,
    required this.onOpenSettings,
    required this.settings,
  });

  final TypingSessionState session;
  final void Function(String value) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final VoidCallback onOpenSettings;
  final TypingSettings settings;

  static const _doubleConsonants = {'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSection = session
        .lesson
        .content
        .sections[session.currentSectionIndex];
    final currentItem = currentSection.items[session.currentItemIndex];
    final totalItems = _totalItems(session.lesson);
    final completedItems = _completedItems(session);
    final progress = totalItems == 0 ? 0.0 : completedItems / totalItems;
    final timerLabel = _formatTimer(session.elapsedMs);
    final nextKey = _nextKey(session, currentItem);
    final showHints = settings.hintsEnabled;
    final shouldHighlight = showHints && nextKey != null;
    final highlightShift =
        shouldHighlight && _doubleConsonants.contains(nextKey);
    final highlightedKeys = shouldHighlight
        ? {_normalizeKey(nextKey)}
        : const <String>{};
    final lastRecord = session.records.isEmpty ? null : session.records.last;

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: Text(session.lesson.title),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.settings_outlined),
            onPress: onOpenSettings,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress.clamp(0, 1),
                            minHeight: 6,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '進捗 ${(progress * 100).round()}% (${completedItems + 1}/$totalItems)',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(timerLabel,
                                  style: theme.textTheme.titleMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _InputFeedback(record: lastRecord),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _PromptCard(
                        item: currentItem,
                        sectionType: currentSection.type,
                        session: session,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16 + MediaQuery.of(context).padding.bottom,
              ),
              child: TypingKeyboard(
                onTextInput: onTextInput,
                onBackspace: onBackspace,
                onSpace: onSpace,
                onEnter: onEnter,
                highlightedKeys: highlightedKeys,
                highlightShift: highlightShift,
                nextKeyLabel: showHints ? _nextKeyLabel(nextKey) : null,
                enableHaptics: settings.hapticsEnabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _totalItems(Lesson lesson) {
    return lesson.content.sections.fold<int>(
      0,
      (sum, section) => sum + section.items.length,
    );
  }

  static int _completedItems(TypingSessionState session) {
    int completed = 0;
    for (int i = 0; i < session.currentSectionIndex; i++) {
      completed += session.lesson.content.sections[i].items.length;
    }
    completed += session.currentItemIndex;
    return completed;
  }

  static String _formatTimer(int elapsedMs) {
    final duration = Duration(milliseconds: elapsedMs);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final tenths = ((elapsedMs % 1000) / 100).floor();
    return '$minutes:$seconds.$tenths';
  }

  static String? _nextKey(TypingSessionState session, LessonItem item) {
    final targetJamo = HangulComposer.decomposeText(item.text);
    // currentPositionを使用して次の字母を取得
    if (session.currentPosition >= targetJamo.length) {
      return null;
    }
    return targetJamo[session.currentPosition];
  }

  static String _normalizeKey(String key) {
    switch (key) {
      case 'ㄲ':
        return 'ㄱ';
      case 'ㄸ':
        return 'ㄷ';
      case 'ㅃ':
        return 'ㅂ';
      case 'ㅆ':
        return 'ㅅ';
      case 'ㅉ':
        return 'ㅈ';
      default:
        return key;
    }
  }

  static String? _nextKeyLabel(String? key) {
    if (key == null) {
      return null;
    }
    return key == ' ' ? '次は スペース' : '次は $key';
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.item,
    required this.sectionType,
    required this.session,
  });

  final LessonItem item;
  final LessonSectionType sectionType;
  final TypingSessionState session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final targetChars = item.text.characters.toList();

    // 字母レベルの進捗から完成した文字数を計算
    final completedCharCount = _calculateCompletedCharCount(
      item.text,
      session.currentPosition,
    );

    final bool isCharacterDrill =
        sectionType == LessonSectionType.characterDrill;
    final bool isSentence =
        sectionType == LessonSectionType.sentencePractice;
    final textStyle = (isCharacterDrill
            ? theme.textTheme.displayLarge
            : theme.textTheme.displaySmall)
        ?.copyWith(
      fontSize: isCharacterDrill ? 56 : (isSentence ? 36 : null),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            colors.surfaceContainerHighest.withValues(alpha: 0.2),
            colors.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            offset: const Offset(0, 20),
            color: colors.primary.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                for (int i = 0; i < targetChars.length; i++)
                  TextSpan(
                    text: targetChars[i],
                    style: textStyle?.copyWith(
                      // 正解済みの文字数に基づいて色付け
                      color: i < completedCharCount
                          ? colors.primary
                          : colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          if ((item.meaning ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.meaning!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 字母レベルの進捗から完成した文字数を計算
  int _calculateCompletedCharCount(String targetText, int currentPosition) {
    final targetChars = targetText.characters.toList();
    int jamoCount = 0;

    for (int i = 0; i < targetChars.length; i++) {
      final jamos = HangulComposer.decomposeSyllable(targetChars[i]);
      jamoCount += jamos.length;

      // 現在の位置がこの文字の字母範囲内の場合、この文字は未完成
      if (currentPosition < jamoCount) {
        return i;
      }
    }

    // すべての文字が完成
    return targetChars.length;
  }
}

class _InputFeedback extends StatelessWidget {
  const _InputFeedback({required this.record});

  final InputRecord? record;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: record == null
            ? const SizedBox.shrink()
            : record!.isCorrect
                ? _PulseFeedback(
                    key: ValueKey('correct_${record!.timestamp.microsecondsSinceEpoch}'),
                    label: '正解！',
                  )
                : _ShakeFeedback(
                    key: ValueKey('wrong_${record!.timestamp.microsecondsSinceEpoch}'),
                    label: 'ミス',
                  ),
      ),
    );
  }
}

class _PulseFeedback extends StatelessWidget {
  const _PulseFeedback({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.8, end: 1),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _ShakeFeedback extends StatelessWidget {
  const _ShakeFeedback({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        final offset = math.sin(value * math.pi * 5) * 6;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.close_rounded, color: Colors.red, size: 20),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _TypingSettingsSheet extends ConsumerWidget {
  const _TypingSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(typingSettingsProvider);
    final settings = settingsAsync.value ?? const TypingSettings();
    final controller = ref.read(typingSettingsProvider.notifier);
    final isLoading = settingsAsync.isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'クイック設定',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: const Text('ヒント表示'),
              subtitle: const Text('次に押すキーをハイライト表示します'),
              value: settings.hintsEnabled,
              onChanged: isLoading ? null : controller.toggleHints,
            ),
            SwitchListTile.adaptive(
              title: const Text('触覚フィードバック'),
              value: settings.hapticsEnabled,
              onChanged: isLoading ? null : controller.toggleHaptics,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
