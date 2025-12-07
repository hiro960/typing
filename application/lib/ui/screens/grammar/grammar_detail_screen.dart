import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../features/grammar/data/models/grammar_detail.dart';
import '../../../features/grammar/data/models/grammar_index.dart';
import '../../../features/grammar/data/models/grammar_models.dart';
import '../../../features/grammar/domain/providers/grammar_providers.dart';
import '../../app_spacing.dart';
import '../../app_theme.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_error_view.dart';
import 'grammar_exercise_screen.dart';

/// 文法詳細画面
class GrammarDetailScreen extends ConsumerStatefulWidget {
  const GrammarDetailScreen({
    super.key,
    required this.grammarId,
  });

  final String grammarId;

  @override
  ConsumerState<GrammarDetailScreen> createState() =>
      _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _navigateToExercise(GrammarDetail grammar) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GrammarExerciseScreen(grammarId: widget.grammarId),
      ),
    );
  }

  void _navigateToRelated(String grammarId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GrammarDetailScreen(grammarId: grammarId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(grammarDetailProvider(widget.grammarId));
    final isFavoriteAsync = ref.watch(isGrammarFavoriteProvider(widget.grammarId));

    return detailAsync.when(
      data: (grammar) => AppPageScaffold(
        title: grammar.title,
        showBackButton: true,
        safeBottom: true,
        actions: [
          isFavoriteAsync.when(
            data: (isFavorite) => IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => ref
                  .read(grammarFavoritesProvider.notifier)
                  .toggle(widget.grammarId),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 概要カード
              _SummaryCard(grammar: grammar),
              const SizedBox(height: AppSpacing.lg),

              // 活用規則セクション
              if (grammar.content.formationRules.isNotEmpty) ...[
                _FormationRulesSection(rules: grammar.content.formationRules),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 用法・用例セクション
              if (grammar.content.usageCases.isNotEmpty) ...[
                _UsageCasesSection(
                  cases: grammar.content.usageCases,
                  onSpeak: _speak,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 比較セクション
              if (grammar.content.comparison != null) ...[
                _ComparisonSection(comparison: grammar.content.comparison!),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ヒント・コツセクション
              if (grammar.content.tips.isNotEmpty) ...[
                _TipsSection(tips: grammar.content.tips),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 関連文法セクション
              if (grammar.content.relatedGrammar.isNotEmpty) ...[
                _RelatedGrammarSection(
                  relatedIds: grammar.content.relatedGrammar,
                  onTap: _navigateToRelated,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // 練習問題ボタン
              if (grammar.exercises.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    icon: const Icon(Icons.quiz),
                    onPressed: () => _navigateToExercise(grammar),
                    label: Text('練習問題（${grammar.exercises.length}問）'),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      loading: () => AppPageScaffold(
        title: '文法詳細',
        showBackButton: true,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => AppPageScaffold(
        title: '文法詳細',
        showBackButton: true,
        child: PageErrorView(
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(grammarDetailProvider(widget.grammarId)),
        ),
      ),
    );
  }
}

/// 概要カード
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.grammar});

  final GrammarDetail grammar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LevelBadge(level: grammar.level),
              const SizedBox(width: AppSpacing.sm),
              _CategoryBadge(category: grammar.category),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            grammar.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            grammar.content.summary,
            style: theme.textTheme.bodyMedium,
          ),
          if (grammar.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  grammar.tags.map((tag) => _TagChip(tag: tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// 活用規則セクション
class _FormationRulesSection extends StatelessWidget {
  const _FormationRulesSection({required this.rules});

  final List<FormationRule> rules;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: '活用規則', icon: Icons.rule),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      '条件',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      '形',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      '例',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              ...rules.map(
                (rule) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(rule.condition),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        rule.form,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBright,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(rule.example),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 用法・用例セクション
class _UsageCasesSection extends StatelessWidget {
  const _UsageCasesSection({
    required this.cases,
    required this.onSpeak,
  });

  final List<UsageCase> cases;
  final Future<void> Function(String) onSpeak;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: '用法・用例', icon: Icons.format_list_bulleted),
        const SizedBox(height: AppSpacing.sm),
        ...cases.map(
          (useCase) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _UsageCaseCard(
              useCase: useCase,
              onSpeak: onSpeak,
            ),
          ),
        ),
      ],
    );
  }
}

/// 用法カード
class _UsageCaseCard extends StatelessWidget {
  const _UsageCaseCard({
    required this.useCase,
    required this.onSpeak,
  });

  final UsageCase useCase;
  final Future<void> Function(String) onSpeak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            useCase.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            useCase.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...useCase.examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ExampleRow(
                example: example,
                onSpeak: () => onSpeak(example.korean),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 例文行
class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.example,
    required this.onSpeak,
  });

  final GrammarExample example;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  example.korean,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, size: 20),
                onPressed: onSpeak,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
          Text(
            example.japanese,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// 比較セクション
class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection({required this.comparison});

  final GrammarComparison comparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: comparison.title, icon: Icons.compare_arrows),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comparison.description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              ...comparison.examples.map(
                (ex) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ComparisonExampleCard(example: ex),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 比較例カード
class _ComparisonExampleCard extends StatelessWidget {
  const _ComparisonExampleCard({required this.example});

  final ComparisonExample example;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // A側
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                example.grammarA,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(example.sentenceA),
              Text(
                example.meaningA,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        // B側
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                example.grammarB,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Text(example.sentenceB),
              Text(
                example.meaningB,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ヒント・コツセクション
class _TipsSection extends StatelessWidget {
  const _TipsSection({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ヒント・コツ', icon: Icons.lightbulb_outline),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tips
                .map(
                  (tip) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.amber)),
                        Expanded(child: Text(tip)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// 関連文法セクション
class _RelatedGrammarSection extends ConsumerWidget {
  const _RelatedGrammarSection({
    required this.relatedIds,
    required this.onTap,
  });

  final List<String> relatedIds;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(grammarIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: '関連文法', icon: Icons.link),
        const SizedBox(height: AppSpacing.sm),
        indexAsync.when(
          data: (index) {
            final relatedMetas =
                relatedIds
                    .map((id) => index.findGrammarMeta(id))
                    .whereType<GrammarMeta>()
                    .toList();

            if (relatedMetas.isEmpty) {
              return const SizedBox.shrink();
            }

            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children:
                  relatedMetas
                      .map(
                        (meta) => ActionChip(
                          label: Text(meta.title),
                          onPressed: () => onTap(meta.id),
                        ),
                      )
                      .toList(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// セクションヘッダー
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// レベルバッジ
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final GrammarLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: level.color,
        ),
      ),
    );
  }
}

/// カテゴリバッジ
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final GrammarCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 12),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// タグチップ
class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '#$tag',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
