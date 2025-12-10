import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class VocabularyGrowthChart extends StatelessWidget {
  const VocabularyGrowthChart({super.key, required this.growth});

  final List<VocabularyGrowthPoint> growth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (growth.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Iconsax.trend_up,
                size: 48,
                color: colors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'データがありません',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final addedColor = colors.primary;
    final masteredColor = Colors.green.shade400;

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: addedColor, label: '追加'),
            const SizedBox(width: 24),
            _LegendDot(color: masteredColor, label: '習得'),
          ],
        ),
        const SizedBox(height: 16),

        // Chart
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
                    final data = growth[groupIndex];
                    final label = rodIndex == 0 ? '追加' : '習得';
                    final count = rodIndex == 0 ? data.added : data.mastered;
                    return BarTooltipItem(
                      '${_formatMonth(data.month)}\n',
                      theme.textTheme.labelSmall!,
                      children: [
                        TextSpan(
                          text: '$label: $count語',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: rodIndex == 0 ? addedColor : masteredColor,
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
                      if (index < 0 || index >= growth.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          _formatMonth(growth[index].month),
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
                          value.toInt().toString(),
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
              barGroups: growth.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.added.toDouble(),
                      color: addedColor,
                      width: 12,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: e.value.mastered.toDouble(),
                      color: masteredColor,
                      width: 12,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Summary Stats
        _SummaryRow(growth: growth),
      ],
    );
  }

  double _calculateMaxY() {
    if (growth.isEmpty) return 10;
    final maxAdded = growth.map((e) => e.added).reduce((a, b) => a > b ? a : b);
    final maxMastered = growth.map((e) => e.mastered).reduce((a, b) => a > b ? a : b);
    final max = maxAdded > maxMastered ? maxAdded : maxMastered;
    return (max * 1.2).ceilToDouble().clamp(5, double.infinity);
  }

  String _formatMonth(String month) {
    // YYYY-MM -> M月
    final parts = month.split('-');
    if (parts.length != 2) return month;
    final monthNum = int.tryParse(parts[1]) ?? 0;
    return '$monthNum月';
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.growth});

  final List<VocabularyGrowthPoint> growth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final totalAdded = growth.fold<int>(0, (sum, e) => sum + e.added);
    final totalMastered = growth.fold<int>(0, (sum, e) => sum + e.mastered);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: '期間内追加',
            value: '$totalAdded語',
            color: colors.primary,
          ),
          Container(
            width: 1,
            height: 30,
            color: colors.outlineVariant,
          ),
          _StatItem(
            label: '期間内習得',
            value: '$totalMastered語',
            color: Colors.green.shade400,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
