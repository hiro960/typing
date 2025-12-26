import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../data/models/shadowing_models.dart';
import '../../domain/providers/shadowing_providers.dart';
import 'shadowing_list_screen.dart';

/// シャドーイングホーム画面（レベル選択）
class ShadowingHomeScreen extends ConsumerWidget {
  const ShadowingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(shadowingAllLevelStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('音読・シャドーイング'),
      ),
      body: statsAsync.when(
        data: (stats) => _buildContent(context, stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<ShadowingLevelStats> stats) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // 説明テキスト
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'お手本音声を聞きながら発音を練習しましょう。\n20回練習するとマスターになります。',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // レベルカード
        ...stats.map((stat) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _LevelCard(stats: stat),
        )),
      ],
    );
  }
}

/// レベルカード
class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.stats});

  final ShadowingLevelStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final levelInfo = _getLevelInfo(stats.level);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: levelInfo.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToList(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                levelInfo.color.withValues(alpha: isDark ? 0.15 : 0.08),
                levelInfo.color.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // レベルアイコン
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: levelInfo.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        levelInfo.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // レベル名とTOPIKレベル
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          levelInfo.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: levelInfo.color,
                          ),
                        ),
                        Text(
                          levelInfo.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 矢印
                  Icon(
                    Iconsax.arrow_right_3,
                    color: levelInfo.color,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // 進捗バー
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: stats.totalCount > 0
                      ? stats.masteredCount / stats.totalCount
                      : 0,
                  backgroundColor: levelInfo.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(levelInfo.color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // 統計
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${stats.masteredCount}/${stats.totalCount} マスター',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '全${stats.totalCount}コンテンツ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShadowingListScreen(level: stats.level),
      ),
    );
  }

  _LevelInfo _getLevelInfo(ShadowingLevel level) {
    switch (level) {
      case ShadowingLevel.beginner:
        return _LevelInfo(
          title: '初級',
          subtitle: 'TOPIK 1-2',
          emoji: '🟢',
          color: Colors.green,
        );
      case ShadowingLevel.intermediate:
        return _LevelInfo(
          title: '中級',
          subtitle: 'TOPIK 3-4',
          emoji: '🟡',
          color: Colors.orange,
        );
      case ShadowingLevel.advanced:
        return _LevelInfo(
          title: '高級',
          subtitle: 'TOPIK 5-6',
          emoji: '🔴',
          color: Colors.red,
        );
    }
  }
}

class _LevelInfo {
  const _LevelInfo({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
}
