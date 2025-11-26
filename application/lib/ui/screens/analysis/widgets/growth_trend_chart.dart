import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class GrowthTrendChart extends StatefulWidget {
  const GrowthTrendChart({super.key, required this.trends});

  final List<DailyTrend> trends;

  @override
  State<GrowthTrendChart> createState() => _GrowthTrendChartState();
}

class _GrowthTrendChartState extends State<GrowthTrendChart> {
  bool _showWpm = true;

  double _calculateMaxY() {
    if (widget.trends.isEmpty) return 100;
    if (!_showWpm) return 100;

    final maxWpm = widget.trends
        .map((e) => e.wpm)
        .fold<int>(0, (max, e) => e > max ? e : max);
    return (maxWpm * 1.2).ceilToDouble().clamp(100, double.infinity);
  }

  double _calculateInterval() {
    if (!_showWpm) return 20;
    return _calculateMaxY() / 5;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (widget.trends.isEmpty) {
      return Center(
        child: Text(
          'データがありません',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      );
    }

    final maxY = _calculateMaxY();
    final interval = _calculateInterval();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('WPM')),
                ButtonSegment(value: false, label: Text('正確率')),
              ],
              selected: {_showWpm},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _showWpm = newSelection.first;
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
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                  strokeWidth: 1,
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
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= widget.trends.length) {
                        return const SizedBox.shrink();
                      }
                      // Show date every 3 points to avoid clutter
                      if (widget.trends.length > 7 && index % 3 != 0) {
                        return const SizedBox.shrink();
                      }
                      final date = DateTime.parse(widget.trends[index].date);
                      return SideTitleWidget(
                        meta: meta,
                        fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
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
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      if (value > maxY) return const SizedBox.shrink();
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
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.trends.asMap().entries.map((e) {
                    return FlSpot(
                      e.key.toDouble(),
                      _showWpm ? e.value.wpm.toDouble() : e.value.accuracy * 100,
                    );
                  }).toList(),
                  isCurved: true,
                  color: _showWpm ? colors.primary : colors.tertiary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: (_showWpm ? colors.primary : colors.tertiary)
                        .withValues(alpha: 0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => colors.surfaceContainerHighest,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final trend = widget.trends[spot.x.toInt()];
                      final date = DateTime.parse(trend.date);
                      return LineTooltipItem(
                        '${date.month}/${date.day}\n',
                        theme.textTheme.labelSmall!,
                        children: [
                          TextSpan(
                            text: _showWpm 
                                ? '${trend.wpm} WPM' 
                                : '${(trend.accuracy * 100).toStringAsFixed(1)}%',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: _showWpm ? colors.primary : colors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList();
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
