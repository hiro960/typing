part of 'home_screen.dart';

/// 学習コンテンツのタブインデックス
enum _LearningTab {
  typing,
  games,
  writing;

  String get label {
    switch (this) {
      case _LearningTab.typing:
        return 'タイピング';
      case _LearningTab.games:
        return 'ゲーム';
      case _LearningTab.writing:
        return '書き取り';
    }
  }

  IconData get icon {
    switch (this) {
      case _LearningTab.typing:
        return Icons.keyboard;
      case _LearningTab.games:
        return Icons.sports_esports;
      case _LearningTab.writing:
        return Icons.edit;
    }
  }
}

/// 学習タブのセレクター
class _LearningTabSelector extends StatelessWidget {
  const _LearningTabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final _LearningTab selectedTab;
  final ValueChanged<_LearningTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _LearningTab.values.map((tab) {
          final isSelected = tab == selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 16,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// タイピングタブのコンテンツ
class _TypingTabContent extends StatelessWidget {
  const _TypingTabContent({
    required this.catalog,
    required this.progress,
    required this.typingAccordionController,
    required this.statsAccordionController,
    required this.onLessonTap,
    required this.integratedStatsAsync,
  });

  final Map<LessonLevel, List<lesson_index.LessonMeta>> catalog;
  final Map<String, LessonProgress> progress;
  final FAccordionController typingAccordionController;
  final FAccordionController statsAccordionController;
  final void Function(lesson_index.LessonMeta lesson, bool isLocked) onLessonTap;
  final AsyncValue<IntegratedStats?> integratedStatsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _KanadaRaLinkCard(),
        const SizedBox(height: AppSpacing.md),
        _LevelAccordions(
          controller: typingAccordionController,
          catalog: catalog,
          progress: progress,
          onLessonTap: onLessonTap,
        ),
        _StatsAccordion(
          controller: statsAccordionController,
          integratedStatsAsync: integratedStatsAsync,
        ),
      ],
    );
  }
}

/// カナダラ表へのリンクカード
class _KanadaRaLinkCard extends StatelessWidget {
  const _KanadaRaLinkCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _navigateToKanadaRa(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBright.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryBright.withValues(alpha: 0.15),
                child: const Text(
                  'ㄱㄴ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBright,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'カナダラ表',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '韓国語の子音・母音を一覧で確認',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToKanadaRa(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const KanadaRaScreen(),
      ),
    );
  }
}

/// 統計セクションの折りたたみアコーディオン
class _StatsAccordion extends StatelessWidget {
  const _StatsAccordion({
    required this.controller,
    required this.integratedStatsAsync,
  });

  final FAccordionController controller;
  final AsyncValue<IntegratedStats?> integratedStatsAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = integratedStatsAsync.value;
    final totalActivities = stats != null
        ? stats.breakdown.lesson.count + stats.breakdown.rankingGame.count
        : 0;

    return FAccordion(
      controller: controller,
      children: [
        FAccordionItem(
          initiallyExpanded: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('学習統計'),
                    Text(
                      '今週 $totalActivities回練習',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              _ProgressHero(integratedStatsAsync: integratedStatsAsync),
              const SizedBox(height: AppSpacing.lg),
              _StatHighlights(integratedStatsAsync: integratedStatsAsync),
            ],
          ),
        ),
      ],
    );
  }
}

/// ゲームタブのコンテンツ
class _GamesTabContent extends StatelessWidget {
  const _GamesTabContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RankingGameSection(),
        SizedBox(height: AppSpacing.xl),
        PronunciationGameSection(),
      ],
    );
  }
}

/// 書き取りタブのコンテンツ
class _WritingTabContent extends StatelessWidget {
  const _WritingTabContent({
    required this.beginnerWritingAccordionController,
    required this.travelWritingAccordionController,
    required this.hobbyWritingAccordionController,
    required this.writingAccordionController,
  });

  final FAccordionController beginnerWritingAccordionController;
  final FAccordionController travelWritingAccordionController;
  final FAccordionController hobbyWritingAccordionController;
  final FAccordionController writingAccordionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WritingPatternAccordions(
          controller: beginnerWritingAccordionController,
          title: '単語',
          subtitle: 'カテゴリ別の基本単語をタイピング練習',
          lane: WritingLane.beginner,
        ),
        _WritingPatternAccordions(
          controller: travelWritingAccordionController,
          title: '旅行',
          subtitle: '韓国旅行で使える実践フレーズ',
          lane: WritingLane.travel,
        ),
        _WritingPatternAccordions(
          controller: hobbyWritingAccordionController,
          title: '趣味対策',
          subtitle: 'SNSや韓ドラ、推しなど気軽に書ける題材',
          lane: WritingLane.hobby,
        ),
        _WritingPatternAccordions(
          controller: writingAccordionController,
          title: 'TOPIK対策',
          subtitle: 'タイピングで覚える論述パターン',
          lane: WritingLane.topik,
        ),
      ],
    );
  }
}
