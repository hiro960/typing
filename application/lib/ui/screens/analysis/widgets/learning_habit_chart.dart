import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class LearningHabitChart extends StatefulWidget {
  const LearningHabitChart({super.key, required this.habits});

  final LearningHabits habits;

  @override
  State<LearningHabitChart> createState() => _LearningHabitChartState();
}

class _LearningHabitChartState extends State<LearningHabitChart> {
  bool _showHourly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final data = _showHourly ? widget.habits.byHour : widget.habits.byDayOfWeek;
    final maxCount = data.fold<int>(0, (max, e) => e > max ? e : max);
    final maxY = (maxCount * 1.2).ceil().toDouble(); // Add some headroom

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('時間帯')),
                ButtonSegment(value: false, label: Text('曜日')),
              ],
              selected: {_showHourly},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _showHourly = newSelection.first;
                });
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (_showHourly) {
                        if (index % 4 == 0) { // Show every 4 hours
                          return SideTitleWidget(
                            meta: meta,
                            child: Text('$index', style: theme.textTheme.labelSmall),
                          );
                        }
                      } else {
                        const days = ['日', '月', '火', '水', '木', '金', '土'];
                        if (index >= 0 && index < days.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(days[index], style: theme.textTheme.labelSmall),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.toDouble(),
                      color: colors.secondary,
                      width: _showHourly ? 8 : 16,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                );
              }).toList(),
              maxY: maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => colors.surfaceContainerHighest,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final label = _showHourly 
                        ? '${group.x}時' 
                        : ['日', '月', '火', '水', '木', '金', '土'][group.x];
                    return BarTooltipItem(
                      '$label\n',
                      theme.textTheme.labelSmall!,
                      children: [
                        TextSpan(
                          text: '${rod.toY.toInt()}回',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
