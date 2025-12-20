import 'dart:async';

import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:chaletta/ui/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

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
import '../writing/pattern_list_screen.dart';
import '../writing/topic_list_screen.dart';
import '../../../features/ranking_game/presentation/widgets/typing_game_section.dart';
import '../../../features/pronunciation_game/presentation/widgets/pronunciation_game_section.dart';
import '../../../features/hanja_quiz/presentation/widgets/hanja_quiz_section.dart';
import '../reference/kanadara_screen.dart';
import '../grammar/grammar_list_screen.dart';
import '../hanja/hanja_list_screen.dart';
import '../quick_translation/quick_translation_item_list_screen.dart';
import '../../../features/quick_translation/data/models/quick_translation_models.dart';
import '../../../features/quick_translation/domain/providers/quick_translation_providers.dart';
import '../../../features/wordbook/domain/providers/bulk_add_words_provider.dart';
import '../../utils/dialog_helper.dart';
import '../../widgets/bulk_add_progress_dialog.dart';

part 'home_progress_hero.dart';
part 'home_stat_highlights.dart';
part 'home_level_accordions.dart';
part 'home_writing_accordions.dart';
part 'home_exchange_rate.dart';
part 'home_feature_card.dart';
part 'home_category_section.dart';
part 'home_typing_hero.dart';
part 'home_weekly_progress.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.onOpenSettings,
    required this.onNavigateToDiary,
    required this.onNavigateToWordbook,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback onNavigateToDiary;
  final VoidCallback onNavigateToWordbook;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// ネットワークエラーのトースト表示済みフラグ（重複表示防止）
  bool _hasShownNetworkError = false;

  /// Pull-to-refresh でデータを再取得
  Future<void> _refresh() async {
    ref.invalidate(homeStateProvider);
    ref.invalidate(myRankingStatsSummaryProvider);
    ref.invalidate(integratedStatsProvider);
    ref.invalidate(exchangeRateProvider);
    ref.invalidate(quickTranslationCategoriesProvider);
  }

  void _openTranslation() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const TranslationScreen(),
      ),
    );
  }

  void _openGrammarDictionary() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const GrammarListScreen(),
      ),
    );
  }

  void _openHanjaDictionary() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const HanjaListScreen(),
      ),
    );
  }

  void _openKanadaRa() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const KanadaRaScreen(),
      ),
    );
  }

  void _openWriting(WritingLane lane) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PatternListScreen(lane: lane),
      ),
    );
  }

  void _openQuickTranslation() {
    // 瞬間作文のカテゴリ一覧画面へ遷移
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const _QuickTranslationListScreen(),
      ),
    );
  }
  void _openDiary() {
    widget.onNavigateToDiary();
  }

  void _openWordbook() {
    widget.onNavigateToWordbook();
  }

  void _openRankingGame() {
    // ランキングゲームセクションのボトムシートを表示
    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => const _GameDetailSheet(
        title: 'タイピングゲーム',
        child: RankingGameSection(),
      ),
    );
  }

  void _openPronunciationGame() {
    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => const _GameDetailSheet(
        title: '発音ゲーム',
        child: PronunciationGameSection(),
      ),
    );
  }

  void _openHanjaQuiz() {
    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => const _GameDetailSheet(
        title: '漢字語クイズ',
        child: HanjaQuizSection(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeStateProvider);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'Guest';
    final isPremiumUser = user?.isPremiumUser ?? false;

    return homeStateAsync.when(
      data: (state) {
        _hasShownNetworkError = false;
        return _buildHomeContent(
          state: state,
          displayName: displayName,
          isPremiumUser: isPremiumUser,
        );
      },
      loading: () => AppPageScaffold(
        title: '안녕하세요, $displayName',
        actions: [
          FHeaderAction(
            icon: const Icon(Iconsax.setting_2),
            onPress: widget.onOpenSettings,
          ),
        ],
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) {
        if (!_hasShownNetworkError) {
          _hasShownNetworkError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ToastHelper.show(context, 'ネットワークに接続できませんでした');
            }
          });
        }
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
        );
      },
    );
  }

  /// ホーム画面のコンテンツを構築
  Widget _buildHomeContent({
    required HomeState state,
    required String displayName,
    required bool isPremiumUser,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppPageScaffold(
      title: '안녕하세요, $displayName',
      actions: [
        FHeaderAction(
          icon: const Icon(Iconsax.setting_2),
          onPress: widget.onOpenSettings,
        ),
      ],
      childPad: false,
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        backgroundColor: isDark ? AppColors.surface : AppColors.lightSurface,
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
                    // 1. タイピング練習 Hero
                    _TypingPracticeHero(onLessonTap: _onLessonTap),
                    const SizedBox(height: AppSpacing.xl),

                    // 2. 機能グリッド（4列）
                    _FeatureGrid(
                      features: [
                        _FeatureItem(
                          title: 'カナダラ表',
                          icon: Iconsax.grid_1,
                          textIcon: 'ㄱㄴ',
                          gradientColors: FeatureGradients.kanadara,
                          onTap: _openKanadaRa,
                        ),
                        _FeatureItem(
                          title: '瞬間作文',
                          icon: Iconsax.flash_1,
                          gradientColors: FeatureGradients.quickTranslation,
                          onTap: _openQuickTranslation,
                        ),
                        _FeatureItem(
                          title: '書き取り',
                          icon: Iconsax.edit_2,
                          gradientColors: FeatureGradients.writing,
                          onTap: () => _showWritingOptions(context),
                        ),
                        _FeatureItem(
                          title: 'タイピング',
                          icon: Iconsax.keyboard,
                          gradientColors: FeatureGradients.typing,
                          onTap: _openRankingGame,
                        ),
                        _FeatureItem(
                          title: '発音',
                          icon: Iconsax.microphone_2,
                          gradientColors: FeatureGradients.pronunciation,
                          onTap: _openPronunciationGame,
                        ),
                        _FeatureItem(
                          title: '文法',
                          icon: Iconsax.book_1,
                          gradientColors: FeatureGradients.grammar,
                          onTap: _openGrammarDictionary,
                        ),
                        _FeatureItem(
                          title: '漢字語',
                          icon: Iconsax.translate,
                          gradientColors: FeatureGradients.hanjaQuiz,
                          onTap: _openHanjaQuiz,
                        ),
                        _FeatureItem(
                          title: '漢字語辞典',
                          icon: Iconsax.book_square,
                          gradientColors: FeatureGradients.hanjaDictionary,
                          onTap: _openHanjaDictionary,
                        ),
                        _FeatureItem(
                          title: '翻訳',
                          icon: Iconsax.translate,
                          gradientColors: FeatureGradients.translation,
                          onTap: _openTranslation,
                        ),
                        _FeatureItem(
                          title: '日記',
                          icon: Iconsax.document_text,
                          gradientColors: FeatureGradients.diary,
                          onTap: _openDiary,
                        ),
                        _FeatureItem(
                          title: '単語帳',
                          icon: Iconsax.book_saved,
                          gradientColors: FeatureGradients.wordbook,
                          onTap: _openWordbook,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // 3. 週間進捗
                    const _WeeklyProgressCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // 4. AI先生ボタン
                    _AiTeacherSection(
                      isPremiumUser: isPremiumUser,
                      onTap: () {
                        if (!isPremiumUser) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PremiumFeatureGateScreen(
                                focusFeature: 'AI先生',
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AiTeacherScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // 5. 為替レート
                    const _ExchangeRateCard(),
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

  void _showWritingOptions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                '書き取りカテゴリ',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            _WritingOptionTile(
              title: '単語',
              subtitle: 'カテゴリ別の基本単語をタイピング練習',
              icon: Iconsax.text,
              onTap: () {
                Navigator.pop(context);
                _openWriting(WritingLane.beginner);
              },
            ),
            _WritingOptionTile(
              title: '旅行',
              subtitle: '韓国旅行で使える実践フレーズ',
              icon: Iconsax.airplane,
              onTap: () {
                Navigator.pop(context);
                _openWriting(WritingLane.travel);
              },
            ),
            _WritingOptionTile(
              title: '趣味対策',
              subtitle: 'SNSや韓ドラ、推しなど気軽に書ける題材',
              icon: Iconsax.heart,
              onTap: () {
                Navigator.pop(context);
                _openWriting(WritingLane.hobby);
              },
            ),
            _WritingOptionTile(
              title: 'TOPIK対策',
              subtitle: 'タイピングで覚える論述パターン',
              icon: Iconsax.teacher,
              onTap: () {
                Navigator.pop(context);
                _openWriting(WritingLane.topik);
              },
            ),
            SizedBox(height: AppSpacing.xl + bottomPadding + 24),
          ],
        ),
      ),
    );
  }
}

/// 書き取りオプションタイル
class _WritingOptionTile extends StatelessWidget {
  const _WritingOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
        child: Icon(icon, color: AppColors.secondary, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3),
      onTap: onTap,
    );
  }
}

/// ゲーム詳細シート
class _GameDetailSheet extends StatelessWidget {
  const _GameDetailSheet({
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: AppSpacing.lg + bottomPadding + 24,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// 瞬間作文カテゴリ一覧画面
class _QuickTranslationListScreen extends ConsumerWidget {
  const _QuickTranslationListScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(quickTranslationCategoriesProvider);
    final wordCountAsync = ref.watch(quickTranslationWordCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('瞬間作文'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => _showAddAllWordsConfirmation(context, ref, wordCountAsync),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _QuickTranslationCategoryTile(category: category);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Future<void> _showAddAllWordsConfirmation(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<int> wordCountAsync,
  ) async {
    final wordCount = wordCountAsync.value ?? 0;
    final confirmed = await DialogHelper.showConfirmDialog(
      context,
      title: '単語帳に追加',
      content: '瞬間作文で使用される全ての単語（$wordCount語）を単語帳に追加します。よろしいですか？',
      positiveLabel: 'はい',
      negativeLabel: 'キャンセル',
    );

    if (!confirmed || !context.mounted) return;

    // 進捗ダイアログを表示してバルク追加開始
    unawaited(BulkAddProgressDialog.show(context));
    await ref.read(bulkAddWordsProvider.notifier).addAllQuickTranslationWords();
  }
}

/// 瞬間作文カテゴリタイル
class _QuickTranslationCategoryTile extends StatelessWidget {
  const _QuickTranslationCategoryTile({required this.category});

  final QuickTranslationCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToItemList(context),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getCategoryColor().withValues(alpha: isDark ? 0.2 : 0.1),
                _getCategoryColor().withValues(alpha: isDark ? 0.1 : 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(),
                    color: _getCategoryColor(),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${category.itemCount}項目',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        if (category.clearedCount > 0) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${category.clearedCount}クリア',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (category.id) {
      case 'orthography':
        return Colors.blue;
      case 'substantive':
        return Colors.teal;
      case 'particle':
        return Colors.purple;
      case 'conjugation':
        return Colors.orange;
      case 'sentence_ending':
        return Colors.pink;
      case 'connective':
        return Colors.indigo;
      case 'adnominal':
        return Colors.cyan;
      case 'tense_aspect':
        return Colors.amber;
      case 'expression':
        return Colors.green;
      case 'quotation':
        return Colors.deepPurple;
      case 'word_formation':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (category.id) {
      case 'orthography':
        return Iconsax.text;
      case 'substantive':
        return Iconsax.category;
      case 'particle':
        return Iconsax.link;
      case 'conjugation':
        return Iconsax.convert;
      case 'sentence_ending':
        return Iconsax.message;
      case 'connective':
        return Iconsax.arrow_swap_horizontal;
      case 'adnominal':
        return Iconsax.edit_2;
      case 'tense_aspect':
        return Iconsax.clock;
      case 'expression':
        return Iconsax.lamp_charge;
      case 'quotation':
        return Iconsax.quote_up;
      case 'word_formation':
        return Iconsax.setting_3;
      default:
        return Iconsax.book;
    }
  }

  void _navigateToItemList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuickTranslationItemListScreen(
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
    );
  }
}

/// AI先生セクション
class _AiTeacherSection extends StatelessWidget {
  const _AiTeacherSection({
    required this.isPremiumUser,
    required this.onTap,
  });

  final bool isPremiumUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1A2634).withValues(alpha: 0.9),
                  const Color(0xFF243442).withValues(alpha: 0.9),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF0F8F8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // AIアイコン
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Iconsax.magic_star,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // テキスト
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI先生',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '韓国語の疑問をAIに質問しよう',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // ボタン
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.message,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '質問する',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
