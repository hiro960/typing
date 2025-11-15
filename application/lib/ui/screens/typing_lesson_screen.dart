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

class _TypingLessonScreenState extends ConsumerState<TypingLessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(typingSessionProvider(widget.lessonId).notifier).start();
    });
    ref.listen<AsyncValue<TypingSessionState>>(
      typingSessionProvider(widget.lessonId),
      (previous, next) {
        final prevState = previous?.asData?.value;
        final current = next.asData?.value;
        if (current != null &&
            current.isCompleted &&
            (prevState == null || !prevState.isCompleted)) {
          _handleCompletion(current);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(typingSessionProvider(widget.lessonId));
    final settingsAsync = ref.watch(typingSettingsProvider);
    final settings = settingsAsync.value ?? const TypingSettings();
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
    await _submitCompletion(session, stats);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
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
    );
    try {
      await repository.submitCompletion(
        lessonId: session.lessonId,
        wpm: stats.wpm,
        accuracy: stats.accuracy,
        timeSpentMs: session.elapsedMs,
      );
    } on AppException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to submit completion, enqueueing',
        tag: 'TypingLessonScreen',
        error: error,
        stackTrace: stackTrace,
      );
      await repository.enqueueCompletion(completion);
      if (mounted) {
        _showSnack('オフラインのため後で自動送信します');
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unknown error submitting completion',
        tag: 'TypingLessonScreen',
        error: error,
        stackTrace: stackTrace,
      );
      await repository.enqueueCompletion(completion);
      if (mounted) {
        _showSnack('送信に失敗しました。後で再試行します。');
      }
    }

    await ref
        .read(lessonProgressControllerProvider.notifier)
        .markCompleted(
          lessonId: session.lessonId,
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
    final currentItem = _currentItem(session);
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
        ? {_normalizeKey(nextKey!)}
        : const <String>{};

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
                      Text(
                        '進捗 ${(progress * 100).round()}% (${completedItems + 1}/$totalItems)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      Text(timerLabel, style: theme.textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _PromptCard(item: currentItem, session: session),
            ),
            const SizedBox(height: 16),
            if (showHints) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _JamoHint(session: session),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: TypingKeyboard(
                    onTextInput: onTextInput,
                    onBackspace: onBackspace,
                    onSpace: onSpace,
                    onEnter: onEnter,
                    highlightedKeys: highlightedKeys,
                    highlightShift: highlightShift,
                    nextKeyLabel:
                        showHints ? _nextKeyLabel(nextKey) : null,
                    enableSound: settings.keySoundEnabled,
                    enableHaptics: settings.hapticsEnabled,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static LessonItem _currentItem(TypingSessionState session) {
    return session
        .lesson
        .content
        .sections[session.currentSectionIndex]
        .items[session.currentItemIndex];
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
    final typedJamo = HangulComposer.decomposeText(session.inputBuffer);
    if (typedJamo.length >= targetJamo.length) {
      return null;
    }
    return targetJamo[typedJamo.length];
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
  const _PromptCard({required this.item, required this.session});

  final LessonItem item;
  final TypingSessionState session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final targetChars = item.text.characters.toList();
    final typedChars = session.inputBuffer.characters.toList();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '問題',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                for (int i = 0; i < targetChars.length; i++)
                  TextSpan(
                    text: targetChars[i],
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: i < typedChars.length
                          ? (typedChars[i] == targetChars[i]
                                ? colors.primary
                                : colors.error)
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
}

class _JamoHint extends StatelessWidget {
  const _JamoHint({required this.session});

  final TypingSessionState session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = [
      if (session.jamoState.initial != null) session.jamoState.initial!,
      if (session.jamoState.medial != null) session.jamoState.medial!,
      if (session.jamoState.finalConsonant != null)
        session.jamoState.finalConsonant!,
    ];
    final composed = parts.isEmpty
        ? '-'
        : '${parts.join(' + ')} → ${session.jamoState.initial ?? ''}${session.jamoState.medial ?? ''}${session.jamoState.finalConsonant ?? ''}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      child: Text('組み立て中: $composed', style: theme.textTheme.bodyMedium),
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
              title: const Text('ヒントを表示'),
              subtitle: const Text('次に押すキーとJamoヒントを表示します'),
              value: settings.hintsEnabled,
              onChanged: isLoading ? null : controller.toggleHints,
            ),
            SwitchListTile.adaptive(
              title: const Text('キー音'),
              subtitle: const Text('タップ時にシステム音を再生'),
              value: settings.keySoundEnabled,
              onChanged: isLoading ? null : controller.toggleKeySound,
            ),
            SwitchListTile.adaptive(
              title: const Text('振動フィードバック'),
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
