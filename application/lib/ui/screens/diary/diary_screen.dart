import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/translation/domain/providers/translation_providers.dart';
import '../../app_theme.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import '../../widgets/sheet_content.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/premium_feature_gate.dart';
import '../../app_spacing.dart';
import 'drafts_screen.dart';
import 'post_create_screen.dart';
import 'post_detail_screen.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({
    super.key,
    required this.onOpenSearch,
    required this.onOpenBookmarks,
  });

  final VoidCallback onOpenSearch;
  final VoidCallback onOpenBookmarks;

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  DiaryFeedType _selectedFeed = DiaryFeedType.latest;
  final _scrollController = ScrollController();

  static const _feedLabels = {
    DiaryFeedType.latest: '最新',
    DiaryFeedType.recommended: 'おすすめ',
    DiaryFeedType.following: 'フォロー',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(diaryTimelineControllerProvider.notifier)
          .ensureLoaded(_selectedFeed);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref
        .read(diaryTimelineControllerProvider.notifier)
        .refresh(_selectedFeed);
  }

  void _openDetail(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailScreen(initialPost: post),
      ),
    );
  }

  Future<void> _toggleLike(DiaryPost post) async {
    final settings = ref.read(typingSettingsProvider).value;
    if (settings?.hapticsEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleLike(post.id, like: !post.liked);
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, error);
    }
  }

  Future<void> _toggleBookmark(DiaryPost post) async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleBookmark(post.id, bookmark: !post.bookmarked);
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, error);
    }
  }



  void _quotePost(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostCreateScreen(quotedPost: post),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _editPost(DiaryPost post) async {
    final updated = await Navigator.of(context).push<DiaryPost>(
      MaterialPageRoute(
        builder: (_) => PostCreateScreen(initialPost: post),
        fullscreenDialog: true,
      ),
    );
    if (updated != null) {
      ref.read(diaryTimelineControllerProvider.notifier).updatePost(updated);
    }
  }

  Future<void> _blockUser(DiaryPost post) async {
    final confirm = await DialogHelper.showConfirmDialog(
      context,
      title: 'ブロック',
      content: '${post.user.displayName}さんをブロックしますか？',
      positiveLabel: 'ブロック',
      isDestructive: true,
    );
    if (!confirm) return;
    try {
      await ref.read(diaryRepositoryProvider).blockUser(post.user.id);
      SnackBarHelper.show(context, '${post.user.displayName}さんをブロックしました');
      await _refresh();
    } catch (error) {
      SnackBarHelper.showError(context, error);
    }
  }

  Future<void> _reportPost(DiaryPost post) async {
    final selected = await showFSheet<String>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => SheetContent(
        children: [
          SheetOption(
            label: 'スパム',
            onPress: () => Navigator.of(context).pop('SPAM'),
          ),
          SheetOption(
            label: '嫌がらせ',
            onPress: () => Navigator.of(context).pop('HARASSMENT'),
          ),
          SheetOption(
            label: '不適切な内容',
            onPress: () => Navigator.of(context).pop('INAPPROPRIATE_CONTENT'),
          ),
          SheetOption(
            label: 'ヘイト発言',
            onPress: () => Navigator.of(context).pop('HATE_SPEECH'),
          ),
          SheetOption(
            label: 'その他',
            onPress: () => Navigator.of(context).pop('OTHER'),
          ),
        ],
      ),
    );
    if (selected == null) return;
    try {
      await ref.read(diaryRepositoryProvider).reportPost(
            postId: post.id,
            reason: selected,
          );
      SnackBarHelper.show(context, '投稿を通報しました');
    } catch (error) {
      SnackBarHelper.showError(context, error);
    }
  }

  /// 翻訳ボタンが押された時の処理
  Future<void> _translatePost(DiaryPost post) async {
    final currentUser = ref.read(currentUserProvider);
    final isPremiumUser = currentUser?.isPremiumUser ?? false;

    // 無料会員の場合は有料会員限定のダイアログを表示
    if (!isPremiumUser) {
      _showPremiumOnlyDialog();
      return;
    }

    final controller = ref.read(diaryTranslationControllerProvider.notifier);

    try {
      await controller.translatePost(post.id, post.content);
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, '翻訳に失敗しました');
    }
  }

  /// 有料会員限定機能のダイアログを表示
  void _showPremiumOnlyDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Iconsax.crown, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('有料会員限定'),
          ],
        ),
        content: const Text(
          'この機能は有料会員またはオフィシャル会員限定です。\n\nアップグレードすると、日記の翻訳機能をご利用いただけます。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const PremiumFeatureGateScreen(focusFeature: '日記の翻訳'),
                ),
              );
            },
            child: const Text('プロプランを見る'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(diaryTimelineControllerProvider);
    final feedState = timelineState.feed(_selectedFeed);
    final currentUser = ref.watch(currentUserProvider);
    final translationState = ref.watch(diaryTranslationControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppPageScaffold(
      title: '日記',
      titleIcon: Icons.menu_book_outlined,
      actions: [
        FHeaderAction(
          icon: const Icon(Iconsax.search_normal),
          onPress: widget.onOpenSearch,
        ),
        FHeaderAction(
          icon: const Icon(Iconsax.bookmark),
          onPress: widget.onOpenBookmarks,
        ),
        FHeaderAction(
          icon: const Icon(Iconsax.document),
          onPress: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DraftsScreen(),
              ),
            );
          },
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: FTabs(
              key: ValueKey(_selectedFeed),
              initialIndex: DiaryFeedType.values.indexOf(_selectedFeed),
              onChange: (index) {
                final feed = DiaryFeedType.values[index];
                setState(() => _selectedFeed = feed);
                ref
                    .read(diaryTimelineControllerProvider.notifier)
                    .ensureLoaded(feed);
              },
              children: DiaryFeedType.values
                  .map(
                    (feed) {
                      final isSelected = feed == _selectedFeed;
                      final IconData icon;
                      switch (feed) {
                        case DiaryFeedType.latest:
                          icon = Iconsax.clock;
                        case DiaryFeedType.recommended:
                          icon = Iconsax.star;
                        case DiaryFeedType.following:
                          icon = Iconsax.people;
                      }
                      return FTabEntry(
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 14,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _feedLabels[feed]!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: const SizedBox.shrink(),
                      );
                    },
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColors.primary,
              backgroundColor:
                  isDark ? AppColors.surface : AppColors.lightSurface,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.homePage.left,
                ),
                child: Builder(
                  builder: (context) {
                    if (feedState.isLoading && feedState.posts.isEmpty) {
                      return const _DiaryPostSkeletonList();
                    }
                    if (feedState.errorMessage != null &&
                        feedState.posts.isEmpty) {
                      return PageErrorView(
                        message: feedState.errorMessage,
                        onRetry: _refresh,
                      );
                    }
                    if (feedState.posts.isEmpty) {
                      return PageEmptyView(
                        icon: Iconsax.document,
                        title: _selectedFeed == DiaryFeedType.following
                            ? 'フォロー中のユーザーはいません'
                            : '投稿がありません',
                        description: '下に引っ張って再読み込み',
                      );
                    }
                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification ||
                            notification is ScrollUpdateNotification) {
                          final metrics = notification.metrics;
                          if (metrics.pixels >=
                              metrics.maxScrollExtent - 200) {
                            ref
                                .read(diaryTimelineControllerProvider.notifier)
                                .loadMore(_selectedFeed);
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        key: ValueKey(_selectedFeed),
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 120,
                        ),
                        itemCount: feedState.posts.length +
                            (feedState.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= feedState.posts.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final post = feedState.posts[index];
                          return DiaryPostCard(
                            post: post,
                            onTap: () => _openDetail(post),
                            onToggleLike: () => _toggleLike(post),
                            onToggleBookmark: () => _toggleBookmark(post),
                            onComment: () => _openDetail(post),
                            onQuote: () => _quotePost(post),
                            onBlock: () => _blockUser(post),
                            onReport: () => _reportPost(post),
                            onEdit: () => _editPost(post),
                            currentUserId: currentUser?.id,
                            onTranslate: () => _translatePost(post),
                            translatedText:
                                translationState.translations[post.id],
                            isTranslating:
                                translationState.loadingPostIds.contains(post.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryPostSkeletonList extends StatelessWidget {
  const _DiaryPostSkeletonList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? AppColors.surface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.border.withValues(alpha: 0.4) : AppColors.lightBorder;

    return SkeletonListBuilder(
      itemCount: 4,
      padding: const EdgeInsets.only(top: 12, bottom: 120),
      separatorHeight: 16,
      itemBuilder: (context, index) {
        return Card(
          color: cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    ShimmerCircle(size: 40),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBlock(width: 100, height: 16),
                          SizedBox(height: 6),
                          ShimmerBlock(width: 140, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const ShimmerBlock(height: 14),
                const SizedBox(height: 8),
                const ShimmerBlock(height: 14),
                const SizedBox(height: 8),
                const ShimmerBlock(widthFactor: 0.6, height: 14),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    ShimmerBlock(width: 60, height: 24),
                    SizedBox(width: 16),
                    ShimmerBlock(width: 60, height: 24),
                    Spacer(),
                    ShimmerBlock(width: 24, height: 24),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
