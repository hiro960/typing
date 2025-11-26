import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/sheet_content.dart';
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
  DiaryFeedType _selectedFeed = DiaryFeedType.recommended;
  final _scrollController = ScrollController();

  static const _feedLabels = {
    DiaryFeedType.recommended: 'おすすめ',
    DiaryFeedType.following: 'フォロー中',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(diaryTimelineControllerProvider.notifier)
          .ensureLoaded(_selectedFeed);
    });
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(diaryTimelineControllerProvider.notifier)
          .loadMore(_selectedFeed);
    }
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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timelineState = ref.watch(diaryTimelineControllerProvider);
    final feedState = timelineState.feed(_selectedFeed);
    final currentUser = ref.watch(currentUserProvider);

    return AppPageScaffold(
      childPad: false,
      header: FHeader(
        title: Row(
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 22,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text('日記', style: theme.textTheme.headlineSmall),
          ],
        ),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.search),
            onPress: widget.onOpenSearch,
          ),
          FHeaderAction(
            icon: const Icon(Icons.bookmark_outline),
            onPress: widget.onOpenBookmarks,
          ),
          FHeaderAction(
            icon: const Icon(Icons.edit_document),
            onPress: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DraftsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppPadding.homePage.left,
              8,
              AppPadding.homePage.right,
              0,
            ),
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
                    (feed) => FTabEntry(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        child: Text(_feedLabels[feed]!),
                      ),
                      child: const SizedBox.shrink(),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.homePage.left,
                ),
                child: Builder(
                  builder: (context) {
                    if (feedState.isLoading && feedState.posts.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (feedState.errorMessage != null &&
                        feedState.posts.isEmpty) {
                      return Center(
                        child: Text(feedState.errorMessage!),
                      );
                    }
                    if (feedState.posts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          child: Text(
                            _selectedFeed == DiaryFeedType.following
                                ? 'フォロー中のユーザーはいません'
                                : '投稿がありません',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
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
                        );
                      },
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
