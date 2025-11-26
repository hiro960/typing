import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class VocabularyStatusChart extends StatefulWidget {
  const VocabularyStatusChart({super.key, required this.status});

  final VocabularyStatus status;

  @override
  State<VocabularyStatusChart> createState() => _VocabularyStatusChartState();
}

class _VocabularyStatusChartState extends State<VocabularyStatusChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (widget.status.total == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 48,
                color: colors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                '単語帳にまだ単語がありません',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final masteredColor = Colors.green.shade400;
    final reviewingColor = Colors.orange.shade400;
    final needsReviewColor = Colors.red.shade400;

    return Column(
      children: [
        // Total Count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_books_rounded, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                '登録語彙数: ',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '${widget.status.total}語',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Pie Chart
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                _buildSection(
                  value: widget.status.mastered.toDouble(),
                  color: masteredColor,
                  title: '習得済み',
                  index: 0,
                ),
                _buildSection(
                  value: widget.status.reviewing.toDouble(),
                  color: reviewingColor,
                  title: '学習中',
                  index: 1,
                ),
                _buildSection(
                  value: widget.status.needsReview.toDouble(),
                  color: needsReviewColor,
                  title: '要復習',
                  index: 2,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LegendItem(
              color: masteredColor,
              label: '習得済み',
              count: widget.status.mastered,
              percentage: _percentage(widget.status.mastered),
            ),
            _LegendItem(
              color: reviewingColor,
              label: '学習中',
              count: widget.status.reviewing,
              percentage: _percentage(widget.status.reviewing),
            ),
            _LegendItem(
              color: needsReviewColor,
              label: '要復習',
              count: widget.status.needsReview,
              percentage: _percentage(widget.status.needsReview),
            ),
          ],
        ),
      ],
    );
  }

  PieChartSectionData _buildSection({
    required double value,
    required Color color,
    required String title,
    required int index,
  }) {
    final isTouched = index == _touchedIndex;
    final fontSize = isTouched ? 16.0 : 12.0;
    final radius = isTouched ? 60.0 : 50.0;

    if (value == 0) {
      return PieChartSectionData(
        color: Colors.transparent,
        value: 0,
        showTitle: false,
        radius: 0,
      );
    }

    return PieChartSectionData(
      color: color,
      value: value,
      title: isTouched ? '${value.toInt()}語' : '',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  String _percentage(int count) {
    if (widget.status.total == 0) return '0%';
    return '${(count / widget.status.total * 100).toStringAsFixed(0)}%';
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percentage,
  });

  final Color color;
  final String label;
  final int count;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$count語',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          percentage,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
