import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/diary_post_card.dart';
import 'post_create_screen.dart';
import 'post_detail_screen.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diaryBookmarksControllerProvider.notifier).loadInitial();
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
      ref.read(diaryBookmarksControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() async {
    await ref.read(diaryBookmarksControllerProvider.notifier).loadInitial();
  }

  void _openDetail(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailScreen(initialPost: post),
      ),
    );
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
      ref
          .read(diaryBookmarksControllerProvider.notifier)
          .replacePost(updated);
      ref.read(diaryTimelineControllerProvider.notifier).updatePost(updated);
    }
  }

  Future<void> _toggleLike(DiaryPost post) async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleLike(post.id, like: !post.liked);
      final fresh =
          await ref.read(diaryRepositoryProvider).fetchPostById(post.id);
      ref
          .read(diaryBookmarksControllerProvider.notifier)
          .replacePost(fresh);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _toggleBookmark(DiaryPost post) async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleBookmark(post.id, bookmark: !post.bookmarked);
      if (post.bookmarked) {
        ref
            .read(diaryBookmarksControllerProvider.notifier)
            .removePost(post.id);
      } else {
        final fresh =
            await ref.read(diaryRepositoryProvider).fetchPostById(post.id);
        ref
            .read(diaryBookmarksControllerProvider.notifier)
            .replacePost(fresh);
      }
    } catch (error) {
      _showError(error);
    }
  }



  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(diaryBookmarksControllerProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔖 ブックマーク', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '保存した投稿をまとめて確認',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          if (state.isLoading && state.posts.isNotEmpty)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.posts.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      children: const [
                        SizedBox(
                          height: 160,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state.errorMessage != null &&
                      state.posts.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      children: [
                        _BookmarksEmptyState(
                          icon: Icons.error_outline,
                          title: '読み込みに失敗しました',
                          message: state.errorMessage!,
                          iconColor: theme.colorScheme.error,
                        ),
                      ],
                    );
                  }
                  if (state.posts.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      children: const [
                        _BookmarksEmptyState(
                          icon: Icons.bookmark_border,
                          title: 'ブックマークはありません',
                          message: '気になる投稿にブックマークを付けるとここに表示されます。',
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    itemCount:
                        state.posts.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final post = state.posts[index];
                      return DiaryPostCard(
                        post: post,
                        onTap: () => _openDetail(post),
                        onToggleLike: () => _toggleLike(post),
                        onToggleBookmark: () => _toggleBookmark(post),
                        onComment: () => _openDetail(post),
                        onQuote: () => _quotePost(post),
                        onEdit: () => _editPost(post),
                        currentUserId: currentUser?.id,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarksEmptyState extends StatelessWidget {
  const _BookmarksEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          icon,
          size: 48,
          color: iconColor ?? theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
