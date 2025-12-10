part of 'home_screen.dart';

/// タイピング練習へのメインエントリーポイント
/// ガラスモーフィズム風のモダンなHeroカード
class _TypingPracticeHero extends ConsumerWidget {
  const _TypingPracticeHero({
    required this.onLessonTap,
  });

  final void Function(lesson_index.LessonMeta lesson, bool isLocked) onLessonTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final homeStateAsync = ref.watch(homeStateProvider);

    return homeStateAsync.when(
      data: (state) => _buildContent(context, state, isDark),
      loading: () => _buildLoadingState(context, isDark),
      error: (_, __) => _buildContent(
        context,
        HomeState(
          catalog: const {},
          statsAsync: const AsyncValue.data(LessonStatsSummary()),
          progress: const {},
          focusLesson: null,
        ),
        isDark,
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1a1f35), const Color(0xFF0d1117)]
              : [const Color(0xFFf0f4ff), const Color(0xFFe8ecf4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state, bool isDark) {
    final theme = Theme.of(context);
    final catalog = state.catalog;
    final progress = state.progress;

    // 各レベルの進捗を計算
    final beginnerLessons = catalog[LessonLevel.beginner] ?? [];
    final intermediateLessons = catalog[LessonLevel.intermediate] ?? [];
    final advancedLessons = catalog[LessonLevel.advanced] ?? [];

    final beginnerProgress = _calculateProgress(beginnerLessons, progress);
    final intermediateProgress =
        _calculateProgress(intermediateLessons, progress);
    final advancedProgress = _calculateProgress(advancedLessons, progress);

    // 全体進捗
    final totalLessons =
        beginnerLessons.length + intermediateLessons.length + advancedLessons.length;
    final totalCompleted = (beginnerProgress * beginnerLessons.length +
            intermediateProgress * intermediateLessons.length +
            advancedProgress * advancedLessons.length)
        .round();
    final overallProgress = totalLessons > 0 ? totalCompleted / totalLessons : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2E3E4C), const Color(0xFF243442)]
              : [const Color(0xFF2DBFBF), const Color(0xFF36B7C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primary : const Color(0xFF2DBFBF))
                .withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // 装飾パターン
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // コンテンツ
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ヘッダー
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.keyboard_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'タイピング練習',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '韓国語タイピングをマスターしよう',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 進捗サークル
                      _CircularProgress(
                        progress: overallProgress,
                        size: 48,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // レベル選択ボタン
                  Row(
                    children: [
                      Expanded(
                        child: _ModernLevelButton(
                          label: '初級',
                          koreanLabel: '초급',
                          progress: beginnerProgress,
                          gradientColors: const [Color(0xFF5DD3D3), Color(0xFF8DE4E4)],
                          onTap: () => _showLevelLessons(
                            context,
                            '初級',
                            beginnerLessons,
                            progress,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ModernLevelButton(
                          label: '中級',
                          koreanLabel: '중급',
                          progress: intermediateProgress,
                          gradientColors: const [Color(0xFF4FC3C3), Color(0xFF7FD9D9)],
                          onTap: beginnerProgress >= 1.0
                              ? () => _showLevelLessons(
                                    context,
                                    '中級',
                                    intermediateLessons,
                                    progress,
                                  )
                              : null,
                          isLocked: beginnerProgress < 1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ModernLevelButton(
                          label: '上級',
                          koreanLabel: '고급',
                          progress: advancedProgress,
                          gradientColors: const [Color(0xFF3BB8B8), Color(0xFF6BCDCD)],
                          onTap: intermediateProgress >= 1.0
                              ? () => _showLevelLessons(
                                    context,
                                    '上級',
                                    advancedLessons,
                                    progress,
                                  )
                              : null,
                          isLocked: intermediateProgress < 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateProgress(
    List<lesson_index.LessonMeta> lessons,
    Map<String, LessonProgress> progress,
  ) {
    if (lessons.isEmpty) return 0.0;
    int completed = 0;
    for (final lesson in lessons) {
      final p = progress[lesson.id];
      if (p != null && p.isCompleted) {
        completed++;
      }
    }
    return completed / lessons.length;
  }

  void _showLevelLessons(
    BuildContext context,
    String levelName,
    List<lesson_index.LessonMeta> lessons,
    Map<String, LessonProgress> progress,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LessonListSheet(
        levelName: levelName,
        lessons: lessons,
        progress: progress,
        onLessonTap: onLessonTap,
      ),
    );
  }
}

/// 円形進捗インジケーター
class _CircularProgress extends StatelessWidget {
  const _CircularProgress({
    required this.progress,
    required this.size,
  });

  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.2)),
          ),
          // 進捗
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.transparent,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
          // パーセント
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// モダンなレベル選択ボタン
class _ModernLevelButton extends StatelessWidget {
  const _ModernLevelButton({
    required this.label,
    required this.koreanLabel,
    required this.progress,
    required this.gradientColors,
    required this.onTap,
    this.isLocked = false,
  });

  final String label;
  final String koreanLabel;
  final double progress;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (progress * 100).toInt();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            gradient: isLocked
                ? null
                : LinearGradient(
                    colors: gradientColors
                        .map((c) => c.withValues(alpha: 0.9))
                        .toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: isLocked ? Colors.white.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLocked
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // アイコンまたはロック
              if (isLocked)
                Icon(
                  Icons.lock_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.5),
                )
              else
                Icon(
                  Icons.play_arrow_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              const SizedBox(height: 4),
              // 日本語ラベル
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.white,
                ),
              ),
              // 韓国語ラベル
              Text(
                koreanLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              // 進捗バー
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// レッスン一覧のボトムシート
class _LessonListSheet extends StatelessWidget {
  const _LessonListSheet({
    required this.levelName,
    required this.lessons,
    required this.progress,
    required this.onLessonTap,
  });

  final String levelName;
  final List<lesson_index.LessonMeta> lessons;
  final Map<String, LessonProgress> progress;
  final void Function(lesson_index.LessonMeta lesson, bool isLocked) onLessonTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ハンドル
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // ヘッダー
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getLevelGradient(levelName),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.keyboard_rounded,
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
                        '$levelName レッスン',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${lessons.length}レッスン',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          // レッスンリスト
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final lessonProgress = progress[lesson.id];
                final isCompleted = lessonProgress?.isCompleted ?? false;
                final isLocked = _isLessonLocked(index);

                return _ModernLessonListTile(
                  lesson: lesson,
                  index: index + 1,
                  isCompleted: isCompleted,
                  isLocked: isLocked,
                  onTap: () {
                    Navigator.pop(context);
                    onLessonTap(lesson, isLocked);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getLevelGradient(String levelName) {
    switch (levelName) {
      case '初級':
        return const [Color(0xFF5DD3D3), Color(0xFF8DE4E4)];
      case '中級':
        return const [Color(0xFF4FC3C3), Color(0xFF7FD9D9)];
      case '上級':
        return const [Color(0xFF3BB8B8), Color(0xFF6BCDCD)];
      default:
        return const [Color(0xFF2DBFBF), Color(0xFF5DD3D3)];
    }
  }

  bool _isLessonLocked(int index) {
    if (index == 0) return false;
    final prevLesson = lessons[index - 1];
    final prevProgress = progress[prevLesson.id];
    return !(prevProgress?.isCompleted ?? false);
  }
}

/// モダンなレッスンリストのタイル
class _ModernLessonListTile extends StatelessWidget {
  const _ModernLessonListTile({
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  final lesson_index.LessonMeta lesson;
  final int index;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1)
                  : isLocked
                      ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                      : isDark
                          ? AppColors.surfaceAlt
                          : AppColors.lightSurfaceAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.3)
                    : isLocked
                        ? theme.colorScheme.outline.withValues(alpha: 0.1)
                        : theme.colorScheme.outline.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 番号/ステータス
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isCompleted
                        ? const LinearGradient(
                            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                          )
                        : isLocked
                            ? null
                            : LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.8),
                                  AppColors.primaryBright.withValues(alpha: 0.8),
                                ],
                              ),
                    color: isLocked
                        ? theme.colorScheme.surfaceContainerHighest
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: Colors.white,
                          )
                        : isLocked
                            ? Icon(
                                Icons.lock_rounded,
                                size: 18,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              )
                            : Text(
                                '$index',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // レッスン情報
                Expanded(
                  child: Text(
                    lesson.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isLocked
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : null,
                    ),
                  ),
                ),
                // 矢印
                Icon(
                  Icons.chevron_right_rounded,
                  color: isLocked
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
