import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:chaletta/ui/widgets/section_title.dart';
import 'package:chaletta/ui/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/exchange_rate/data/models/exchange_rate_model.dart';
import '../../../features/exchange_rate/domain/providers/exchange_rate_providers.dart';
import '../../../features/lessons/data/models/lesson_index.dart'
    as lesson_index;
import '../../../features/lessons/data/models/lesson_models.dart';
import '../../../features/lessons/data/models/lesson_progress.dart';
import '../../../features/lessons/domain/providers/home_state_provider.dart';
import '../../../features/writing/data/models/writing_models.dart';
import '../../../features/writing/domain/providers/writing_providers.dart';
import '../../../features/ranking_game/domain/providers/ranking_providers.dart';
import '../../../features/stats/data/models/integrated_stats_model.dart';
import '../../../features/stats/domain/providers/integrated_stats_providers.dart';
import '../../app_theme.dart';
import '../../app_spacing.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../typing/lesson_detail_screen.dart';
import '../ai_teacher_screen.dart';
import '../translation/translation_screen.dart';
import '../writing/topic_list_screen.dart';
import '../../widgets/ai_gradient_button.dart';
import '../../../features/ranking_game/presentation/widgets/ranking_game_section.dart';
import '../../../features/pronunciation_game/presentation/widgets/pronunciation_game_section.dart';

part 'home_progress_hero.dart';
part 'home_stat_highlights.dart';
part 'home_level_accordions.dart';
part 'home_writing_accordions.dart';
part 'home_exchange_rate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenSettings,
  });

  final VoidCallback onOpenSettings;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _typingAccordionController = FAccordionController(max: 1);
  final _writingAccordionController = FAccordionController(max: 1);
  final _beginnerWritingAccordionController = FAccordionController(max: 1);
  final _hobbyWritingAccordionController = FAccordionController(max: 1);

  /// ネットワークエラーのトースト表示済みフラグ（重複表示防止）
  bool _hasShownNetworkError = false;

  @override
  void dispose() {
    _typingAccordionController.dispose();
    _writingAccordionController.dispose();
    _beginnerWritingAccordionController.dispose();
    _hobbyWritingAccordionController.dispose();
    super.dispose();
  }

  /// Pull-to-refresh でデータを再取得
  Future<void> _refresh() async {
    // 各プロバイダーを invalidate して再取得
    ref.invalidate(homeStateProvider);
    // ランキング統計も再取得
    ref.invalidate(myRankingStatsSummaryProvider);
    // 統合統計も再取得
    ref.invalidate(integratedStatsProvider);
    // 為替レートも再取得
    ref.invalidate(exchangeRateProvider);
  }

  void _openTranslation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const TranslationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeStateProvider);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'Guest';
    final isPremiumUser = user?.isPremiumUser ?? false;
    final integratedStatsAsync = ref.watch(integratedStatsProvider);

    return homeStateAsync.when(
      data: (state) {
        // データ取得成功時はエラーフラグをリセット
        _hasShownNetworkError = false;
        return _buildHomeContent(
          state: state,
          displayName: displayName,
          isPremiumUser: isPremiumUser,
          integratedStatsAsync: integratedStatsAsync,
        );
      },
      loading: () => AppPageScaffold(
        title: '안녕하세요, $displayName',
        actions: [
          FHeaderAction(
            icon: const Icon(Icons.settings_outlined),
            onPress: widget.onOpenSettings,
          ),
        ],
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) {
        // ネットワークエラー時にFToastを表示（重複表示防止）
        if (!_hasShownNetworkError) {
          _hasShownNetworkError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ToastHelper.show(context, 'ネットワークに接続できませんでした');
            }
          });
        }
        // 空のデータでホーム画面を表示（プルダウンで再試行可能）
        final emptyState = HomeState(
          catalog: const {},
          statsAsync: const AsyncValue.data(LessonStatsSummary()),
          progress: const {},
          focusLesson: null,
        );
        return _buildHomeContent(
          state: emptyState,
          displayName: displayName,
          isPremiumUser: isPremiumUser,
          integratedStatsAsync: const AsyncValue.data(null),
        );
      },
    );
  }

  /// ホーム画面のコンテンツを構築
  Widget _buildHomeContent({
    required HomeState state,
    required String displayName,
    required bool isPremiumUser,
    required AsyncValue<IntegratedStats?> integratedStatsAsync,
  }) {
    final theme = Theme.of(context);

    return AppPageScaffold(
      title: '안녕하세요, $displayName',
      actions: [
        FHeaderAction(
          icon: const Icon(Icons.settings_outlined),
          onPress: widget.onOpenSettings,
        ),
      ],
      childPad: false,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: AppPadding.homePage,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      iconData: Icons.currency_exchange,
                      text: '為替レート',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const _ExchangeRateCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionTitle(
                      iconData: Icons.translate,
                      text: '翻訳',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // 翻訳画面へのリンクカード
                    InkWell(
                      onTap: _openTranslation,
                      borderRadius: BorderRadius.circular(12),
                      child: FCard(
                        child: Row(
                          children: [
                            Icon(
                              Icons.translate,
                              size: 24,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '日本語 ↔ 韓国語',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'タップして翻訳画面を開く',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const SectionTitle(
                      iconData: Icons.keyboard,
                      text: 'タイピングレッスン',
                    ),
                    _LevelAccordions(
                      controller: _typingAccordionController,
                      catalog: state.catalog,
                      progress: state.progress,
                      onLessonTap: _onLessonTap,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _ProgressHero(
                      integratedStatsAsync: integratedStatsAsync,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _StatHighlights(
                      integratedStatsAsync: integratedStatsAsync,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const RankingGameSection(),
                    const SizedBox(height: AppSpacing.xxl),
                    const PronunciationGameSection(),
                    const SizedBox(height: AppSpacing.xxl),
                    const SectionTitle(iconData: Icons.edit, text: '書き取り練習'),
                    const SizedBox(height: AppSpacing.md),
                    _WritingPatternAccordions(
                      controller: _beginnerWritingAccordionController,
                      title: '単語',
                      subtitle: 'カテゴリ別の基本単語をタイピング練習',
                      lane: WritingLane.beginner,
                    ),
                    _WritingPatternAccordions(
                      controller: _hobbyWritingAccordionController,
                      title: '趣味対策',
                      subtitle: 'SNSや韓ドラ、推しなど気軽に書ける題材',
                      lane: WritingLane.hobby,
                    ),
                    _WritingPatternAccordions(
                      controller: _writingAccordionController,
                      title: 'TOPIK対策',
                      subtitle: 'タイピングで覚える論述パターン',
                      lane: WritingLane.topik,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        children: [
                          AiGradientButton(
                            label: 'AI先生に聞く',
                            onTap: () {
                              if (!isPremiumUser) {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const PremiumFeatureGateScreen(
                                          focusFeature: 'AI先生',
                                        ),
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AiTeacherScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLessonTap(lesson_index.LessonMeta lesson, bool isLocked) {
    if (!mounted) return;
    if (isLocked) {
      showFDialog<void>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: true,
        builder: (context, style, animation) => FDialog.adaptive(
          style: style,
          animation: animation,
          title: const Text('レッスンがロックされています'),
          body: const Text('前のレッスンを完了すると、このレッスンが解除されます。'),
          actions: [
            FButton(
              style: FButtonStyle.outline(),
              onPress: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LessonDetailScreen(lessonId: lesson.id),
      ),
    );
  }
}
