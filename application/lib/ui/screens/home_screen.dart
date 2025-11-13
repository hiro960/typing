import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/domain/providers/auth_providers.dart';
import '../../mock/mock_data.dart';
import '../app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.onStartLesson,
    required this.onOpenSettings,
  });

  final void Function(LessonInfo lesson) onStartLesson;
  final VoidCallback onOpenSettings;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _accordionController = FAccordionController(max: 1);

  final Map<String, List<LessonOutline>> _catalog = {
    '初級': beginnerLessonOutlines,
    '中級': intermediateLessonOutlines,
    '上級': advancedLessonOutlines,
  };

  late final Map<String, LessonOutline> _selectedLessons = {
    for (final entry in _catalog.entries) entry.key: entry.value.first,
  };

  @override
  void dispose() {
    _accordionController.dispose();
    super.dispose();
  }

  void _handleLessonSelection(String level, LessonOutline outline) {
    setState(() {
      _selectedLessons[level] = outline;
    });
  }

  void _startOutline(LessonOutline outline) {
    final lesson = LessonInfo(
      id: outline.id,
      title: outline.title,
      subtitle: outline.summary,
      level: outline.level,
      progress: 0,
      durationMinutes: 12,
      xp: 100,
      description: outline.summary,
      sampleWord: outline.title,
      sampleMeaning: outline.summary,
    );
    widget.onStartLesson(lesson);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final displayName = currentUser?.displayName ?? 'Guest';

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FHeader(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안녕하세요, $displayName',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      suffixes: [
                        FHeaderAction(
                          icon: const Icon(Icons.settings_outlined),
                          onPress: widget.onOpenSettings,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _LevelAccordions(
                      controller: _accordionController,
                      catalog: _catalog,
                      selectedLessons: _selectedLessons,
                      onLessonChanged: _handleLessonSelection,
                      onStartLesson: _startOutline,
                    ),
                    const SizedBox(height: 24),
                    const _StreakRow(),
                    const SizedBox(height: 20),
                    const _StatHighlights(),
                    const SizedBox(height: 24),
                    const _QuickActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatHighlights extends StatelessWidget {
  const _StatHighlights();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (int i = 0; i < statTiles.length; i++) ...[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i != statTiles.length - 1 ? 12 : 0,
              ),
              child: FCard.raw(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(statTiles[i].icon, color: theme.colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        statTiles[i].value,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statTiles[i].label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statTiles[i].caption,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LevelAccordions extends StatelessWidget {
  const _LevelAccordions({
    required this.controller,
    required this.catalog,
    required this.selectedLessons,
    required this.onLessonChanged,
    required this.onStartLesson,
  });

  final FAccordionController controller;
  final Map<String, List<LessonOutline>> catalog;
  final Map<String, LessonOutline> selectedLessons;
  final void Function(String level, LessonOutline outline) onLessonChanged;
  final void Function(LessonOutline outline) onStartLesson;

  static const _laneMeta = [
    (
      level: '初級',
      title: '初級レーン',
      subtitle: '子音・母音を身体に染み込ませるセッション',
      color: AppColors.primaryBright,
      icon: Icons.bolt,
    ),
    (
      level: '中級',
      title: '中級レーン',
      subtitle: '頻出単語とリズム練習でスピードアップ',
      color: AppColors.secondary,
      icon: Icons.trending_up,
    ),
    (
      level: '上級',
      title: '上級レーン',
      subtitle: '文章入力と推し活フレーズで実戦モード',
      color: AppColors.accentEnd,
      icon: Icons.star,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FAccordion(
      controller: controller,
      children: _laneMeta.asMap().entries.map((entry) {
        final index = entry.key;
        final meta = entry.value;
        final lessons = catalog[meta.level] ?? const [];
        final selected = selectedLessons[meta.level] ?? lessons.first;

        return FAccordionItem(
          initiallyExpanded: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: meta.color.withValues(alpha: 0.18),
                child: Icon(meta.icon, color: meta.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meta.title),
                    Text(
                      meta.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '全${lessons.length}件',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${meta.level}レッスンを選択',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: meta.color.withValues(alpha: 0.4)),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.45),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selected.id,
                    isExpanded: true,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    icon: Icon(Icons.keyboard_arrow_down, color: meta.color),
                    items: lessons
                        .map(
                          (outline) => DropdownMenuItem(
                            value: outline.id,
                            child: Text(outline.title),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      final outline = lessons.firstWhere(
                        (lesson) => lesson.id == value,
                      );
                      onLessonChanged(meta.level, outline);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LessonDetailCard(
                outline: selected,
                accent: meta.color,
                onStart: () => onStartLesson(selected),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _LessonDetailCard extends StatelessWidget {
  const _LessonDetailCard({
    required this.outline,
    required this.accent,
    required this.onStart,
  });

  final LessonOutline outline;
  final Color accent;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _estimateDuration(outline.level);
    final xp = _estimateXp(outline.level);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
        color: accent.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(outline.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            outline.summary,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _MetaPill(
                icon: Icons.schedule,
                label: '$duration分',
                color: accent,
              ),
              _MetaPill(icon: Icons.bolt, label: '$xp XP', color: accent),
            ],
          ),
          const SizedBox(height: 16),
          FButton(
            onPress: onStart,
            style: FButtonStyle.secondary(),
            child: const Text('今すぐ開始'),
          ),
        ],
      ),
    );
  }

  static int _estimateDuration(String level) {
    switch (level) {
      case '初級':
        return 10;
      case '中級':
        return 14;
      default:
        return 18;
    }
  }

  static int _estimateXp(String level) {
    switch (level) {
      case '初級':
        return 90;
      case '中級':
        return 140;
      default:
        return 210;
    }
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StreakRow extends StatelessWidget {
  const _StreakRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.accentStart, AppColors.accentEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('24日連続で練習中', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'あと3日で次のバッジを獲得',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_graph,
                    color: AppColors.primary.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+18%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryBright,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _items = [
    _QuickActionData(
      title: '集中練習',
      subtitle: '苦手なキーのみで3分ウォームアップ',
      icon: Icons.center_focus_strong,
      accent: AppColors.primary,
      ctaLabel: '今すぐ開始',
      meta: [
        _QuickActionMeta(icon: Icons.timer, label: '3分ループ'),
        _QuickActionMeta(icon: Icons.track_changes, label: '弱点補正'),
      ],
    ),
    _QuickActionData(
      title: 'カスタム練習',
      subtitle: '自分の単語帳からセットを作成',
      icon: Icons.tune,
      accent: AppColors.secondary,
      ctaLabel: 'セットを作る',
      meta: [
        _QuickActionMeta(icon: Icons.list_alt, label: '単語帳から'),
        _QuickActionMeta(icon: Icons.loop, label: '繰り返し設定'),
      ],
    ),
    _QuickActionData(
      title: '推し活フレーズ',
      subtitle: 'お気に入りの応援文を即練習',
      icon: Icons.auto_awesome,
      accent: AppColors.accentEnd,
      ctaLabel: 'コレクションへ',
      meta: [
        _QuickActionMeta(icon: Icons.favorite, label: '20フレーズ'),
        _QuickActionMeta(icon: Icons.flash_on, label: 'ライブ前モード'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          _QuickActionCard(data: _items[i]),
          if (i != _items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.ctaLabel,
    required this.meta,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String ctaLabel;
  final List<_QuickActionMeta> meta;
}

class _QuickActionMeta {
  const _QuickActionMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      style: (style) => style.copyWith(
        decoration: style.decoration.copyWith(
          gradient: LinearGradient(
            colors: [
              data.accent.withValues(alpha: 0.4),
              data.accent.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: null,
          color: null,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(data.icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(data.title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            if (data.meta.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: data.meta
                    .map(
                      (meta) => _MetaPill(
                        icon: meta.icon,
                        label: meta.label,
                        color: data.accent,
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            FButton(
              onPress: () {},
              style: FButtonStyle.secondary(),
              suffix: const Icon(Icons.chevron_right),
              child: Text(data.ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}
