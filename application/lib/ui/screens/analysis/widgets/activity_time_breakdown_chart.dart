import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

/// アクティビティ別学習時間の積み上げ棒グラフと詳細テーブル
class ActivityTimeBreakdownChart extends StatelessWidget {
  const ActivityTimeBreakdownChart({
    super.key,
    required this.breakdown,
    required this.dailyBreakdown,
    required this.period,
  });

  final ActivityBreakdown breakdown;
  final List<DailyActivityBreakdown> dailyBreakdown;
  final String period; // 'week', 'month', 'half_year'

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
            period: period,
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

/// 集約されたアクティビティデータ
class _AggregatedData {
  const _AggregatedData({
    required this.label,
    required this.lessonTimeMs,
    required this.rankingGameTimeMs,
    required this.pronunciationGameTimeMs,
    required this.quickTranslationTimeMs,
    required this.writingTimeMs,
    required this.hanjaQuizTimeMs,
  });

  final String label;
  final int lessonTimeMs;
  final int rankingGameTimeMs;
  final int pronunciationGameTimeMs;
  final int quickTranslationTimeMs;
  final int writingTimeMs;
  final int hanjaQuizTimeMs;

  int get totalTimeMs =>
      lessonTimeMs +
      rankingGameTimeMs +
      pronunciationGameTimeMs +
      quickTranslationTimeMs +
      writingTimeMs +
      hanjaQuizTimeMs;

  int getTimeForActivity(String activityKey) {
    switch (activityKey) {
      case 'lesson':
        return lessonTimeMs;
      case 'rankingGame':
        return rankingGameTimeMs;
      case 'pronunciationGame':
        return pronunciationGameTimeMs;
      case 'quickTranslation':
        return quickTranslationTimeMs;
      case 'writing':
        return writingTimeMs;
      case 'hanjaQuiz':
        return hanjaQuizTimeMs;
      default:
        return 0;
    }
  }
}

/// 積み上げ棒グラフ
class _StackedBarChart extends StatelessWidget {
  const _StackedBarChart({
    required this.dailyBreakdown,
    required this.activeEntries,
    required this.period,
  });

  final List<DailyActivityBreakdown> dailyBreakdown;
  final List<MapEntry<String, ActivityTimeEntry>> activeEntries;
  final String period;

  /// 期間に応じてデータを集約（データがない期間も含む）
  List<_AggregatedData> _aggregateData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // dailyBreakdownをMapに変換して高速検索
    final dataMap = <String, DailyActivityBreakdown>{};
    for (final d in dailyBreakdown) {
      dataMap[d.date] = d;
    }

    switch (period) {
      case 'week':
        // 1週間：日単位で7日分表示
        return _generateWeekData(today, dataMap);

      case 'month':
        // 1ヶ月：週単位で集約
        return _aggregateByWeek(today, dataMap);

      case 'half_year':
        // 半年：月単位で集約
        return _aggregateByMonth(today, dataMap);

      default:
        return _generateWeekData(today, dataMap);
    }
  }

  /// 1週間分の日別データを生成
  List<_AggregatedData> _generateWeekData(
    DateTime today,
    Map<String, DailyActivityBreakdown> dataMap,
  ) {
    final result = <_AggregatedData>[];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final data = dataMap[dateKey];

      result.add(_AggregatedData(
        label: '${date.month}/${date.day}',
        lessonTimeMs: data?.lessonTimeMs ?? 0,
        rankingGameTimeMs: data?.rankingGameTimeMs ?? 0,
        pronunciationGameTimeMs: data?.pronunciationGameTimeMs ?? 0,
        quickTranslationTimeMs: data?.quickTranslationTimeMs ?? 0,
        writingTimeMs: data?.writingTimeMs ?? 0,
        hanjaQuizTimeMs: data?.hanjaQuizTimeMs ?? 0,
      ));
    }

    return result;
  }

  /// 週単位で集約（1ヶ月用）- 4週分を表示
  List<_AggregatedData> _aggregateByWeek(
    DateTime today,
    Map<String, DailyActivityBreakdown> dataMap,
  ) {
    final result = <_AggregatedData>[];

    // 4週分を生成（今週を含む）
    for (int weekOffset = 3; weekOffset >= 0; weekOffset--) {
      // 週の開始日（月曜日）を計算
      final weekStart = _getWeekStart(today).subtract(Duration(days: weekOffset * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      // 週のデータを集約
      int lessonTimeMs = 0;
      int rankingGameTimeMs = 0;
      int pronunciationGameTimeMs = 0;
      int quickTranslationTimeMs = 0;
      int writingTimeMs = 0;
      int hanjaQuizTimeMs = 0;

      for (int d = 0; d < 7; d++) {
        final date = weekStart.add(Duration(days: d));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final data = dataMap[dateKey];

        if (data != null) {
          lessonTimeMs += data.lessonTimeMs;
          rankingGameTimeMs += data.rankingGameTimeMs;
          pronunciationGameTimeMs += data.pronunciationGameTimeMs;
          quickTranslationTimeMs += data.quickTranslationTimeMs;
          writingTimeMs += data.writingTimeMs;
          hanjaQuizTimeMs += data.hanjaQuizTimeMs;
        }
      }

      result.add(_AggregatedData(
        label: '${weekStart.month}/${weekStart.day}〜${weekEnd.month}/${weekEnd.day}',
        lessonTimeMs: lessonTimeMs,
        rankingGameTimeMs: rankingGameTimeMs,
        pronunciationGameTimeMs: pronunciationGameTimeMs,
        quickTranslationTimeMs: quickTranslationTimeMs,
        writingTimeMs: writingTimeMs,
        hanjaQuizTimeMs: hanjaQuizTimeMs,
      ));
    }

    return result;
  }

  /// 週の開始日（月曜日）を取得
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // 1 = 月曜日, 7 = 日曜日
    return date.subtract(Duration(days: weekday - 1));
  }

  /// 月単位で集約（半年用）- 6ヶ月分を表示
  List<_AggregatedData> _aggregateByMonth(
    DateTime today,
    Map<String, DailyActivityBreakdown> dataMap,
  ) {
    final result = <_AggregatedData>[];

    // 6ヶ月分を生成（今月を含む）
    for (int monthOffset = 5; monthOffset >= 0; monthOffset--) {
      final targetDate = DateTime(today.year, today.month - monthOffset, 1);
      final year = targetDate.year;
      final month = targetDate.month;

      // 月の日数を取得
      final daysInMonth = DateTime(year, month + 1, 0).day;

      // 月のデータを集約
      int lessonTimeMs = 0;
      int rankingGameTimeMs = 0;
      int pronunciationGameTimeMs = 0;
      int quickTranslationTimeMs = 0;
      int writingTimeMs = 0;
      int hanjaQuizTimeMs = 0;

      for (int d = 1; d <= daysInMonth; d++) {
        final dateKey =
            '$year-${month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
        final data = dataMap[dateKey];

        if (data != null) {
          lessonTimeMs += data.lessonTimeMs;
          rankingGameTimeMs += data.rankingGameTimeMs;
          pronunciationGameTimeMs += data.pronunciationGameTimeMs;
          quickTranslationTimeMs += data.quickTranslationTimeMs;
          writingTimeMs += data.writingTimeMs;
          hanjaQuizTimeMs += data.hanjaQuizTimeMs;
        }
      }

      result.add(_AggregatedData(
        label: '$year/${month}月',
        lessonTimeMs: lessonTimeMs,
        rankingGameTimeMs: rankingGameTimeMs,
        pronunciationGameTimeMs: pronunciationGameTimeMs,
        quickTranslationTimeMs: quickTranslationTimeMs,
        writingTimeMs: writingTimeMs,
        hanjaQuizTimeMs: hanjaQuizTimeMs,
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final aggregatedData = _aggregateData();

    if (aggregatedData.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(aggregatedData),
          barTouchData: _buildTouchData(context, aggregatedData),
          titlesData: _buildTitlesData(context, aggregatedData),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(aggregatedData),
        ),
      ),
    );
  }

  double _calculateMaxY(List<_AggregatedData> data) {
    if (data.isEmpty) return 60;
    final maxMs = data.map((e) => e.totalTimeMs).reduce((a, b) => a > b ? a : b);
    final maxMinutes = maxMs / 60000;
    return (maxMinutes * 1.2).ceilToDouble().clamp(10, double.infinity);
  }

  BarTouchData _buildTouchData(
      BuildContext context, List<_AggregatedData> data) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => colors.surfaceContainerHighest,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          if (groupIndex >= data.length) return null;
          final item = data[groupIndex];
          final totalMinutes = item.totalTimeMs / 60000;

          return BarTooltipItem(
            '${item.label}\n',
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

  FlTitlesData _buildTitlesData(
      BuildContext context, List<_AggregatedData> data) {
    final theme = Theme.of(context);

    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= data.length) {
              return const SizedBox.shrink();
            }

            // 1週間の場合は全て表示、それ以外は全て表示
            final label = data[index].label;

            // 半年の場合、「年/月月」形式を「月月」に短縮
            String displayLabel = label;
            if (period == 'half_year') {
              // "2025/1月" -> "1月"
              final parts = label.split('/');
              if (parts.length == 2) {
                displayLabel = parts[1];
              }
            }

            return SideTitleWidget(
              meta: meta,
              angle: period == 'month' ? -0.5 : 0,
              child: Text(
                displayLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: period == 'month' ? 10 : null,
                ),
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

  List<BarChartGroupData> _buildBarGroups(List<_AggregatedData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      // 積み上げ棒のロッドデータを構築
      final rodStackItems = <BarChartRodStackItem>[];
      double currentY = 0;

      // アクティブなアクティビティの順番で積み上げ
      for (final activity in activeEntries) {
        final timeMs = item.getTimeForActivity(activity.key);
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

      // 期間に応じてバーの幅を調整
      final barWidth = switch (period) {
        'week' => 24.0,
        'month' => 20.0,
        'half_year' => 28.0,
        _ => 16.0,
      };

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: currentY,
            rodStackItems: rodStackItems,
            width: barWidth,
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
