import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/logger.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/typing_keyboard.dart';
import '../../widgets/ai_gradient_button.dart';
import '../../widgets/modern_text_input.dart';
import '../../app_spacing.dart';
import '../../widgets/premium_feature_gate.dart';

class PostCreateScreen extends ConsumerStatefulWidget {
  const PostCreateScreen({super.key, this.initialPost, this.quotedPost});

  final DiaryPost? initialPost;
  final DiaryPost? quotedPost;

  @override
  ConsumerState<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends ConsumerState<PostCreateScreen> {
  late final _contentController = _HashtagEditingController();
  final _focusNode = FocusNode();
  final _picker = ImagePicker();
  final List<_ComposerImage> _images = [];
  late final HangulComposer _composer;

  bool _isSubmitting = false;
  bool _isCorrecting = false;
  String? _aiResult;
  String? _aiError;

  Future<void> _correctText() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (!(user?.isPremiumUser ?? false)) {
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              const PremiumFeatureGateScreen(focusFeature: 'AI先生の添削'),
        ),
      );
      return;
    }

    setState(() {
      _isCorrecting = true;
      _aiResult = null;
      _aiError = null;
    });

    try {
      final service = ref.read(aiCorrectionServiceProvider);
      final result = await service.correctText(content);
      if (!mounted) return;

      setState(() {
        _aiResult = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _aiError = '添削に失敗しました。もう一度お試しください。($e)';
      });
    } finally {
      if (mounted) {
        setState(() => _isCorrecting = false);
      }
    }
  }

  String _visibility = 'public';
  DiaryPost? _editingPost;
  DiaryQuotedPost? _quotedPost;
  String? _quotedPostId;
  bool _useCustomKeyboard = true;
  bool _showCustomKeyboard = false;

  static const _maxLength = 600;

  @override
  void initState() {
    super.initState();
    _editingPost = widget.initialPost;
    _contentController.text = _editingPost?.content ?? '';

    _visibility = _editingPost?.visibility ?? _defaultVisibility();
    _quotedPostId = _editingPost?.quotedPostId ?? widget.quotedPost?.id;
    _quotedPost =
        _editingPost?.quotedPost ?? _quotedFromPost(widget.quotedPost);

    if (_editingPost?.imageUrls.isNotEmpty ?? false) {
      _images.addAll(_editingPost!.imageUrls.map(_ComposerImage.remote));
    }

    _composer = HangulComposer();
    _composer.loadFromText(_contentController.text);

    _contentController.addListener(() => setState(() {}));
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _useCustomKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() => _showCustomKeyboard = true);
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
    _focusNode.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _applyComposerText() {
    final text = _composer.text;
    _contentController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.characters.length),
    );
  }

  void _switchToDefaultKeyboard() {
    setState(() {
      _useCustomKeyboard = false;
      _showCustomKeyboard = false;
    });
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  Future<void> _switchToCustomKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    _focusNode.requestFocus();
    _composer.loadFromText(_contentController.text);
    _applyComposerText();
    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _defaultVisibility() {
    final user = ref.read(currentUserProvider);
    return user?.settings.postDefaultVisibility ?? 'public';
  }

  DiaryQuotedPost? _quotedFromPost(DiaryPost? post) {
    if (post == null) return null;
    return DiaryQuotedPost(
      id: post.id,
      content: post.content,
      user: post.user,
      imageUrls: post.imageUrls,
      tags: post.tags,
      createdAt: post.createdAt,
    );
  }

  List<String> get _hashtags => _extractHashtags(_contentController.text);

  bool get _isEditing => _editingPost != null;

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showMessage('投稿内容を入力してください');
      return;
    }
    if (content.characters.length > _maxLength) {
      _showMessage('投稿は$_maxLength文字以内で入力してください');
      return;
    }

    setState(() => _isSubmitting = true);
    final repository = ref.read(diaryRepositoryProvider);
    final timeline = ref.read(diaryTimelineControllerProvider.notifier);

    try {
      final imageUrls = await _uploadImages(repository);
      DiaryPost post;
      if (_isEditing) {
        post = await repository.updatePost(
          _editingPost!.id,
          content: content,
          imageUrls: imageUrls,
          visibility: _visibility,
          tags: _hashtags,
        );
        timeline.updatePost(post);
      } else {
        post = await repository.createPost(
          content: content,
          imageUrls: imageUrls,
          visibility: _visibility,
          tags: _hashtags,

          quotedPostId: _quotedPostId,
        );
        timeline.prependPost(post);
      }
      if (!mounted) return;
      Navigator.of(context).pop(post);
      _showMessage(_isEditing ? '投稿を更新しました' : '投稿を公開しました');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to submit post',
        tag: 'PostCreateScreen',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        _showMessage(error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<List<String>> _uploadImages(DiaryRepository repository) async {
    final urls = <String>[];
    for (final image in _images) {
      if (image.url != null) {
        urls.add(image.url!);
        continue;
      }
      final file = image.file;
      if (file == null) {
        continue;
      }
      try {
        final uploaded = await repository.uploadPostImage(File(file.path));
        urls.add(uploaded);
      } catch (error) {
        _showMessage('画像のアップロードに失敗しました: $error');
        rethrow;
      }
    }
    return urls;
  }

  List<String> _extractHashtags(String text) {
    final regex = RegExp(r'#([^\s#]+)');
    final matches = regex.allMatches(text);
    final tags = <String>{};
    for (final match in matches) {
      final raw = match.group(1);
      if (raw == null) continue;
      var normalized = raw.trim();
      if (normalized.isEmpty) continue;
      if (RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(normalized)) {
        normalized = normalized.toLowerCase();
      }
      if (normalized.length > 40) {
        normalized = normalized.substring(0, 40);
      }
      tags.add(normalized);
    }
    return tags.toList();
  }

  void _showVisibilitySheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _VisibilityTile(
              label: '全体公開',
              description: '全てのユーザーに公開されます',
              selected: _visibility == 'public',
              onTap: () {
                setState(() => _visibility = 'public');
                Navigator.of(context).pop();
              },
              icon: Icons.public,
            ),
            _VisibilityTile(
              label: 'フォロワーのみ',
              description: 'フォロワーのみに公開されます',
              selected: _visibility == 'followers',
              onTap: () {
                setState(() => _visibility = 'followers');
                Navigator.of(context).pop();
              },
              icon: Icons.people_outline,
            ),
            _VisibilityTile(
              label: '下書き',
              description: '自分のみが閲覧できます',
              selected: _visibility == 'private',
              onTap: () {
                setState(() => _visibility = 'private');
                Navigator.of(context).pop();
              },
              icon: Icons.lock_outline,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    if (_images.length >= 4) {
      _showMessage('画像は最大4枚まで添付できます');
      return;
    }
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: 90,
        maxWidth: 2048,
      );
      if (picked.isEmpty) return;
      final availableSlots = 4 - _images.length;
      setState(() {
        _images.addAll(picked.take(availableSlots).map(_ComposerImage.local));
      });
    } catch (error) {
      _showMessage('画像の取得に失敗しました: $error');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeQuote() {
    setState(() {
      _quotedPost = null;
      _quotedPostId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremiumUser = ref.watch(currentUserProvider)?.isPremiumUser ?? false;
    final remaining = _maxLength - _contentController.text.characters.length;

    final isOverLimit = remaining < 0;
    final remainingLabel = isOverLimit
        ? '${remaining.abs()}文字オーバー'
        : '残り$remaining文字';

    return FScaffold(
      header: FHeader.nested(
        title: Text(
          _isEditing ? '投稿を編集' : '新規投稿',
          style: theme.textTheme.headlineSmall,
        ),
        suffixes: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Text(
              remainingLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isOverLimit
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
              ),
            ),
          ),
          FButton(
            onPress: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? '更新' : '投稿'),
          ),
        ],
        prefixes: [
          FHeaderAction.x(onPress: () => Navigator.of(context).maybePop()),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppPadding.homePage.left,
                AppSpacing.md,
                AppPadding.homePage.right,
                AppSpacing.xl,
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ModernTextInput(
                      controller: _contentController,
                      focusNode: _focusNode,
                      minLines: 10,
                      maxLines: null,
                      placeholder: 'いまどうしてる？',
                      enabled: !_isSubmitting,
                      readOnly: _useCustomKeyboard,
                      showCursor: true,
                      keyboardType:
                          _useCustomKeyboard ? TextInputType.none : TextInputType.multiline,
                      showCharacterCount: false,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_hashtags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text('ハッシュタグ', style: theme.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _hashtags
                            .map((tag) => Chip(label: Text('#$tag')))
                            .toList(),
                      ),
                    ],
                    if (_images.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _ImageGrid(images: _images, onRemove: _removeImage),
                    ],
                    if (_quotedPost != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      DiaryQuotedPostCard(quotedPost: _quotedPost!),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        _ComposerActionButton(
                          icon: Icons.image_outlined,
                          label: '画像を追加',
                          onTap: _pickImages,
                        ),
                        if (_quotedPostId != null && !_isEditing)
                          _ComposerActionButton(
                            icon: Icons.close,
                            label: '引用を削除',
                            onTap: _removeQuote,
                          ),
                        // 公開範囲設定ボタン
                        _ComposerActionButton(
                          icon: _visibilityIcon(_visibility),
                          label: _visibilityLabel(_visibility),
                          onTap: _showVisibilitySheet,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AiGradientButton(
                  label: 'AI先生の添削',
                  loadingLabel: '添削中...',
                  enabled: _contentController.text.trim().isNotEmpty && !_isSubmitting && !_isCorrecting,
                  loading: _isCorrecting,
                  onTap: isPremiumUser
                      ? _correctText
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PremiumFeatureGateScreen(
                                focusFeature: 'AI先生の添削',
                              ),
                            ),
                          );
                        },
                ),
                if (_aiResult != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4facfe).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, size: 20, color: Color(0xFF4facfe)),
                            const SizedBox(width: 8),
                            Text(
                              'AI先生のアドバイス',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF4facfe),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _aiResult!,
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_aiError != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: theme.colorScheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _aiError!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: SafeArea(
              child: ColoredBox(
                color: theme.colorScheme.surface,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          FButton.icon(
                            style: FButtonStyle.ghost(),
                            onPress: _useCustomKeyboard
                                ? _switchToDefaultKeyboard
                                : _switchToCustomKeyboard,
                            child: const Icon(Icons.keyboard, size: 18),
                          ),
                          const Spacer(),
                          if (_showCustomKeyboard || _focusNode.hasFocus)
                            FButton(
                              style: FButtonStyle.ghost(),
                              onPress: _closeKeyboard,
                              child: const Text('閉じる'),
                            ),
                        ],
                      ),
                    ),
                    if (_useCustomKeyboard && _showCustomKeyboard)
                      TypingKeyboard(
                        onTextInput: _onKeyboardTextInput,
                        onBackspace: _onKeyboardBackspace,
                        onSpace: _onKeyboardSpace,
                        onEnter: _onKeyboardEnter,
                        enableHaptics: true,
                        enableSound: false,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _visibilityLabel(String visibility) {
    switch (visibility) {
      case 'private':
        return '下書き（自分のみ）';
      case 'followers':
        return 'フォロワーのみ';
      case 'public':
      default:
        return '全体公開';
    }
  }

  IconData _visibilityIcon(String visibility) {
    switch (visibility) {
      case 'private':
        return Icons.lock_outline;
      case 'followers':
        return Icons.people_outline;
      case 'public':
      default:
        return Icons.public;
    }
  }
}

class _VisibilityTile extends StatelessWidget {
  const _VisibilityTile({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
    required this.icon,
  });

  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FItem(
      prefix: Icon(icon),
      title: Text(label),
      subtitle: Text(description),
      suffix: selected
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
      onPress: onTap,
    );
  }
}

class _ComposerActionButton extends StatelessWidget {
  const _ComposerActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FButton.icon(
      onPress: onTap,
      style: FButtonStyle.secondary(),
      child: Icon(icon),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.images, required this.onRemove});

  final List<_ComposerImage> images;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = images.length == 1 ? 1 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final image = images[index];
        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.url != null
                    ? CachedNetworkImage(
                        imageUrl: image.url!,
                        fit: BoxFit.cover,
                      )
                    : Image.file(File(image.file!.path), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ComposerImage {
  const _ComposerImage.local(this.file) : url = null;
  const _ComposerImage.remote(this.url) : file = null;

  final XFile? file;
  final String? url;
}

class _HashtagEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = Theme.of(context);
    final children = <InlineSpan>[];
    final pattern = RegExp(r'#([^\s#]+)');
    var currentIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > currentIndex) {
        children.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: style,
          ),
        );
      }

      children.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      children.add(TextSpan(text: text.substring(currentIndex), style: style));
    }

    return TextSpan(style: style, children: children);
  }
}
