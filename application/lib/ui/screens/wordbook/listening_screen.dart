import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/listening_player_controller.dart';
import '../../../features/settings/domain/providers/display_settings_provider.dart';
import '../../../features/settings/data/models/display_settings.dart';
import 'listening_settings_sheet.dart';

class ListeningScreen extends ConsumerStatefulWidget {
  const ListeningScreen({super.key, required this.words});

  final List<Word> words;

  @override
  ConsumerState<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends ConsumerState<ListeningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(listeningPlayerControllerProvider.notifier).start(widget.words);
    });
  }

  @override
  void dispose() {
    // Provider自体がdisposeされるので、明示的にstopを呼ぶ必要はない
    super.dispose();
  }

  void _handleBackPressed() {
    ref.read(listeningPlayerControllerProvider.notifier).stop();
    Navigator.of(context).pop();
  }

  void _showSettingsSheet() {
    // 設定シートを開く前に一時停止
    final wasPlaying =
        ref.read(listeningPlayerControllerProvider).isPlaying;
    if (wasPlaying) {
      ref.read(listeningPlayerControllerProvider.notifier).pause();
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ListeningSettingsSheet(),
    ).then((_) {
      // シートを閉じたら再開
      if (wasPlaying && mounted) {
        ref.read(listeningPlayerControllerProvider.notifier).resume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listeningPlayerControllerProvider);
    final displaySettings =
        ref.watch(displaySettingsProvider).value ?? const DisplaySettings();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton(
            style: FButtonStyle.ghost(),
            onPress: _handleBackPressed,
            child: const Icon(Iconsax.close_circle),
          ),
        ],
        title: const Text('聞き流し'),
        suffixes: [
          FButton(
            style: FButtonStyle.ghost(),
            onPress: _showSettingsSheet,
            child: const Icon(Iconsax.setting_2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              // 進捗表示
              if (state.hasSession) ...[
                Text(
                  state.positionText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (state.loopCount > 0)
                  Text(
                    '${state.loopCount}周目',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
              const SizedBox(height: 24),

              // 単語カード
              Expanded(
                child: state.hasSession && state.currentWord != null
                    ? _WordCard(
                        word: state.currentWord!,
                        currentlyPlaying: state.currentlyPlaying,
                        fontScale: displaySettings.promptFontScale,
                      )
                    : const _EmptyState(),
              ),

              const SizedBox(height: 24),

              // コントロールボタン
              _ControlButtons(
                isPlaying: state.isPlaying,
                hasSession: state.hasSession,
                onPrevious: () => ref
                    .read(listeningPlayerControllerProvider.notifier)
                    .previous(),
                onPlayPause: () {
                  if (state.isPlaying) {
                    ref
                        .read(listeningPlayerControllerProvider.notifier)
                        .pause();
                  } else {
                    ref
                        .read(listeningPlayerControllerProvider.notifier)
                        .resume();
                  }
                },
                onNext: () => ref
                    .read(listeningPlayerControllerProvider.notifier)
                    .next(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 単語表示カード
class _WordCard extends StatelessWidget {
  const _WordCard({
    required this.word,
    required this.currentlyPlaying,
    required this.fontScale,
  });

  final Word word;
  final CurrentlyPlaying currentlyPlaying;
  final double fontScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: FCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 韓国語
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentlyPlaying == CurrentlyPlaying.korean
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    word.word,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 32) *
                          fontScale,
                      color: currentlyPlaying == CurrentlyPlaying.korean
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // 日本語
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: currentlyPlaying == CurrentlyPlaying.japanese
                        ? colorScheme.secondaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    word.meaning,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) *
                          fontScale,
                      color: currentlyPlaying == CurrentlyPlaying.japanese
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// コントロールボタン
class _ControlButtons extends StatelessWidget {
  const _ControlButtons({
    required this.isPlaying,
    required this.hasSession,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
  });

  final bool isPlaying;
  final bool hasSession;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 前へボタン
        IconButton.filled(
          onPressed: hasSession ? onPrevious : null,
          icon: const Icon(Iconsax.previous),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 24),

        // 再生/一時停止ボタン
        IconButton.filled(
          onPressed: hasSession ? onPlayPause : null,
          icon: Icon(isPlaying ? Iconsax.pause : Iconsax.play),
          iconSize: 40,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size(72, 72),
          ),
        ),
        const SizedBox(width: 24),

        // 次へボタン
        IconButton.filled(
          onPressed: hasSession ? onNext : null,
          icon: const Icon(Iconsax.next),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// 空の状態
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.music,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '単語がありません',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
