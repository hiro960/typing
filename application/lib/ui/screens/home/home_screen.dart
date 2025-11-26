import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/lessons/data/models/lesson_index.dart'
    as lesson_index;
import '../../../features/lessons/data/models/lesson_models.dart';
import '../../../features/lessons/data/models/lesson_progress.dart';
import '../../../features/lessons/domain/providers/home_state_provider.dart';
import '../../../features/writing/data/models/writing_models.dart';
import '../../../features/writing/domain/providers/writing_providers.dart';
import '../../app_theme.dart';
import '../../app_spacing.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../typing/lesson_detail_screen.dart';
import '../ai_teacher_screen.dart';
import '../writing/topic_list_screen.dart';
import '../../widgets/ai_gradient_button.dart';

part 'home_progress_hero.dart';
part 'home_stat_highlights.dart';
part 'home_level_accordions.dart';
part 'home_writing_accordions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _typingAccordionController = FAccordionController(max: 1);
  final _writingAccordionController = FAccordionController(max: 1);

  @override
  void dispose() {
    _typingAccordionController.dispose();
    _writingAccordionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeStateProvider);
    final user = ref.watch(currentUserProvider);
    final displayName = user?.displayName ?? 'Guest';
    final isPremiumUser = user?.isPremiumUser ?? false;

    return homeStateAsync.when(
      data: (state) {
        return AppPageScaffold(
          childPad: false,
          header: FHeader(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요, $displayName',
                  style: Theme.of(context).textTheme.headlineSmall,
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: AppPadding.homePage,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProgressHero(stats: state.stats),
                      const SizedBox(height: AppSpacing.lg),
                      _StatHighlights(
                        stats: state.stats,
                        maxWpm: user?.maxWPM ?? 0,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      const Text('タイピング練習'),
                      _LevelAccordions(
                        controller: _typingAccordionController,
                        catalog: state.catalog,
                        progress: state.progress,
                        onLessonTap: _onLessonTap,
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
                                      builder: (_) => const PremiumFeatureGateScreen(
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
                      const SizedBox(height: AppSpacing.xxl),
                      const Text('書き取り練習'),
                      _WritingPatternAccordions(
                        controller: _writingAccordionController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => AppPageScaffold(
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) =>
          AppPageScaffold(child: Center(child: Text(error.toString()))),
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

  void _showCustomPracticeHint() {
    SnackBarHelper.show(context, 'カスタム練習は近日公開予定です。');
  }
}
