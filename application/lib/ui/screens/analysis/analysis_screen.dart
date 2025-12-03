import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import 'package:chaletta/features/analysis/domain/providers/analysis_providers.dart';
import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/widgets/premium_feature_gate.dart';

import 'widgets/growth_trend_chart.dart';
import 'widgets/learning_habit_chart.dart';
import 'widgets/practice_time_chart.dart';
import 'widgets/vocabulary_growth_chart.dart';
import 'widgets/vocabulary_status_chart.dart';
import 'widgets/weak_keys_heatmap.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  String _period = 'month'; // 'week', 'month', 'half_year'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isPremiumUser = user?.isPremiumUser ?? false;

    if (!isPremiumUser) {
      return const PremiumFeatureGateScreen(focusFeature: '詳細分析');
    }

    final dashboardAsync = ref.watch(analysisDashboardProvider(period: _period));

    return AppPageScaffold(
      title: '詳細分析',
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'week', label: Text('1週間')),
                  ButtonSegment(value: 'month', label: Text('1ヶ月')),
                  ButtonSegment(value: 'half_year', label: Text('半年')),
                ],
                selected: {_period},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _period = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            dashboardAsync.when(
              data: (dashboard) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weak Keys Section
                  _SectionHeader(
                    title: '苦手なキー',
                    subtitle: 'ミスが多いキーTop 5 (ヒートマップ)',
                    icon: Icons.warning_amber_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  WeakKeysHeatmap(weakKeys: dashboard.weakKeys),
                  const SizedBox(height: AppSpacing.xxl),

                  // Growth Trends Section
                  _SectionHeader(
                    title: '成長推移',
                    subtitle: 'WPMと正確率の変化',
                    icon: Icons.trending_up_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GrowthTrendChart(trends: dashboard.trends),
                  const SizedBox(height: AppSpacing.xxl),

                  // Learning Habits Section
                  _SectionHeader(
                    title: '学習習慣',
                    subtitle: '時間帯・曜日別の学習傾向',
                    icon: Icons.schedule_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LearningHabitChart(habits: dashboard.habits),
                  const SizedBox(height: AppSpacing.xxl),

                  // Practice Time Section
                  _SectionHeader(
                    title: '練習時間統計',
                    subtitle: '累計・平均練習時間と日別推移',
                    icon: Icons.timer_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PracticeTimeChart(stats: dashboard.practiceTime),
                  const SizedBox(height: AppSpacing.xxl),

                  // Vocabulary Status Section
                  _SectionHeader(
                    title: '語彙習得状況',
                    subtitle: '単語帳の習得状況',
                    icon: Icons.library_books_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VocabularyStatusChart(status: dashboard.vocabularyStatus),
                  const SizedBox(height: AppSpacing.xxl),

                  // Vocabulary Growth Section
                  _SectionHeader(
                    title: '語彙成長推移',
                    subtitle: '月別の語彙登録・習得数',
                    icon: Icons.trending_up_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VocabularyGrowthChart(growth: dashboard.vocabularyGrowth),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('エラーが発生しました: $error'),
                      const SizedBox(height: 16),
                      FButton(
                        onPress: () => ref.refresh(analysisDashboardProvider(period: _period)),
                        child: const Text('再読み込み'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
