import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../core/utils/logger.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_comment.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/user_avatar.dart';
import 'post_create_screen.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.initialPost});

  final DiaryPost initialPost;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late DiaryPost _post;
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _post = widget.initialPost;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .loadInitial();
      await _refreshPost();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _refreshPost() async {
    try {
      final fresh = await ref.read(diaryRepositoryProvider).fetchPostById(_post.id);
      if (!mounted) return;
      setState(() => _post = fresh);
      ref.read(diaryTimelineControllerProvider.notifier).updatePost(fresh);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to refresh post',
        tag: 'PostDetailScreen',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .loadMore();
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .addComment(text);
      _commentController.clear();
      if (!mounted) return;
      FocusScope.of(context).unfocus();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _togglePostLike() async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleLike(_post.id, like: !_post.liked);
      await _refreshPost();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _toggleBookmark() async {
    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleBookmark(_post.id, bookmark: !_post.bookmarked);
      await _refreshPost();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }



  Future<void> _editPost() async {
    final updated = await Navigator.of(context).push<DiaryPost>(
      MaterialPageRoute(
        builder: (_) => PostCreateScreen(initialPost: _post),
        fullscreenDialog: true,
      ),
    );
    if (updated != null) {
      setState(() => _post = updated);
      ref.read(diaryTimelineControllerProvider.notifier).updatePost(updated);
    }
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('投稿を削除'),
        content: const Text('この投稿を削除しますか？'),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () => Navigator.of(context).pop(true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(diaryRepositoryProvider).deletePost(_post.id);
      ref.read(diaryTimelineControllerProvider.notifier).removePost(_post.id);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿を削除しました')),
      );
    } catch (error) {
      _showError(error);
    }
  }

  void _quotePost() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostCreateScreen(quotedPost: _post),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _showMenu(bool isMine) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMine) ...[
              FTile(
                prefix: const Icon(Icons.edit_outlined),
                title: const Text('編集'),
                onPress: () => Navigator.of(context).pop('edit'),
              ),
              FTile(
                prefix: const Icon(Icons.delete_outline),
                title: const Text('削除'),
                onPress: () => Navigator.of(context).pop('delete'),
              ),
            ],
            FTile(
              prefix: const Icon(Icons.format_quote_outlined),
              title: const Text('引用する'),
              onPress: () => Navigator.of(context).pop('quote'),
            ),
            FTile(
              prefix: const Icon(Icons.flag_outlined),
              title: const Text('通報'),
              onPress: () => Navigator.of(context).pop('report'),
            ),
            FTile(
              prefix: const Icon(Icons.block_outlined),
              title: const Text('ブロック'),
              onPress: () => Navigator.of(context).pop('block'),
            ),
          ],
        ),
      ),
    );

    if (value == null) return;

    switch (value) {
      case 'edit':
        _editPost();
        break;
      case 'delete':
        _deletePost();
        break;
      case 'quote':
        _quotePost();
        break;
      case 'report':
        _reportPost();
        break;
      case 'block':
        _blockAuthor();
        break;
    }
  }

  Future<void> _blockAuthor() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ブロック'),
        content: Text('${_post.user.displayName}さんをブロックしますか？'),
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
      await ref.read(diaryRepositoryProvider).blockUser(_post.user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_post.user.displayName}さんをブロックしました')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _reportPost() async {
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
            postId: _post.id,
            reason: selected,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投稿を通報しました')),
      );
    } catch (error) {
      _showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(postCommentsControllerProvider(_post.id));
    final currentUser = ref.watch(currentUserProvider);

    return FScaffold(
      header: FHeader.nested(
        title: const Text('投稿'),
        suffixes: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: _refreshPost,
            child: const Icon(Icons.refresh),
          ),
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => _showMenu(currentUser?.id == _post.user.id),
            child: const Icon(Icons.more_vert),
          ),
        ],
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _refreshPost();
                await ref
                    .read(postCommentsControllerProvider(_post.id).notifier)
                    .loadInitial();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                itemCount: _itemCount(commentsState),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return DiaryPostCard(
                      post: _post,
                      onTap: () {},
                      onToggleLike: _togglePostLike,
                      onToggleBookmark: _toggleBookmark,
                      onComment: () {},
                      onQuote: _quotePost,
                      onBlock: _blockAuthor,
                      onReport: _reportPost,
                      onEdit: _editPost,
                      currentUserId: currentUser?.id,
                    );
                  }
                  if (_showInitialLoader(commentsState) &&
                      index == 1 &&
                      commentsState.comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final commentOffset =
                      _showInitialLoader(commentsState) ? 1 : 0;
                  final commentIndex = index - 1 - commentOffset;
                  if (commentIndex >= commentsState.comments.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final comment = commentsState.comments[commentIndex];
                  return _CommentTile(
                    comment: comment,
                    isMine: currentUser?.id == comment.user.id,
                    onToggleLike: () => _toggleCommentLike(comment),
                    onDelete: () => _deleteComment(comment),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: FTextField(
                      controller: _commentController,
                      hint: 'コメントを入力',
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : FButton.icon(
                          style: FButtonStyle.ghost(),
                          onPress: _addComment,
                          child: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCommentLike(DiaryComment comment) async {
    try {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .toggleCommentLike(
            comment.id,
            like: !comment.liked,
          );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  Future<void> _deleteComment(DiaryComment comment) async {
    try {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .deleteComment(comment.id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  bool _showInitialLoader(DiaryCommentsState state) =>
      state.isLoading && state.comments.isEmpty;

  int _itemCount(DiaryCommentsState state) {
    final base = 1 + state.comments.length;
    final initialLoader = _showInitialLoader(state) ? 1 : 0;
    final loadMore = state.isLoadingMore ? 1 : 0;
    return base + initialLoader + loadMore;
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.isMine,
    required this.onToggleLike,
    required this.onDelete,
  });

  final DiaryComment comment;
  final bool isMine;
  final VoidCallback onToggleLike;
  final VoidCallback onDelete;

  String _relativeTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      '@${comment.user.username}',
      _relativeTime(comment.createdAt),
    ].where((value) => value.isNotEmpty).join(' ・ ');

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  displayName: comment.user.displayName,
                  imageUrl: comment.user.profileImageUrl,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user.displayName,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMine)
                  FButton.icon(
                    style: FButtonStyle.ghost(),
                    onPress: onDelete,
                    child: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(comment.content),
            const SizedBox(height: 12),
            Row(
              children: [
                FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: onToggleLike,
                  child: Icon(
                    comment.liked ? Icons.favorite : Icons.favorite_border,
                    color:
                        comment.liked ? theme.colorScheme.primary : null,
                  ),
                ),
                Text('${comment.likesCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
