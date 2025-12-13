import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

/// アクティビティ別学習時間の積み上げ棒グラフと詳細テーブル
class ActivityTimeBreakdownChart extends StatelessWidget {
  const ActivityTimeBreakdownChart({
    super.key,
    required this.breakdown,
    required this.dailyBreakdown,
  });

  final ActivityBreakdown breakdown;
  final List<DailyActivityBreakdown> dailyBreakdown;

  /// アクティビティ種別ごとの色マップ
  static const Map<String, Color> activityColors = {
    'lesson': Color(0xFF4CAF50),
    'rankingGame': Color(0xFF2196F3),
    'pronunciationGame': Color(0xFF9C27B0),
    'quickTranslation': Color(0xFFFF9800),
    'writing': Color(0xFFE91E63),
    'hanjaQuiz': Color(0xFF00BCD4),
  };

  /// アクティビティ種別の日本語ラベル
  static const Map<String, String> activityLabels = {
    'lesson': 'レッスン',
    'rankingGame': 'ランキングゲーム',
    'pronunciationGame': '発音ゲーム',
    'quickTranslation': 'クイック翻訳',
    'writing': '書き取り',
    'hanjaQuiz': '漢字クイズ',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final activeEntries = breakdown.activeEntries;

    if (activeEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '学習記録がありません',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 凡例
        _LegendSection(activeEntries: activeEntries),
        const SizedBox(height: 16),
        // 積み上げ棒グラフ
        if (dailyBreakdown.isNotEmpty) ...[
          _StackedBarChart(
            dailyBreakdown: dailyBreakdown,
            activeEntries: activeEntries,
          ),
          const SizedBox(height: 24),
        ],
        // 詳細テーブル
        _ActivityDetailTable(
          breakdown: breakdown,
          activeEntries: activeEntries,
        ),
      ],
    );
  }
}

/// 凡例セクション
class _LegendSection extends StatelessWidget {
  const _LegendSection({required this.activeEntries});

  final List<MapEntry<String, ActivityTimeEntry>> activeEntries;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: activeEntries.map((entry) {
        return _LegendItem(
          color: ActivityTimeBreakdownChart.activityColors[entry.key] ??
              Colors.grey,
          label: ActivityTimeBreakdownChart.activityLabels[entry.key] ??
              entry.key,
        );
      }).toList(),
    );
  }
}

/// 凡例アイテム
class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// 積み上げ棒グラフ
class _StackedBarChart extends StatelessWidget {
  const _StackedBarChart({
    required this.dailyBreakdown,
    required this.activeEntries,
  });

  final List<DailyActivityBreakdown> dailyBreakdown;
  final List<MapEntry<String, ActivityTimeEntry>> activeEntries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(),
          barTouchData: _buildTouchData(context),
          titlesData: _buildTitlesData(context),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  double _calculateMaxY() {
    if (dailyBreakdown.isEmpty) return 60;
    final maxMs = dailyBreakdown
        .map((e) => e.totalTimeMs)
        .reduce((a, b) => a > b ? a : b);
    final maxMinutes = maxMs / 60000;
    return (maxMinutes * 1.2).ceilToDouble().clamp(10, double.infinity);
  }

  BarTouchData _buildTouchData(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => colors.surfaceContainerHighest,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final data = dailyBreakdown[groupIndex];
          final date = DateTime.parse(data.date);
          final totalMinutes = data.totalTimeMs / 60000;

          return BarTooltipItem(
            '${date.month}/${date.day}\n',
            theme.textTheme.labelSmall!,
            children: [
              TextSpan(
                text: '${totalMinutes.toStringAsFixed(0)}分',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    final theme = Theme.of(context);

    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= dailyBreakdown.length) {
              return const SizedBox.shrink();
            }
            // 7日以上ある場合は3点ごとに表示
            if (dailyBreakdown.length > 7 && index % 3 != 0) {
              return const SizedBox.shrink();
            }
            final date = DateTime.parse(dailyBreakdown[index].date);
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
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return dailyBreakdown.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      // 積み上げ棒のロッドデータを構築
      final rodStackItems = <BarChartRodStackItem>[];
      double currentY = 0;

      // アクティブなアクティビティの順番で積み上げ
      for (final activity in activeEntries) {
        final timeMs = data.getTimeForActivity(activity.key);
        if (timeMs > 0) {
          final minutes = timeMs / 60000;
          rodStackItems.add(BarChartRodStackItem(
            currentY,
            currentY + minutes,
            ActivityTimeBreakdownChart.activityColors[activity.key] ??
                Colors.grey,
          ));
          currentY += minutes;
        }
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: currentY,
            rodStackItems: rodStackItems,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }
}

/// 詳細テーブル
class _ActivityDetailTable extends StatelessWidget {
  const _ActivityDetailTable({
    required this.breakdown,
    required this.activeEntries,
  });

  final ActivityBreakdown breakdown;
  final List<MapEntry<String, ActivityTimeEntry>> activeEntries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final totalTimeMs = breakdown.totalTimeMs;
    final totalSessions = activeEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.value.sessionCount,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ヘッダー
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'アクティビティ',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '時間',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '回数',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // データ行
          ...activeEntries.map((entry) {
            return _TableRow(
              activityKey: entry.key,
              data: entry.value,
              totalTimeMs: totalTimeMs,
            );
          }),
          // 合計行
          _TotalRow(
            totalTimeMs: totalTimeMs,
            totalSessions: totalSessions,
          ),
        ],
      ),
    );
  }
}

/// テーブル行
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.activityKey,
    required this.data,
    required this.totalTimeMs,
  });

  final String activityKey;
  final ActivityTimeEntry data;
  final int totalTimeMs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final percentage = totalTimeMs > 0
        ? (data.timeSpentMs / totalTimeMs * 100).toStringAsFixed(1)
        : '0';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          // アクティビティ名 + 色インジケータ
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: ActivityTimeBreakdownChart.activityColors[activityKey],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ActivityTimeBreakdownChart.activityLabels[activityKey] ??
                        activityKey,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          // 時間（割合付き）
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDuration(data.timeSpentMs),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '($percentage%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // 回数
          Expanded(
            flex: 1,
            child: Text(
              '${data.sessionCount}回',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours時間${minutes}分';
    }
    return '$minutes分';
  }
}

/// 合計行
class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.totalTimeMs,
    required this.totalSessions,
  });

  final int totalTimeMs;
  final int totalSessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '合計',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDuration(totalTimeMs),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$totalSessions回',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int ms) {
    final duration = Duration(milliseconds: ms);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours時間${minutes}分';
    }
    return '$minutes分';
  }
}
