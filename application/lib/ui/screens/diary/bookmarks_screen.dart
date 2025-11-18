import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> _toggleRepost(DiaryPost post) async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleRepost(post.id, repost: !post.reposted);
      final fresh =
          await ref.read(diaryRepositoryProvider).fetchPostById(post.id);
      ref
          .read(diaryBookmarksControllerProvider.notifier)
          .replacePost(fresh);
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
    final state = ref.watch(diaryBookmarksControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ブックマーク'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Builder(
            builder: (context) {
              if (state.isLoading && state.posts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.errorMessage != null && state.posts.isEmpty) {
                return Center(child: Text(state.errorMessage!));
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 16, bottom: 120),
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
                    onToggleRepost: () => _toggleRepost(post),
                    onComment: () => _openDetail(post),
                    onQuote: () => _quotePost(post),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
