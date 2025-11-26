import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class PracticeTimeChart extends StatelessWidget {
  const PracticeTimeChart({super.key, required this.stats});

  final PracticeTimeStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: '総練習時間',
                value: _formatDuration(stats.totalTimeMs),
                icon: Icons.timer_outlined,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'セッション数',
                value: '${stats.sessionCount}回',
                icon: Icons.repeat_rounded,
                color: colors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          label: '平均セッション時間',
          value: _formatDuration(stats.averageTimeMs),
          icon: Icons.timer,
          color: colors.tertiary,
        ),
        const SizedBox(height: 20),
        // Daily Chart
        if (stats.dailyPracticeTime.isNotEmpty) ...[
          Text(
            '日別練習時間',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMaxY(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => colors.surfaceContainerHighest,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = stats.dailyPracticeTime[groupIndex];
                      final date = DateTime.parse(data.date);
                      return BarTooltipItem(
                        '${date.month}/${date.day}\n',
                        theme.textTheme.labelSmall!,
                        children: [
                          TextSpan(
                            text: _formatDuration(data.timeMs),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= stats.dailyPracticeTime.length) {
                          return const SizedBox.shrink();
                        }
                        // Show date every 3 points
                        if (stats.dailyPracticeTime.length > 7 && index % 3 != 0) {
                          return const SizedBox.shrink();
                        }
                        final date = DateTime.parse(stats.dailyPracticeTime[index].date);
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${date.month}/${date.day}',
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${value.toInt()}分',
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: stats.dailyPracticeTime.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: (e.value.timeMs / 60000).clamp(0, double.infinity),
                        color: colors.primary,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ] else
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'データがありません',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }

  double _calculateMaxY() {
    if (stats.dailyPracticeTime.isEmpty) return 60;
    final maxMs = stats.dailyPracticeTime
        .map((e) => e.timeMs)
        .reduce((a, b) => a > b ? a : b);
    final maxMinutes = maxMs / 60000;
    return (maxMinutes * 1.2).ceilToDouble().clamp(10, double.infinity);
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours時間${minutes}分';
    } else if (minutes > 0) {
      return '$minutes分${seconds}秒';
    } else {
      return '$seconds秒';
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
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
