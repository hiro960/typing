import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/page_state_views.dart';
import 'post_create_screen.dart';

class DraftsScreen extends ConsumerStatefulWidget {
  const DraftsScreen({super.key});

  @override
  ConsumerState<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends ConsumerState<DraftsScreen> {
  final _scrollController = ScrollController();
  List<DiaryPost> _drafts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDrafts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final repository = ref.read(diaryRepositoryProvider);
      final page = await repository.fetchPosts(
        feed: DiaryFeedType.recommended, // Ignored by backend when visibility=private
        visibility: 'private',
      );
      setState(() {
        _drafts = page.posts;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return AppPageScaffold(
      title: '下書き',
      showBackButton: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? PageErrorView(
                  message: _error,
                  onRetry: _loadDrafts,
                )
              : _drafts.isEmpty
                  ? const PageEmptyView(
                      icon: Icons.edit_document,
                      title: '下書きはありません',
                    )
                  : ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      itemCount: _drafts.length,
      itemBuilder: (context, index) {
        final post = _drafts[index];
        return DiaryPostCard(
          post: post,
          onTap: () => _openEditor(post),
          // Disable interactions for drafts
          onToggleLike: () {},
          onToggleBookmark: () {},
          onComment: () {},
          onQuote: () {},
          onEdit: () => _openEditor(post),
          currentUserId: currentUser?.id,
        );
      },
    ),
    );
  }

  void _openEditor(DiaryPost post) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostCreateScreen(initialPost: post),
        fullscreenDialog: true,
      ),
    );
    _loadDrafts();
  }
}
