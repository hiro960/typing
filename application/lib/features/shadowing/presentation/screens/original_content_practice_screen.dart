import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../../../ui/app_theme.dart';
import '../../data/models/original_content.dart';
import '../../data/models/shadowing_models.dart';
import '../../domain/providers/original_content_providers.dart';
import '../../domain/providers/original_content_session_provider.dart';

/// オリジナル文章練習画面
class OriginalContentPracticeScreen extends ConsumerStatefulWidget {
  const OriginalContentPracticeScreen({
    super.key,
    required this.contentId,
  });

  final String contentId;

  @override
  ConsumerState<OriginalContentPracticeScreen> createState() =>
      _OriginalContentPracticeScreenState();
}

class _OriginalContentPracticeScreenState
    extends ConsumerState<OriginalContentPracticeScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _segmentKeys = {};
  int _lastScrolledSegmentIndex = -1;
  bool _showKorean = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSegment(int segmentIndex) {
    if (segmentIndex < 0 || segmentIndex == _lastScrolledSegmentIndex) return;

    final key = _segmentKeys[segmentIndex];
    if (key?.currentContext != null) {
      final renderBox = key!.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;

        final targetOffset = _scrollController.offset +
            position.dy -
            (screenHeight * 0.3);

        _scrollController.animateTo(
          targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
        _lastScrolledSegmentIndex = segmentIndex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionAsync =
        ref.watch(originalContentSessionProvider(widget.contentId));
    final contentAsync = ref.watch(originalContentProvider(widget.contentId));

    // 自動スクロール追従
    ref.listen(
      originalContentSessionProvider(widget.contentId),
      (previous, next) {
        final prevIndex = previous?.asData?.value.currentSegmentIndex ?? -1;
        final nextIndex = next.asData?.value.currentSegmentIndex ?? -1;
        if (nextIndex >= 0 && nextIndex != prevIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToSegment(nextIndex);
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: sessionAsync.whenOrNull(
          data: (state) => Text(
            state.content.title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          // リピートモード解除ボタン
          sessionAsync.whenOrNull(
                data: (state) => state.isRepeatMode
                    ? IconButton(
                        icon: const Icon(Iconsax.refresh_circle,
                            color: Colors.orange),
                        onPressed: () {
                          ref
                              .read(originalContentSessionProvider(
                                      widget.contentId)
                                  .notifier)
                              .clearRepeatMode();
                        },
                        tooltip: 'リピートモード解除',
                      )
                    : const SizedBox.shrink(),
              ) ??
              const SizedBox.shrink(),
          TextButton.icon(
            icon: Icon(
              _showKorean ? Iconsax.eye : Iconsax.eye_slash,
              size: 18,
            ),
            label: const Text('韓'),
            onPressed: () {
              setState(() {
                _showKorean = !_showKorean;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          // 日本語訳表示切替
          sessionAsync.whenOrNull(
                data: (state) => TextButton.icon(
                  icon: Icon(
                    state.showMeaning ? Iconsax.eye : Iconsax.eye_slash,
                    size: 18,
                  ),
                  label: const Text('日'),
                  onPressed: () {
                    ref
                        .read(originalContentSessionProvider(widget.contentId)
                            .notifier)
                        .toggleMeaning();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: sessionAsync.when(
        data: (state) => _buildContent(context, ref, state, contentAsync),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.warning_2,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'エラーが発生しました',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('戻る'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OriginalContentSessionState state,
    AsyncValue<OriginalContent?> contentAsync,
  ) {
    final practiceCount = state.content.practiceCount;
    final remainingToMaster = 20 - practiceCount;

    return Column(
      children: [
        // リピートモードバナー
        if (state.isRepeatMode)
          _RepeatModeBanner(
            segmentIndex: state.repeatSegmentIndex,
            onClear: () {
              ref
                  .read(
                      originalContentSessionProvider(widget.contentId).notifier)
                  .clearRepeatMode();
            },
          ),

        // セグメント表示エリア
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // セグメントテキスト
                _SegmentedText(
                  segments: state.content.segments,
                  currentSegmentIndex: state.currentSegmentIndex,
                  repeatSegmentIndex: state.repeatSegmentIndex,
                  showKorean: _showKorean,
                  showMeaning: state.showMeaning,
                  segmentKeys: _segmentKeys,
                  onSegmentTap: (index) {
                    ref
                        .read(originalContentSessionProvider(widget.contentId)
                            .notifier)
                        .playSegment(index);
                  },
                  onSegmentLongPress: (index) {
                    ref
                        .read(originalContentSessionProvider(widget.contentId)
                            .notifier)
                        .setRepeatSegment(index);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // 練習回数
                _PracticeCountCard(
                  practiceCount: practiceCount,
                  remainingToMaster: remainingToMaster,
                ),
              ],
            ),
          ),
        ),

        // 再生コントロール
        _PlaybackControls(
          state: state,
          onTogglePlayPause: () {
            ref
                .read(
                    originalContentSessionProvider(widget.contentId).notifier)
                .togglePlayPause();
          },
          onSeek: (position) {
            ref
                .read(
                    originalContentSessionProvider(widget.contentId).notifier)
                .seek(position);
          },
          onSpeedChange: (speed) {
            ref
                .read(
                    originalContentSessionProvider(widget.contentId).notifier)
                .setPlaybackSpeed(speed);
          },
        ),
      ],
    );
  }
}

/// セグメント化されたテキスト表示
class _SegmentedText extends StatelessWidget {
  const _SegmentedText({
    required this.segments,
    required this.currentSegmentIndex,
    required this.repeatSegmentIndex,
    required this.showKorean,
    required this.showMeaning,
    required this.segmentKeys,
    required this.onSegmentTap,
    required this.onSegmentLongPress,
  });

  final List<TextSegment> segments;
  final int currentSegmentIndex;
  final int repeatSegmentIndex;
  final bool showKorean;
  final bool showMeaning;
  final Map<int, GlobalKey> segmentKeys;
  final void Function(int) onSegmentTap;
  final void Function(int) onSegmentLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (segments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments.asMap().entries.map((entry) {
        final index = entry.key;
        final segment = entry.value;
        final isActive = index == currentSegmentIndex;
        final isRepeat = index == repeatSegmentIndex;

        segmentKeys[index] ??= GlobalKey();
        final segmentKey = segmentKeys[index]!;

        return GestureDetector(
          key: segmentKey,
          onTap: () => onSegmentTap(index),
          onLongPress: () => onSegmentLongPress(index),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isRepeat
                  ? Colors.orange.withValues(alpha: isDark ? 0.2 : 0.1)
                  : isActive
                      ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isRepeat
                  ? Border.all(
                      color: Colors.orange.withValues(alpha: 0.7),
                      width: 2,
                    )
                  : isActive
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          width: 2,
                        )
                      : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 韓国語テキスト
                      if (showKorean)
                        Text(
                          segment.text,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: isActive || isRepeat
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isRepeat
                                ? Colors.orange.shade700
                                : isActive
                                    ? AppColors.primary
                                    : theme.colorScheme.onSurface,
                            height: 1.6,
                          ),
                        ),
                      // 日本語訳
                      if (showMeaning) ...[
                        if (showKorean) const SizedBox(height: 4),
                        Text(
                          segment.meaning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // リピートインジケーター
                if (isRepeat) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.repeat,
                      color: Colors.orange,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// リピートモードバナー
class _RepeatModeBanner extends StatelessWidget {
  const _RepeatModeBanner({
    required this.segmentIndex,
    required this.onClear,
  });

  final int segmentIndex;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: Colors.orange.withValues(alpha: 0.15),
      child: Row(
        children: [
          const Icon(
            Iconsax.repeat,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'リピートモード: セグメント ${segmentIndex + 1} をループ再生中',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange.shade700,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('解除'),
          ),
        ],
      ),
    );
  }
}

/// 練習回数カード
class _PracticeCountCard extends StatelessWidget {
  const _PracticeCountCard({
    required this.practiceCount,
    required this.remainingToMaster,
  });

  final int practiceCount;
  final int remainingToMaster;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMastered = remainingToMaster <= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isMastered
            ? Colors.green.withValues(alpha: isDark ? 0.15 : 0.1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isMastered ? Iconsax.medal_star : Iconsax.refresh_circle,
            color: isMastered ? Colors.green : AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '練習回数: $practiceCount/20',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isMastered ? 'マスター達成！' : 'あと$remainingToMaster回でマスター',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isMastered
                        ? Colors.green
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // 進捗リング
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: (practiceCount / 20).clamp(0.0, 1.0),
                  strokeWidth: 4,
                  backgroundColor:
                      theme.colorScheme.outline.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    isMastered ? Colors.green : AppColors.primary,
                  ),
                ),
                Center(
                  child: Text(
                    '${((practiceCount / 20) * 100).clamp(0, 100).round()}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 再生コントロール
class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({
    required this.state,
    required this.onTogglePlayPause,
    required this.onSeek,
    required this.onSpeedChange,
  });

  final OriginalContentSessionState state;
  final VoidCallback onTogglePlayPause;
  final void Function(Duration) onSeek;
  final void Function(PlaybackSpeed) onSpeedChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // シークバー
          Row(
            children: [
              Text(
                _formatDuration(state.currentPosition),
                style: theme.textTheme.bodySmall,
              ),
              Expanded(
                child: Builder(
                  builder: (_) {
                    final maxValue = state.totalDuration.inMilliseconds
                        .toDouble()
                        .clamp(1.0, double.infinity);
                    final currentValue = state.currentPosition.inMilliseconds
                        .toDouble()
                        .clamp(0.0, maxValue);
                    return Slider(
                      value: currentValue,
                      max: maxValue,
                      onChanged: (value) {
                        onSeek(Duration(milliseconds: value.round()));
                      },
                      activeColor: AppColors.primary,
                    );
                  },
                ),
              ),
              Text(
                _formatDuration(state.totalDuration),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),

          // 速度コントロール
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: PlaybackSpeed.values.map((speed) {
              final isSelected = state.playbackSpeed == speed;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    speed.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => onSpeedChange(speed),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  visualDensity: VisualDensity.compact,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),

          // 再生/一時停止ボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 64), // スペーサー
              // 再生/一時停止
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    state.isPlaying ? Iconsax.pause : Iconsax.play,
                    color: Colors.white,
                  ),
                  onPressed: onTogglePlayPause,
                  iconSize: 36,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 64), // スペーサー
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
