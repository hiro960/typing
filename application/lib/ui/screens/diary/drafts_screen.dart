import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/diary/data/repositories/diary_repository.dart'; // Add this line
import '../../widgets/diary_post_card.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('下書き'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final currentUser = ref.watch(currentUserProvider);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('エラーが発生しました: $_error'));
    }
    if (_drafts.isEmpty) {
      return const Center(child: Text('下書きはありません'));
    }
    return ListView.builder(
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
