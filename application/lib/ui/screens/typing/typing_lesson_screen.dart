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
import '../../../features/settings/domain/providers/display_settings_provider.dart';
import '../../../features/settings/data/models/display_settings.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../../features/wordbook/data/models/audio_settings.dart';
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
    final displaySettingsAsync = ref.watch(displaySettingsProvider);
    final displaySettings =
        displaySettingsAsync.value ?? const DisplaySettings();
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
        displaySettings: displaySettings,
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

class _LessonView extends StatefulWidget {
  const _LessonView({
    required this.session,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSpace,
    required this.onEnter,
    required this.onOpenSettings,
    required this.onSpeak,
    required this.settings,
    required this.displaySettings,
  });

  final TypingSessionState session;
  final void Function(String value) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final VoidCallback onOpenSettings;
  final void Function(String text) onSpeak;
  final TypingSettings settings;
  final DisplaySettings displaySettings;

  @override
  State<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<_LessonView> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  String _previousText = '';
  /// 前回分解した字母リスト（内蔵キーボード用）
  List<String> _previousJamos = [];

  // シフトキーが必要な文字（濃音 + シフト変換母音）
  static const _shiftRequiredKeys = {'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ', 'ㅒ', 'ㅖ'};

  // シンボルキーボードにのみ存在する文字
  static const _symbolOnlyKeys = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    '!', '@', '#', '?', ',', ';', ':',
    '-', '/', '+', '=', '(', ')', '"', "'",
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_LessonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 問題が切り替わったらテキストフィールドと字母リストをクリア
    if (oldWidget.session.currentItemIndex != widget.session.currentItemIndex ||
        oldWidget.session.currentSectionIndex != widget.session.currentSectionIndex) {
      _textController.clear();
      _previousText = '';
      _previousJamos = [];
    }
  }

  void _handleTextChanged(String newText) {
    // 新しいテキスト全体を字母に分解
    final newJamos = <String>[];
    for (final char in newText.characters) {
      if (char == ' ') {
        newJamos.add(' ');
      } else if (char == '\n') {
        newJamos.add('\n');
      } else {
        newJamos.addAll(HangulComposer.decomposeText(char));
      }
    }

    // バックスペースが押された場合（テキストが短くなった、または字母数が減った）
    // 何も送信せず、状態のみ更新して終了
    if (newJamos.length < _previousJamos.length) {
      _previousText = newText;
      _previousJamos = newJamos;
      return;
    }

    // TypingSessionの現在位置を取得（既に処理済みの字母数）
    final currentPosition = widget.session.currentPosition;

    // iOS IMEは合成中にテキストをクリアすることがあるため、
    // TypingSessionのcurrentPositionを基準にして送信する字母を決定
    // currentPosition以降の字母だけを送信する
    final startIndex = currentPosition;

    // 新しく追加された字母を処理（currentPosition以降の部分）
    for (int i = startIndex; i < newJamos.length; i++) {
      final jamo = newJamos[i];
      if (jamo == ' ') {
        widget.onSpace();
      } else if (jamo == '\n') {
        widget.onEnter();
      } else {
        widget.onTextInput(jamo);
      }
    }

    // 状態を更新
    _previousText = newText;
    _previousJamos = newJamos;
  }

  @override
  Widget build(BuildContext context) {
    final currentSection = widget.session
        .lesson
        .content
        .sections[widget.session.currentSectionIndex];
    final currentItem = currentSection.items[widget.session.currentItemIndex];
    final totalItems = _totalItems(widget.session.lesson);
    final completedItems = _completedItems(widget.session);
    final timerLabel = _formatTimer(widget.session.elapsedMs);
    final nextKey = _nextKey(widget.session, currentItem);
    final showHints = widget.settings.hintsEnabled;
    final useCustomKeyboard = widget.settings.useCustomKeyboard;
    final shouldHighlight = showHints && nextKey != null && useCustomKeyboard;
    final highlightShift =
        shouldHighlight && _shiftRequiredKeys.contains(nextKey);
    final highlightSymbol =
        shouldHighlight && _symbolOnlyKeys.contains(nextKey);
    final highlightedKeys = shouldHighlight
        ? {_normalizeKey(nextKey)}
        : const <String>{};
    final lastRecord = widget.session.records.isEmpty ? null : widget.session.records.last;

    return AppPageScaffold(
      title: widget.session.lesson.title,
      showBackButton: true,
      actions: [
        FHeaderAction(
          icon: const Icon(Iconsax.setting_2),
          onPress: widget.onOpenSettings,
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
                          widget.session.currentPosition,
                        ),
                        fontSize: _getFontSize(currentSection.type) *
                            widget.displaySettings.promptFontScale,
                        showCharacterProgress: true,
                        onSpeak: () => widget.onSpeak(currentItem.text),
                      ),
                    ),
                    // システムキーボード用の入力フィールド
                    if (!useCustomKeyboard)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: _buildSystemKeyboardInput(context),
                      ),
                  ],
                ),
              ),
            ),
            if (useCustomKeyboard)
              Padding(
                padding: EdgeInsets.only(
                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                ),
                child: TypingKeyboard(
                  onTextInput: widget.onTextInput,
                  onBackspace: widget.onBackspace,
                  onSpace: widget.onSpace,
                  onEnter: widget.onEnter,
                  highlightedKeys: highlightedKeys,
                  highlightShift: highlightShift,
                  highlightSymbol: highlightSymbol,
                  nextKeyLabel: showHints ? _nextKeyLabel(nextKey) : null,
                  enableHaptics: widget.settings.hapticsEnabled,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemKeyboardInput(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        autofocus: true,
        textAlign: TextAlign.center,
        autocorrect: false,
        enableSuggestions: false,
        enableIMEPersonalizedLearning: false,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          hintText: '韓国語を入力してください',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
            fontSize: 18,
          ),
          border: InputBorder.none,
        ),
        onChanged: _handleTextChanged,
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
      // 濃音 → 基本子音
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
      // シフト変換母音 → 基本母音
      case 'ㅒ':
        return 'ㅐ';
      case 'ㅖ':
        return 'ㅔ';
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

  String _getRateLabel(double rate) {
    return '${rate.toStringAsFixed(1)}x';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(typingSettingsProvider);
    final settings = settingsAsync.value ?? const TypingSettings();
    final controller = ref.read(typingSettingsProvider.notifier);
    final isLoading = settingsAsync.isLoading;

    final audioSettingsAsync = ref.watch(audioSettingsProvider);
    final audioSettings = audioSettingsAsync.value;
    final audioController = ref.read(audioSettingsProvider.notifier);
    final isAudioLoading = audioSettingsAsync.isLoading;

    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.background,
        border: Border.symmetric(
          horizontal: BorderSide(color: theme.colors.border),
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
              style: theme.typography.xl2.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colors.foreground,
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
            Divider(color: theme.colors.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.volume_high, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '発声スピード',
                          style: theme.typography.base.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isAudioLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '遅い',
                        style: theme.typography.xs.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: theme.colors.primary,
                            inactiveTrackColor:
                                theme.colors.primary.withValues(alpha: 0.2),
                            thumbColor: theme.colors.primary,
                            overlayColor:
                                theme.colors.primary.withValues(alpha: 0.1),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                          ),
                          child: Slider(
                            value: (audioSettings?.speechRate ?? 1.0)
                                .clamp(AudioSettings.minRate, AudioSettings.maxRate),
                            min: AudioSettings.minRate,
                            max: AudioSettings.maxRate,
                            divisions: 6,
                            label: _getRateLabel(
                              audioSettings?.speechRate ?? 1.0,
                            ),
                            onChanged: isAudioLoading
                                ? null
                                : (value) => audioController.setSpeechRate(value),
                          ),
                        ),
                      ),
                      Text(
                        '速い',
                        style: theme.typography.xs.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      _getRateLabel(audioSettings?.speechRate ?? 1.0),
                      style: theme.typography.sm.copyWith(
                        color: theme.colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

