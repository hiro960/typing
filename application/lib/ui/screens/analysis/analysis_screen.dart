import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:chaletta/features/analysis/domain/providers/analysis_providers.dart';
import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/widgets/premium_feature_gate.dart';

import 'widgets/activity_time_breakdown_chart.dart';
import 'widgets/diary_calendar_chart.dart';
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
  String? _calendarMonth; // 'YYYY-MM' format, null = current month

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isPremiumUser = user?.isPremiumUser ?? false;

    if (!isPremiumUser) {
      return const PremiumFeatureGateScreen(focusFeature: '詳細分析');
    }

    final dashboardAsync = ref.watch(
      analysisDashboardProvider(period: _period, calendarMonth: _calendarMonth),
    );

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
                  // Activity Time Breakdown Section
                  _SectionHeader(
                    title: '学習時間内訳',
                    subtitle: 'アクティビティ別の学習時間',
                    icon: Iconsax.chart_square,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ActivityTimeBreakdownChart(
                    breakdown: dashboard.activityBreakdown,
                    dailyBreakdown: dashboard.dailyActivityBreakdown,
                    period: _period,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Learning Habits Section
                  _SectionHeader(
                    title: '学習習慣',
                    subtitle: '時間帯・曜日別の学習傾向',
                    icon: Iconsax.calendar,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LearningHabitChart(habits: dashboard.habits),
                  const SizedBox(height: AppSpacing.xxl),

                  // Weak Keys Section
                  _SectionHeader(
                    title: '苦手なキー',
                    subtitle: 'ミスが多いキーTop 5 (ヒートマップ)',
                    icon: Iconsax.warning_2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  WeakKeysHeatmap(weakKeys: dashboard.weakKeys),
                  const SizedBox(height: AppSpacing.xxl),

                  // Growth Trends Section
                  _SectionHeader(
                    title: '成長推移',
                    subtitle: 'WPMと正確率の変化',
                    icon: Iconsax.trend_up,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GrowthTrendChart(trends: dashboard.trends),
                  const SizedBox(height: AppSpacing.xxl),


                  // Vocabulary Status Section
                  _SectionHeader(
                    title: '語彙習得状況',
                    subtitle: '単語帳の習得状況',
                    icon: Iconsax.book_1,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VocabularyStatusChart(status: dashboard.vocabularyStatus),
                  const SizedBox(height: AppSpacing.xxl),

                  // Vocabulary Growth Section
                  _SectionHeader(
                    title: '語彙成長推移',
                    subtitle: '月別の語彙登録・習得数',
                    icon: Iconsax.trend_up,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VocabularyGrowthChart(growth: dashboard.vocabularyGrowth),
                  const SizedBox(height: AppSpacing.xxl),

                  // Diary Calendar Section
                  _SectionHeader(
                    title: '日記カレンダー',
                    subtitle: '日記の継続状況',
                    icon: Iconsax.calendar_1,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DiaryCalendarChart(
                    calendar: dashboard.diaryCalendar,
                    onMonthChanged: (year, month) {
                      setState(() {
                        _calendarMonth =
                            '$year-${month.toString().padLeft(2, '0')}';
                      });
                    },
                  ),
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
                      const Icon(Iconsax.warning_2, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('エラーが発生しました: $error'),
                      const SizedBox(height: 16),
                      FButton(
                        onPress: () => ref.refresh(
                          analysisDashboardProvider(
                            period: _period,
                            calendarMonth: _calendarMonth,
                          ),
                        ),
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
