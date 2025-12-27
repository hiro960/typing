import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../data/models/shadowing_models.dart';
import '../../domain/providers/shadowing_providers.dart';
import 'shadowing_practice_screen.dart';

/// シャドーイングコンテンツ一覧画面
class ShadowingListScreen extends ConsumerWidget {
  const ShadowingListScreen({
    super.key,
    required this.level,
  });

  final ShadowingLevel level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsAsync = ref.watch(shadowingContentsProvider(level));
    final progressAsync = ref.watch(shadowingAllProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getLevelTitle(level)),
      ),
      body: contentsAsync.when(
        data: (contents) => progressAsync.when(
          data: (progressMap) => _buildList(context, contents, progressMap),
          loading: () => _buildList(context, contents, {}),
          error: (_, __) => _buildList(context, contents, {}),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<ShadowingContent> contents,
    Map<String, ShadowingProgress> progressMap,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final content = contents[index];
        final progress = progressMap[content.id];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _ContentCard(
            content: content,
            progress: progress,
            level: level,
          ),
        );
      },
    );
  }

  String _getLevelTitle(ShadowingLevel level) {
    switch (level) {
      case ShadowingLevel.beginner:
        return '初級 (TOPIK 1-2)';
      case ShadowingLevel.intermediate:
        return '中級 (TOPIK 3-4)';
      case ShadowingLevel.advanced:
        return '高級 (TOPIK 5-6)';
    }
  }
}

/// コンテンツカード
class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.content,
    required this.progress,
    required this.level,
  });

  final ShadowingContent content;
  final ShadowingProgress? progress;
  final ShadowingLevel level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPracticed = progress?.isPracticed ?? false;
    final isMastered = progress?.isMastered ?? false;
    final practiceCount = progress?.practiceCount ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isMastered
              ? Colors.green.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isMastered ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPractice(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isMastered
                ? LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: isDark ? 0.15 : 0.05),
                      Colors.green.withValues(alpha: isDark ? 0.05 : 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ステータスアイコン
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getStatusColor(isPracticed, isMastered)
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(isPracticed, isMastered),
                    size: 16,
                    color: _getStatusColor(isPracticed, isMastered),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // コンテンツ情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(content.durationSeconds),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        if (practiceCount > 0) ...[
                          const SizedBox(width: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(isPracticed, isMastered)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$practiceCount回',
                              style: TextStyle(
                                fontSize: 11,
                                color: _getStatusColor(isPracticed, isMastered),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // 矢印
              Icon(
                Iconsax.arrow_right_3,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPractice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShadowingPracticeScreen(
          contentId: content.id,
          level: level,
        ),
      ),
    );
  }

  Color _getStatusColor(bool isPracticed, bool isMastered) {
    if (isMastered) return Colors.green;
    if (isPracticed) return Colors.blue;
    return Colors.grey;
  }

  IconData _getStatusIcon(bool isPracticed, bool isMastered) {
    if (isMastered) return Iconsax.medal_star;
    if (isPracticed) return Iconsax.tick_circle;
    return Iconsax.play_circle;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
