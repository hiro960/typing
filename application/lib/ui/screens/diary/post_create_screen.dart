import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/logger.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/data/repositories/diary_repository.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/quick_translation/data/services/speech_recognition_service.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../../features/typing/data/models/typing_settings.dart';
import '../../widgets/diary_post_card.dart';
import '../../widgets/typing_keyboard.dart';
import '../../widgets/ai_gradient_button.dart';
import '../../widgets/modern_text_input.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../app_spacing.dart';
import '../../widgets/premium_feature_gate.dart';
import '../../widgets/sheet_content.dart';
import '../../utils/toast_helper.dart';
import '../../app_theme.dart';

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
  late final SpeechRecognitionService _speechService;

  bool _isSubmitting = false;
  bool _isCorrecting = false;
  bool _isListening = false;
  String _textBeforeSpeech = ''; // 音声入力開始時のテキストを保持
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
    _speechService = SpeechRecognitionService();

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
    final selection = _contentController.selection;
    final currentText = _contentController.text;

    if (selection.isValid) {
      final afterCursor = currentText.substring(selection.end);

      // Composerに入力（Composerはカーソル前のテキストを管理）
      _composer.input(text);
      final composedText = _composer.text;

      final newText = composedText + afterCursor;
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: composedText.characters.length,
        ),
      );
    } else {
      _composer.input(text);
      _applyComposerText();
    }
  }

  void _onKeyboardBackspace() {
    final selection = _contentController.selection;
    final currentText = _contentController.text;

    // 合成中の文字がある場合はComposerで処理
    if (_composer.jamoState.initial != null ||
        _composer.jamoState.medial != null ||
        _composer.jamoState.finalConsonant != null) {
      _composer.backspace();
      final composedText = _composer.text;

      if (selection.isValid) {
        final afterCursor = currentText.substring(selection.end);
        final newText = composedText + afterCursor;

        _contentController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: composedText.characters.length,
          ),
        );
      } else {
        _applyComposerText();
      }
      return;
    }

    // 合成中の文字がない場合はカーソル位置の前の文字を削除
    if (selection.isValid && selection.isCollapsed && selection.start > 0) {
      final cursorPos = selection.start;
      final beforeCursor = currentText.substring(0, cursorPos);
      final afterCursor = currentText.substring(cursorPos);

      // grapheme cluster単位で最後の文字を削除
      final beforeChars = beforeCursor.characters.toList();
      if (beforeChars.isNotEmpty) {
        beforeChars.removeLast();
        final newBeforeCursor = beforeChars.join();
        final newText = newBeforeCursor + afterCursor;

        _contentController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newBeforeCursor.length),
        );
        _composer.loadFromText(newBeforeCursor);
      }
    } else if (selection.isValid && !selection.isCollapsed) {
      // 選択範囲がある場合は選択範囲を削除
      final beforeSelection = currentText.substring(0, selection.start);
      final afterSelection = currentText.substring(selection.end);
      final newText = beforeSelection + afterSelection;

      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
      );
      _composer.loadFromText(beforeSelection);
    }
  }

  void _onKeyboardSpace() {
    final selection = _contentController.selection;
    final currentText = _contentController.text;

    // 合成中の文字を確定してスペースを追加
    _composer.addSpace();

    if (selection.isValid) {
      final afterCursor = currentText.substring(selection.end);
      final composerText = _composer.text;
      final newText = composerText + afterCursor;

      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: composerText.characters.length,
        ),
      );
    } else {
      _applyComposerText();
    }
  }

  void _onKeyboardEnter() {
    final selection = _contentController.selection;
    final currentText = _contentController.text;

    // 合成中の文字を確定して改行を追加
    _composer.addNewLine();

    if (selection.isValid) {
      final afterCursor = currentText.substring(selection.end);
      final composerText = _composer.text;
      final newText = composerText + afterCursor;

      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: composerText.characters.length,
        ),
      );
    } else {
      _applyComposerText();
    }
  }

  Future<void> _onPaste() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text == null || clipboardData!.text!.isEmpty) {
      _showMessage('クリップボードにテキストがありません');
      return;
    }

    final pasteText = clipboardData.text!;
    final selection = _contentController.selection;
    final currentText = _contentController.text;

    // 合成中の文字を確定
    _composer.consumeText();

    if (selection.isValid) {
      final beforeCursor = currentText.substring(0, selection.start);
      final afterCursor = currentText.substring(selection.end);
      final newText = beforeCursor + pasteText + afterCursor;
      final newCursorPos = beforeCursor.length + pasteText.length;

      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursorPos),
      );

      // Composerを新しいカーソル位置までのテキストで更新
      _composer.loadFromText(newText.substring(0, newCursorPos));
    } else {
      final newText = currentText + pasteText;
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      _composer.loadFromText(newText);
    }
  }

  /// カーソル位置が変更された時にComposerを同期
  void _syncComposerWithCursor() {
    final selection = _contentController.selection;
    if (selection.isValid && selection.isCollapsed) {
      final beforeCursor = _contentController.text.substring(0, selection.start);
      _composer.loadFromText(beforeCursor);
    }
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

    // カーソル位置を保持してComposerを同期
    final selection = _contentController.selection;
    if (selection.isValid && selection.isCollapsed) {
      final beforeCursor = _contentController.text.substring(0, selection.start);
      _composer.loadFromText(beforeCursor);
    } else {
      _composer.loadFromText(_contentController.text);
    }

    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
  }

  Future<void> _toggleSpeechInput() async {
    if (_isListening) {
      await _stopSpeechInput();
    } else {
      await _startSpeechInput();
    }
  }

  Future<void> _startSpeechInput() async {
    // 音声入力開始時のテキストを保存
    _textBeforeSpeech = _contentController.text;
    setState(() => _isListening = true);

    await _speechService.startListening(
      onResult: (text, isFinal) {
        if (!mounted) return;
        if (text.isNotEmpty) {
          // 開始時のテキスト + 認識テキストで更新（重複防止）
          final newText = _textBeforeSpeech.isEmpty
              ? text
              : '$_textBeforeSpeech $text';
          _contentController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );

          if (isFinal) {
            // 確定時：Composerを更新し、次の入力に備えて基準テキストを更新
            _composer.loadFromText(newText);
            _textBeforeSpeech = newText;
            setState(() => _isListening = false);
          }
        }
      },
    );

    if (_speechService.status == SpeechRecognitionStatus.error) {
      if (mounted) {
        setState(() => _isListening = false);
        _showMessage('音声入力を開始できませんでした: ${_speechService.errorMessage}');
      }
    }
  }

  Future<void> _stopSpeechInput() async {
    await _speechService.stopListening();
    if (mounted) {
      // 停止時、現在のテキストで確定
      _composer.loadFromText(_contentController.text);
      setState(() => _isListening = false);
    }
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
      _showMessage(_isEditing ? '投稿を更新しました' : '投稿を公開しました');
      Navigator.of(context).pop(post);
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
    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => SheetContent(
        children: [
          SheetOption(
            label: '全体公開',
            icon: Iconsax.global,
            style: _visibility == 'public' ? FButtonStyle.primary() : FButtonStyle.outline(),
            onPress: () {
              setState(() => _visibility = 'public');
              Navigator.of(context).pop();
            },
          ),
          SheetOption(
            label: 'フォロワーのみ',
            icon: Iconsax.people,
            style: _visibility == 'followers' ? FButtonStyle.primary() : FButtonStyle.outline(),
            onPress: () {
              setState(() => _visibility = 'followers');
              Navigator.of(context).pop();
            },
          ),
          SheetOption(
            label: '下書き',
            icon: Iconsax.lock,
            style: _visibility == 'private' ? FButtonStyle.primary() : FButtonStyle.outline(),
            onPress: () {
              setState(() => _visibility = 'private');
              Navigator.of(context).pop();
            },
          ),
        ],
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
    ToastHelper.show(context, message);
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

    // グローバル設定を取得
    final typingSettingsAsync = ref.watch(typingSettingsProvider);
    final globalUseCustomKeyboard = typingSettingsAsync.value?.useCustomKeyboard ?? true;

    // グローバル設定がOFFの場合はカスタムキーボードを無効化
    final effectiveUseCustomKeyboard = globalUseCustomKeyboard && _useCustomKeyboard;

    final isOverLimit = remaining < 0;
    final remainingLabel = isOverLimit
        ? '${remaining.abs()}文字オーバー'
        : '残り$remaining文字';

    return AppPageScaffold(
      title: _isEditing ? '投稿を編集' : '新規投稿',
      showBackButton: true,
      onBack: () => Navigator.of(context).maybePop(),
      actions: [
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
      childPad: false,
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
                      readOnly: effectiveUseCustomKeyboard,
                      showCursor: true,
                      keyboardType:
                          effectiveUseCustomKeyboard ? TextInputType.none : TextInputType.multiline,
                      showCharacterCount: false,
                      onChanged: (_) => setState(() {}),
                      onTap: effectiveUseCustomKeyboard ? _syncComposerWithCursor : null,
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
                    Row(
                      children: [
                        _ComposerActionButton(
                          icon: Iconsax.image,
                          label: '画像を追加',
                          onTap: _pickImages,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        if (_quotedPostId != null && !_isEditing) ...[
                          _ComposerActionButton(
                            icon: Iconsax.close_circle,
                            label: '引用を削除',
                            onTap: _removeQuote,
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                        // 公開範囲設定ボタン
                        _ComposerActionButton(
                          icon: _visibilityIcon(_visibility),
                          label: _visibilityLabel(_visibility),
                          onTap: _showVisibilitySheet,
                        ),
                        const Spacer(),
                        // 音声入力ボタン（右寄せ、テキストフィールド選択時のみ表示）
                        if (_focusNode.hasFocus || _showCustomKeyboard || _isListening)
                          _SpeechInputButton(
                            isListening: _isListening,
                            onTap: _toggleSpeechInput,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: FButton(
                    onPress: _isSubmitting ||
                            _contentController.text.trim().isEmpty ||
                            remaining < 0
                        ? null
                        : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEditing ? '更新する' : '投稿する'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
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
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Iconsax.magic_star, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'AI先生のアドバイス',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
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
                        Icon(Iconsax.warning_2, color: theme.colorScheme.error),
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
          // グローバル設定がONの場合のみカスタムキーボードを表示
          if (globalUseCustomKeyboard && (_showCustomKeyboard || _focusNode.hasFocus))
            SafeArea(
              top: false,
              left: false,
              right: false,
              child: TypingKeyboard(
                onTextInput: _onKeyboardTextInput,
                onBackspace: _onKeyboardBackspace,
                onSpace: _onKeyboardSpace,
                onEnter: _onKeyboardEnter,
                enableHaptics: true,
                enableSound: false,
                showToolbar: true,
                showKeys: effectiveUseCustomKeyboard && _showCustomKeyboard,
                onClose: _closeKeyboard,
                onSwitchToDefaultKeyboard: _switchToDefaultKeyboard,
                onSwitchToCustomKeyboard: _switchToCustomKeyboard,
                onPaste: _onPaste,
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
        return Iconsax.lock;
      case 'followers':
        return Iconsax.people;
      case 'public':
      default:
        return Iconsax.global;
    }
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
                  child: const Icon(Iconsax.close_circle, color: Colors.white, size: 16),
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

class _SpeechInputButton extends StatelessWidget {
  const _SpeechInputButton({
    required this.isListening,
    required this.onTap,
  });

  final bool isListening;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isListening) {
      return FButton(
        onPress: onTap,
        style: FButtonStyle.destructive(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.stop, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'もう一度押して停止',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return FButton.icon(
      onPress: onTap,
      style: FButtonStyle.secondary(),
      child: Icon(
        Iconsax.microphone,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
