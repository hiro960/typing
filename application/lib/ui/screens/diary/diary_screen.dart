import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/app_page_scaffold.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _toggleBookmark(DiaryPost post) async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleBookmark(post.id, bookmark: !post.bookmarked);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ブロック'),
        content: Text('${post.user.displayName}さんをブロックしますか？'),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () => Navigator.of(context).pop(true),
            child: const Text('ブロック'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(diaryRepositoryProvider).blockUser(post.user.id);
      _showSnack('${post.user.displayName}さんをブロックしました');
      await _refresh();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _reportPost(DiaryPost post) async {
    const reasons = [
      {'label': 'スパム', 'value': 'SPAM'},
      {'label': '嫌がらせ', 'value': 'HARASSMENT'},
      {'label': '不適切な内容', 'value': 'INAPPROPRIATE_CONTENT'},
      {'label': 'ヘイト発言', 'value': 'HATE_SPEECH'},
      {'label': 'その他', 'value': 'OTHER'},
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: reasons
              .map(
                (reason) => FTile(
                  title: Text(reason['label']!),
                  onPress: () => Navigator.of(context).pop(reason['value']),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    try {
      await ref.read(diaryRepositoryProvider).reportPost(
            postId: post.id,
            reason: selected,
          );
      _showSnack('投稿を通報しました');
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    _showSnack(error.toString());
  }

  void _showSnack(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
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
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          padding: const EdgeInsets.all(32),
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
