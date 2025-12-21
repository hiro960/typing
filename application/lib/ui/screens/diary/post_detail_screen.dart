import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/utils/logger.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../../features/diary/data/models/diary_comment.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/typing_keyboard.dart';
import '../../widgets/sheet_content.dart';
import 'post_create_screen.dart';
import '../../app_spacing.dart';
import '../../widgets/modern_text_input.dart';

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
  final _commentFocusNode = FocusNode();
  late final HangulComposer _composer;
  bool _isSubmitting = false;
  bool _useCustomKeyboard = true;
  bool _showCustomKeyboard = false;

  @override
  void initState() {
    super.initState();
    _post = widget.initialPost;
    _composer = HangulComposer()..loadFromText(_commentController.text);
    _commentFocusNode.addListener(_onFocusChange);
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
    _commentFocusNode.dispose();
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

  void _onFocusChange() {
    if (!_commentFocusNode.hasFocus) {
      setState(() => _showCustomKeyboard = false);
      return;
    }
    if (_useCustomKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _composer.loadFromText(_commentController.text);
      _applyComposerText();
      setState(() => _showCustomKeyboard = true);
    } else {
      setState(() => _showCustomKeyboard = false);
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
      ToastHelper.showError(context, error);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _togglePostLike() async {
    final settings = ref.read(typingSettingsProvider).value;
    if (settings?.hapticsEnabled ?? true) {
      HapticFeedback.lightImpact();
    }

    // オプティミスティック更新: 即座にローカル状態を更新
    final previousPost = _post;
    final newLiked = !_post.liked;
    final newLikesCount = newLiked
        ? _post.likesCount + 1
        : (_post.likesCount - 1).clamp(0, 1 << 31);
    setState(() {
      _post = _post.copyWith(liked: newLiked, likesCount: newLikesCount);
    });

    try {
      await ref
          .read(diaryTimelineControllerProvider.notifier)
          .toggleLike(previousPost.id, like: newLiked);
    } catch (error) {
      // エラー時はロールバック
      if (mounted) {
        setState(() => _post = previousPost);
        ToastHelper.showError(context, error);
      }
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
      ToastHelper.showError(context, error);
    }
  }

  void _onKeyboardTextInput(String text) {
    _composer.input(text);
    _applyComposerText();
  }

  void _onKeyboardBackspace() {
    _composer.backspace();
    _applyComposerText();
  }

  void _onKeyboardSpace() {
    _composer.addSpace();
    _applyComposerText();
  }

  void _onKeyboardEnter() {
    _composer.addNewLine();
    _applyComposerText();
  }

  Future<void> _closeKeyboard() async {
    setState(() {
      _showCustomKeyboard = false;
    });
    _commentFocusNode.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _applyComposerText() {
    final text = _composer.text;
    _commentController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.characters.length),
    );
  }

  void _switchToDefaultKeyboard() {
    setState(() {
      _useCustomKeyboard = false;
      _showCustomKeyboard = false;
    });
    _commentFocusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  Future<void> _switchToCustomKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    _commentFocusNode.requestFocus();
    _composer.loadFromText(_commentController.text);
    _applyComposerText();
    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
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
    final confirm = await showFDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: const Text('投稿を削除'),
        body: const Text('この投稿を削除しますか？'),
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
      ToastHelper.show(context, '投稿を削除しました');
      Navigator.of(context).pop();
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
    final value = await showFSheet<String>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => SheetContent(
        children: [
          if (isMine) ...[
            SheetOption(
              label: '編集',
              icon: Iconsax.edit,
              onPress: () => Navigator.of(context).pop('edit'),
            ),
            SheetOption(
              label: '削除',
              icon: Iconsax.trash,
              onPress: () => Navigator.of(context).pop('delete'),
            ),
          ],
          SheetOption(
            label: '引用する',
            icon: Iconsax.quote_up,
            onPress: () => Navigator.of(context).pop('quote'),
          ),
          SheetOption(
            label: '通報',
            icon: Iconsax.flag,
            onPress: () => Navigator.of(context).pop('report'),
          ),
          SheetOption(
            label: 'ブロック',
            icon: Iconsax.shield_slash,
            onPress: () => Navigator.of(context).pop('block'),
          ),
        ],
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
    final confirm = await showFDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: const Text('ブロック'),
        body: Text('${_post.user.displayName}さんをブロックしますか？'),
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
      ToastHelper.show(context, '${_post.user.displayName}さんをブロックしました');
      Navigator.of(context).pop();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _reportPost() async {
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
            postId: _post.id,
            reason: selected,
          );
      if (!mounted) return;
      ToastHelper.show(context, '投稿を通報しました');
    } catch (error) {
      _showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(postCommentsControllerProvider(_post.id));
    final currentUser = ref.watch(currentUserProvider);

    return AppPageScaffold(
      title: '投稿',
      showBackButton: true,
      actions: [
        FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: _refreshPost,
          child: const Icon(Iconsax.refresh),
        ),
        FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: () => _showMenu(currentUser?.id == _post.user.id),
          child: const Icon(Iconsax.more),
        ),
      ],
      childPad: false,
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
                padding: EdgeInsets.fromLTRB(
                  AppPadding.homePage.left,
                  AppSpacing.lg,
                  AppPadding.homePage.right,
                  80,
                ),
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
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final commentOffset =
                      _showInitialLoader(commentsState) ? 1 : 0;
                  final commentIndex = index - 1 - commentOffset;
                  if (commentIndex >= commentsState.comments.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final comment = commentsState.comments[commentIndex];
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: _CommentTile(
                      comment: comment,
                      isMine: currentUser?.id == comment.user.id,
                      onToggleLike: () => _toggleCommentLike(comment),
                      onDelete: () => _deleteComment(comment),
                    ),
                  );
                },
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final horizontalOffset =
                      (screenWidth - constraints.maxWidth) / 2;

                  return Transform.translate(
                    offset: Offset(-horizontalOffset, 0),
                    child: SizedBox(
                      width: screenWidth,
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: AppSpacing.sm,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ModernTextInput(
                                      controller: _commentController,
                                      focusNode: _commentFocusNode,
                                      placeholder: 'コメントを入力',
                                      minLines: 1,
                                      maxLines: 4,
                                      enabled: !_isSubmitting,
                                      readOnly: _useCustomKeyboard,
                                      showCursor: true,
                                      keyboardType: _useCustomKeyboard
                                          ? TextInputType.none
                                          : TextInputType.multiline,
                                      onTap: _useCustomKeyboard
                                          ? () {
                                              _composer.loadFromText(
                                                  _commentController.text);
                                              _applyComposerText();
                                            }
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _isSubmitting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : FButton.icon(
                                          style: FButtonStyle.ghost(),
                                          onPress: _addComment,
                                          child: const Icon(Iconsax.send_1),
                                        ),
                                ],
                              ),
                            ),
                            if (_showCustomKeyboard || _commentFocusNode.hasFocus)
                              TypingKeyboard(
                                onTextInput: _onKeyboardTextInput,
                                onBackspace: _onKeyboardBackspace,
                                onSpace: _onKeyboardSpace,
                                onEnter: _onKeyboardEnter,
                                enableHaptics: true,
                                enableSound: false,
                                showToolbar: true,
                                showKeys: _useCustomKeyboard && _showCustomKeyboard,
                                onClose: _closeKeyboard,
                                onSwitchToDefaultKeyboard: _switchToDefaultKeyboard,
                                onSwitchToCustomKeyboard: _switchToCustomKeyboard,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCommentLike(DiaryComment comment) async {
    final settings = ref.read(typingSettingsProvider).value;
    if (settings?.hapticsEnabled ?? true) {
      HapticFeedback.lightImpact();
    }
    try {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .toggleCommentLike(
            comment.id,
            like: !comment.liked,
          );
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ToastHelper.showError(context, error);
  }

  Future<void> _deleteComment(DiaryComment comment) async {
    try {
      await ref
          .read(postCommentsControllerProvider(_post.id).notifier)
          .deleteComment(comment.id);
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, error);
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
                    child: const Icon(Iconsax.trash),
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
                    Iconsax.heart,
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
