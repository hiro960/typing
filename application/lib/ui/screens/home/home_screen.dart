import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
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
import '../../../features/ranking_game/presentation/widgets/typing_game_section.dart';
import '../../../features/pronunciation_game/presentation/widgets/pronunciation_game_section.dart';
import '../reference/kanadara_screen.dart';
import '../grammar/grammar_list_screen.dart';

part 'home_progress_hero.dart';
part 'home_stat_highlights.dart';
part 'home_level_accordions.dart';
part 'home_writing_accordions.dart';
part 'home_exchange_rate.dart';
part 'home_learning_tabs.dart';

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
  final _travelWritingAccordionController = FAccordionController(max: 1);
  final _hobbyWritingAccordionController = FAccordionController(max: 1);
  final _statsAccordionController = FAccordionController(max: 1);

  /// 現在選択中の学習タブ
  _LearningTab _selectedTab = _LearningTab.typing;

  /// ネットワークエラーのトースト表示済みフラグ（重複表示防止）
  bool _hasShownNetworkError = false;

  @override
  void dispose() {
    _typingAccordionController.dispose();
    _writingAccordionController.dispose();
    _beginnerWritingAccordionController.dispose();
    _travelWritingAccordionController.dispose();
    _hobbyWritingAccordionController.dispose();
    _statsAccordionController.dispose();
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

  void _openGrammarDictionary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const GrammarListScreen(),
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
            icon: const Icon(Icons.menu_book_outlined),
            onPress: () => _openGrammarDictionary(context),
          ),
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
    return AppPageScaffold(
      title: '안녕하세요, $displayName',
      actions: [
        FHeaderAction(
          icon: const Icon(Icons.menu_book_outlined),
          onPress: () => _openGrammarDictionary(context),
        ),
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
                    // 為替レート + 翻訳の統合カード
                    _QuickToolsCard(onTranslationTap: _openTranslation),
                    const SizedBox(height: AppSpacing.xl),
                    // 学習タブセレクター
                    _LearningTabSelector(
                      selectedTab: _selectedTab,
                      onTabChanged: (tab) {
                        setState(() => _selectedTab = tab);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // タブに応じたコンテンツ
                    _buildTabContent(
                      state: state,
                      integratedStatsAsync: integratedStatsAsync,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // AI先生ボタン
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: AiGradientButton(
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

  /// 選択中のタブに応じたコンテンツを構築
  Widget _buildTabContent({
    required HomeState state,
    required AsyncValue<IntegratedStats?> integratedStatsAsync,
  }) {
    switch (_selectedTab) {
      case _LearningTab.typing:
        return _TypingTabContent(
          catalog: state.catalog,
          progress: state.progress,
          typingAccordionController: _typingAccordionController,
          statsAccordionController: _statsAccordionController,
          onLessonTap: _onLessonTap,
          integratedStatsAsync: integratedStatsAsync,
        );
      case _LearningTab.games:
        return const _GamesTabContent();
      case _LearningTab.writing:
        return _WritingTabContent(
          beginnerWritingAccordionController: _beginnerWritingAccordionController,
          travelWritingAccordionController: _travelWritingAccordionController,
          hobbyWritingAccordionController: _hobbyWritingAccordionController,
          writingAccordionController: _writingAccordionController,
        );
    }
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
