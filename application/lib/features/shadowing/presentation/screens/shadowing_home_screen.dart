import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../features/auth/data/models/user_model.dart';
import '../../../../features/auth/domain/providers/auth_providers.dart';
import '../../../../ui/app_spacing.dart';
import '../../../../ui/app_theme.dart';
import '../../../../ui/widgets/premium_feature_gate.dart';
import '../../data/models/shadowing_models.dart';
import '../../data/repositories/original_content_repository.dart';
import '../../domain/providers/original_content_providers.dart';
import '../../domain/providers/shadowing_providers.dart';
import 'original_content_list_screen.dart';
import 'shadowing_list_screen.dart';

/// シャドーイングホーム画面（レベル選択）
class ShadowingHomeScreen extends ConsumerWidget {
  const ShadowingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(shadowingAllLevelStatsProvider);
    final originalStatsAsync = ref.watch(originalContentStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('音読・シャドーイング'),
      ),
      body: statsAsync.when(
        data: (stats) => _buildContent(
          context,
          stats,
          originalStatsAsync.asData?.value,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ShadowingLevelStats> stats,
    OriginalContentStats? originalStats,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = FeatureGradients.shadowing.first;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // 説明テキスト
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: isDark ? 0.16 : 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: accentColor,
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

        // オリジナル文章カード
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _OriginalContentCard(stats: originalStats),
        ),
      ],
    );
  }
}

/// レベルカード
class _LevelCard extends ConsumerWidget {
  const _LevelCard({required this.stats});

  final ShadowingLevelStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final levelInfo = _getLevelInfo(stats.level);
    final isPremiumRequired = _isPremiumRequired(stats.level);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: levelInfo.color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToList(context, ref),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                levelInfo.color.withValues(alpha: isDark ? 0.18 : 0.1),
                levelInfo.color.withValues(alpha: isDark ? 0.08 : 0.04),
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
                      color:
                          levelInfo.color.withValues(alpha: isDark ? 0.25 : 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        levelInfo.icon,
                        color: levelInfo.color,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // レベル名とTOPIKレベル
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              levelInfo.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            if (isPremiumRequired) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Icon(
                                Iconsax.crown,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          levelInfo.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 矢印
                  Icon(
                    Iconsax.arrow_right_3,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
                  backgroundColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.5 : 0.7),
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

  bool _isPremiumRequired(ShadowingLevel level) {
    return level == ShadowingLevel.intermediate ||
        level == ShadowingLevel.advanced;
  }

  void _navigateToList(BuildContext context, WidgetRef ref) {
    // 中級・高級は有料会員限定
    if (_isPremiumRequired(stats.level)) {
      final authState = ref.read(authStateProvider);
      final isPremium = authState.user?.isPremiumUser ?? false;

      if (!isPremium) {
        _showPremiumOnlyDialog(context);
        return;
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShadowingListScreen(level: stats.level),
      ),
    );
  }

  void _showPremiumOnlyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.crown, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('有料会員限定'),
          ],
        ),
        content: const Text(
          'この機能は有料会員限定です。\n\nアップグレードすると、中級・高級・オリジナル文章の音読・シャドーイングをご利用いただけます。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const PremiumFeatureGateScreen(focusFeature: 'ネイティブ発音'),
                ),
              );
            },
            child: const Text('プロプランを見る'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  _LevelInfo _getLevelInfo(ShadowingLevel level) {
    final startColor = FeatureGradients.shadowing[0];
    final endColor = FeatureGradients.shadowing[1];
    final midColor = Color.lerp(startColor, endColor, 0.5) ?? startColor;

    switch (level) {
      case ShadowingLevel.beginner:
        return _LevelInfo(
          title: '初級',
          subtitle: 'TOPIK 1-2',
          icon: Iconsax.book_1,
          color: startColor,
        );
      case ShadowingLevel.intermediate:
        return _LevelInfo(
          title: '中級',
          subtitle: 'TOPIK 3-4',
          icon: Iconsax.teacher,
          color: midColor,
        );
      case ShadowingLevel.advanced:
        return _LevelInfo(
          title: '高級',
          subtitle: 'TOPIK 5-6',
          icon: Iconsax.crown,
          color: endColor,
        );
    }
  }
}

class _LevelInfo {
  const _LevelInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

/// オリジナル文章カード
class _OriginalContentCard extends ConsumerWidget {
  const _OriginalContentCard({this.stats});

  final OriginalContentStats? stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = Colors.amber.shade700;

    final totalCount = stats?.totalCount ?? 0;
    final masteredCount = stats?.masteredCount ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: cardColor.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToList(context, ref),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                cardColor.withValues(alpha: isDark ? 0.18 : 0.1),
                cardColor.withValues(alpha: isDark ? 0.08 : 0.04),
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
                  // アイコン
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: isDark ? 0.25 : 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.document_text,
                        color: cardColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // タイトルとサブタイトル
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'オリジナル文章',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Iconsax.crown,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          '自分だけの練習コンテンツ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 矢印
                  Icon(
                    Iconsax.arrow_right_3,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
              if (totalCount > 0) ...[
                const SizedBox(height: AppSpacing.md),
                // 進捗バー
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? masteredCount / totalCount : 0,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: isDark ? 0.5 : 0.7),
                    valueColor: AlwaysStoppedAnimation(cardColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // 統計
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$masteredCount/$totalCount マスター',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '全${totalCount}コンテンツ',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToList(BuildContext context, WidgetRef ref) {
    // オリジナル文章は有料会員限定
    final authState = ref.read(authStateProvider);
    final isPremium = authState.user?.isPremiumUser ?? false;

    if (!isPremium) {
      _showPremiumOnlyDialog(context);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OriginalContentListScreen(),
      ),
    );
  }

  void _showPremiumOnlyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.crown, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('有料会員限定'),
          ],
        ),
        content: const Text(
          'この機能は有料会員限定です。\n\nアップグレードすると、中級・高級・オリジナル文章の音読・シャドーイングをご利用いただけます。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const PremiumFeatureGateScreen(focusFeature: 'ネイティブ発音'),
                ),
              );
            },
            child: const Text('プロプランを見る'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
