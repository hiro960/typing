import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../../features/lessons/data/models/lesson_models.dart';
import '../../../features/lessons/domain/providers/lesson_progress_providers.dart';
import '../../../features/stats/domain/providers/integrated_stats_providers.dart';
import '../../../features/typing/data/models/typing_models.dart';
import '../../../features/typing/data/models/typing_settings.dart';
import '../../../features/typing/domain/providers/typing_providers.dart';
import '../../../features/typing/domain/providers/typing_session_provider.dart';
import '../../../features/typing/domain/providers/typing_stats_provider.dart';
import '../../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import '../../widgets/typing/input_feedback_widget.dart';
import '../../widgets/typing/typing_progress_bar.dart';
import '../../widgets/typing/typing_prompt_card.dart';
import '../../widgets/typing_keyboard.dart';
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
          // 最初の問題を自動再生
          _speakCurrentItem(current);
        }

        // 問題が切り替わった時に自動再生
        if (current != null &&
            prevState != null &&
            !current.isCompleted &&
            (current.currentSectionIndex != prevState.currentSectionIndex ||
                current.currentItemIndex != prevState.currentItemIndex)) {
          _speakCurrentItem(current);
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
        onSpeak: _handleSpeak,
        settings: settings,
      ),
      loading: () => const AppPageScaffold(
        title: 'レッスン',
        showBackButton: true,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AppPageScaffold(
        title: 'レッスン',
        showBackButton: true,
        child: PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(typingSessionProvider(widget.lessonId)),
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    if (!mounted) return;
    await showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
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

  void _handleSpeak(String text) {
    ref.read(wordAudioServiceProvider.notifier).speak(text);
  }

  void _speakCurrentItem(TypingSessionState session) {
    final currentSection =
        session.lesson.content.sections[session.currentSectionIndex];
    final currentItem = currentSection.items[session.currentItemIndex];
    _handleSpeak(currentItem.text);
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

    // 統計プロバイダーを無効化して次回ホーム画面表示時に再取得
    ref.invalidate(integratedStatsProvider);
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
    required this.onSpeak,
    required this.settings,
  });

  final TypingSessionState session;
  final void Function(String value) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final VoidCallback onOpenSettings;
  final void Function(String text) onSpeak;
  final TypingSettings settings;

  static const _doubleConsonants = {'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ'};

  @override
  Widget build(BuildContext context) {
    final currentSection = session
        .lesson
        .content
        .sections[session.currentSectionIndex];
    final currentItem = currentSection.items[session.currentItemIndex];
    final totalItems = _totalItems(session.lesson);
    final completedItems = _completedItems(session);
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

    return AppPageScaffold(
      title: session.lesson.title,
      showBackButton: true,
      actions: [
        FHeaderAction(
          icon: const Icon(Iconsax.setting_2),
          onPress: onOpenSettings,
        ),
      ],
      childPad: false,
      safeTop: false,
      safeBottom: false,
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
                    TypingProgressBar(
                      current: completedItems + 1,
                      total: totalItems,
                      elapsedLabel: timerLabel,
                      showPercentage: true,
                      showDivider: false,
                      progressBarHeight: 6,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _InputFeedback(record: lastRecord),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TypingPromptCard(
                        targetText: currentItem.text,
                        subText: currentItem.meaning,
                        completedCharCount: TypingPromptCard.calculateCompletedCharCount(
                          currentItem.text,
                          session.currentPosition,
                        ),
                        fontSize: _getFontSize(currentSection.type),
                        showCharacterProgress: true,
                        onSpeak: () => onSpeak(currentItem.text),
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

  static double _getFontSize(LessonSectionType sectionType) {
    switch (sectionType) {
      case LessonSectionType.characterDrill:
        return 56;
      case LessonSectionType.sentencePractice:
        return 36;
      default:
        return 24;
    }
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
                ? PulseFeedback(
                    key: ValueKey('correct_${record!.timestamp.microsecondsSinceEpoch}'),
                    label: '正解！',
                  )
                : ShakeFeedback(
                    key: ValueKey('wrong_${record!.timestamp.microsecondsSinceEpoch}'),
                    label: 'ミス',
                  ),
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

    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border.symmetric(
          horizontal: BorderSide(color: context.theme.colors.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'クイック設定',
              style: context.theme.typography.xl2.copyWith(
                fontWeight: FontWeight.w600,
                color: context.theme.colors.foreground,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            FTile(
              title: const Text('ヒント表示'),
              subtitle: const Text('次に押すキーをハイライト表示します'),
              suffix: FSwitch(
                value: settings.hintsEnabled,
                onChange: isLoading ? null : controller.toggleHints,
              ),
              onPress: isLoading
                  ? null
                  : () => controller.toggleHints(!settings.hintsEnabled),
            ),
            FTile(
              title: const Text('触覚フィードバック'),
              suffix: FSwitch(
                value: settings.hapticsEnabled,
                onChange: isLoading ? null : controller.toggleHaptics,
              ),
              onPress: isLoading
                  ? null
                  : () => controller.toggleHaptics(!settings.hapticsEnabled),
            ),
          ],
        ),
      ),
    );
  }
}

