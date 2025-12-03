import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/page_state_views.dart';
import '../../utils/toast_helper.dart';
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
    ToastHelper.showError(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryBookmarksControllerProvider);
    final currentUser = ref.watch(currentUserProvider);

    return AppPageScaffold(
      title: 'ブックマーク',
      titleIcon: Icons.bookmark_outline,
      showBackButton: true,
      onRefresh: _refresh,
      child: Builder(
        builder: (context) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.posts.isEmpty) {
            return PageErrorView(
              message: state.errorMessage,
              onRetry: _refresh,
            );
          }
          if (state.posts.isEmpty) {
            return const PageEmptyView(
              icon: Icons.bookmark_border,
              title: 'ブックマークはありません',
              description: '気になる投稿にブックマークを付けるとここに表示されます。',
            );
          }
          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            itemCount: state.posts.length + (state.isLoadingMore ? 1 : 0),
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
    );
  }
}

