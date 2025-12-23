import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../features/analysis/domain/models/analysis_models.dart';

class DiaryCalendarChart extends StatelessWidget {
  const DiaryCalendarChart({
    super.key,
    required this.calendar,
    this.onMonthChanged,
  });

  final DiaryCalendar calendar;
  final void Function(int year, int month)? onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final year = calendar.year;
    final month = calendar.month;

    // Calculate first day of month and total days
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    // Calculate streak
    final streak = _calculateCurrentStreak();

    return Column(
      children: [
        // Stats summary
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                icon: Iconsax.edit,
                label: '今月の投稿',
                value: '${calendar.postDates.length}日',
                color: colors.primary,
              ),
              Container(
                width: 1,
                height: 40,
                color: colors.outline.withValues(alpha: 0.3),
              ),
              _StatItem(
                icon: Iconsax.flash_1,
                label: '継続日数',
                value: '$streak日',
                color: Colors.orange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                final prevMonth = month == 1 ? 12 : month - 1;
                final prevYear = month == 1 ? year - 1 : year;
                onMonthChanged?.call(prevYear, prevMonth);
              },
              icon: const Icon(Iconsax.arrow_left_2),
              tooltip: '前月',
            ),
            Text(
              '$year年$month月',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                final now = DateTime.now();
                final isCurrentMonth = year == now.year && month == now.month;
                if (isCurrentMonth) return;

                final nextMonth = month == 12 ? 1 : month + 1;
                final nextYear = month == 12 ? year + 1 : year;
                onMonthChanged?.call(nextYear, nextMonth);
              },
              icon: Icon(
                Iconsax.arrow_right_3,
                color: _isCurrentMonth() ? colors.outline.withValues(alpha: 0.3) : null,
              ),
              tooltip: '次月',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Weekday headers
        Row(
          children: ['日', '月', '火', '水', '木', '金', '土']
              .asMap()
              .map((index, day) => MapEntry(
                    index,
                    Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: index == 0
                                ? Colors.red.shade400
                                : index == 6
                                    ? Colors.blue.shade400
                                    : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: startWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < startWeekday) {
              return const SizedBox.shrink();
            }

            final day = index - startWeekday + 1;
            final date = DateTime(year, month, day);
            final hasPost = calendar.hasPostOn(date);
            final isToday = _isToday(date);
            final isFuture = date.isAfter(DateTime.now());
            final weekday = date.weekday % 7;

            return _CalendarDay(
              day: day,
              hasPost: hasPost,
              isToday: isToday,
              isFuture: isFuture,
              isSunday: weekday == 0,
              isSaturday: weekday == 6,
            );
          },
        ),

        const SizedBox(height: 16),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(
              icon: Icons.check_circle,
              color: Colors.green,
              label: '日記投稿済み',
            ),
            const SizedBox(width: 24),
            _LegendItem(
              icon: Icons.circle_outlined,
              color: colors.outline,
              label: '未投稿',
            ),
          ],
        ),
      ],
    );
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    return calendar.year == now.year && calendar.month == now.month;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int _calculateCurrentStreak() {
    if (calendar.postDates.isEmpty) return 0;

    final sortedDates = List<String>.from(calendar.postDates)..sort();
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Check if today or yesterday has a post (streak can continue from yesterday)
    int streak = 0;
    DateTime checkDate = today;

    // If today doesn't have a post, start from yesterday
    if (!sortedDates.contains(todayStr)) {
      checkDate = today.subtract(const Duration(days: 1));
    }

    while (true) {
      final checkDateStr =
          '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';

      if (sortedDates.contains(checkDateStr)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
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

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.hasPost,
    required this.isToday,
    required this.isFuture,
    required this.isSunday,
    required this.isSaturday,
  });

  final int day;
  final bool hasPost;
  final bool isToday;
  final bool isFuture;
  final bool isSunday;
  final bool isSaturday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    Color? textColor;
    if (isFuture) {
      textColor = colors.outline.withValues(alpha: 0.4);
    } else if (isSunday) {
      textColor = Colors.red.shade400;
    } else if (isSaturday) {
      textColor = Colors.blue.shade400;
    }

    return Container(
      decoration: BoxDecoration(
        color: isToday ? colors.primaryContainer.withValues(alpha: 0.5) : null,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: colors.primary, width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$day',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isToday ? FontWeight.bold : null,
              color: textColor,
            ),
          ),
          if (hasPost)
            Positioned(
              bottom: 4,
              child: Icon(
                Icons.check_circle,
                size: 14,
                color: Colors.green.shade500,
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
