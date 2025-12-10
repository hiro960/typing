part of 'home_screen.dart';

/// 週間学習進捗のサマリーカード
/// ビジュアル重視のモダンなデザイン
class _WeeklyProgressCard extends ConsumerWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final integratedStatsAsync = ref.watch(integratedStatsProvider);

    return integratedStatsAsync.when(
      data: (stats) => _buildContent(context, stats, isDark),
      loading: () => _buildLoadingState(context, isDark),
      error: (_, __) => _buildContent(context, null, isDark),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface.withValues(alpha: 0.7)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.lightBorder,
        ),
      ),
      child: const ShimmerLoading(
        child: SizedBox(height: 100),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, IntegratedStats? stats, bool isDark) {
    final theme = Theme.of(context);

    // 統計データを取得
    final streakDays = stats?.streakDays ?? 0;
    final totalActivities = stats != null
        ? stats.breakdown.lesson.count + stats.breakdown.rankingGame.count
        : 0;
    final accuracy = stats?.avgAccuracy ?? 0.0;

    // dailyTrendから今週の学習日を判定
    final weekDays = _generateWeekDotsFromTrend(stats?.dailyTrend ?? []);
    final activeDaysCount = weekDays.where((d) => d).length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1a1f35).withValues(alpha: 0.9),
                  const Color(0xFF151b2c).withValues(alpha: 0.9),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8FAFF),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.lightBorder.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー行
          Row(
            children: [
              // アイコン
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2DBFBF), Color(0xFF50D0D0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.diagram,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今週の学習',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '$activeDaysCount日 / 7日',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // ストリークバッジ
              if (streakDays > 0)
                _StreakBadge(days: streakDays),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 週間ドット表示（改良版）
          _WeekProgressBar(weekDays: weekDays),
          const SizedBox(height: AppSpacing.lg),

          // 統計サマリー（改良版）
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ModernStatItem(
                    label: '練習回数',
                    value: '$totalActivities',
                    unit: '回',
                    icon: Iconsax.weight,
                    color: const Color(0xFF4facfe),
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: _ModernStatItem(
                    label: '正解率',
                    value: '${(accuracy * 100).toInt()}',
                    unit: '%',
                    icon: Iconsax.tick_circle,
                    color: const Color(0xFF11998e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// dailyTrendデータから今週の学習日を判定してドットリストを生成
  List<bool> _generateWeekDotsFromTrend(List<DailyActivityTrend> dailyTrend) {
    final dots = List<bool>.filled(7, false);
    final now = DateTime.now();

    // 今週の月曜日を取得
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final mondayDate = DateTime(monday.year, monday.month, monday.day);

    // dailyTrendの日付セットを作成（学習があった日）
    final activeDates = <String>{};
    for (final trend in dailyTrend) {
      // lessonTimeまたはrankingGameTimeが0より大きい場合、その日は学習した
      if (trend.lessonTime > 0 || trend.rankingGameTime > 0) {
        activeDates.add(trend.date);
      }
    }

    // 今週の各曜日をチェック
    for (int i = 0; i < 7; i++) {
      final day = mondayDate.add(Duration(days: i));
      final dateStr = _formatDate(day);
      dots[i] = activeDates.contains(dateStr);
    }

    return dots;
  }

  /// DateTimeを"yyyy-MM-dd"形式の文字列に変換
  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

/// ストリークバッジ
class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.2),
            Colors.deepOrange.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🔥',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$days日連続',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 週間進捗バー
class _WeekProgressBar extends StatelessWidget {
  const _WeekProgressBar({required this.weekDays});

  final List<bool> weekDays;

  static const _dayLabels = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now().weekday - 1; // 0-indexed

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isActive = weekDays[index];
        final isToday = index == today;

        return _WeekDayIndicator(
          label: _dayLabels[index],
          isActive: isActive,
          isToday: isToday,
          index: index,
        );
      }),
    );
  }
}

/// 曜日インジケーター
class _WeekDayIndicator extends StatelessWidget {
  const _WeekDayIndicator({
    required this.label,
    required this.isActive,
    required this.isToday,
    required this.index,
  });

  final String label;
  final bool isActive;
  final bool isToday;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 各曜日で微妙に違うグラデーションカラー
    final gradientColors = _getGradientForDay(index);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isToday
                ? AppColors.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isActive
                ? LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive
                ? null
                : isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
            border: isToday && !isActive
                ? Border.all(
                    color: AppColors.primary,
                    width: 2,
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: gradientColors.first.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive
                ? const Icon(
                    Iconsax.tick_square,
                    size: 18,
                    color: Colors.white,
                  )
                : isToday
                    ? Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientForDay(int dayIndex) {
    const gradients = [
      [Color(0xFF2DBFBF), Color(0xFF5DD3D3)], // 月 - ティール
      [Color(0xFF36B7C7), Color(0xFF66CCD8)], // 火 - ミントティール
      [Color(0xFF3CC9C9), Color(0xFF6CDCDC)], // 水 - スカイティール
      [Color(0xFF45CBCB), Color(0xFF75DEDE)], // 木 - ライトティール
      [Color(0xFF4FC3C3), Color(0xFF7FD8D8)], // 金 - ソフトティール
      [Color(0xFF38BDBD), Color(0xFF68D2D2)], // 土 - シーグリーン
      [Color(0xFF2BC0C0), Color(0xFF5BD5D5)], // 日 - アクアティール
    ];
    return gradients[dayIndex];
  }
}

/// モダンな統計アイテム
class _ModernStatItem extends StatelessWidget {
  const _ModernStatItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
