import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/translation/data/models/translation_model.dart';
import '../../../features/translation/domain/providers/translation_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../widgets/modern_text_input.dart';
import '../../widgets/typing_keyboard.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../app_spacing.dart';
import '../wordbook/word_form_screen.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  static const int _maxLength = 600;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late final HangulComposer _composer;

  /// 韓国語入力時はカスタムキーボード、日本語入力時はデフォルトキーボード
  late bool _useCustomKeyboard;
  bool _showCustomKeyboard = false;

  @override
  void initState() {
    super.initState();
    _composer = HangulComposer();
    _focusNode.addListener(_onFocusChange);

    // 初期の翻訳方向に応じてキーボードモードを設定
    // 日本語→韓国語: デフォルトキーボード（日本語入力）
    // 韓国語→日本語: カスタムキーボード（韓国語入力）
    final direction = ref.read(translationControllerProvider).direction;
    _useCustomKeyboard = direction == TranslationDirection.koToJa;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _useCustomKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() => _showCustomKeyboard = true);
    }
  }

  void _onKeyboardTextInput(String text) {
    // 最大文字数に達している場合は入力を無視
    if (_composer.text.characters.length >= _maxLength) {
      return;
    }
    _composer.input(text);
    _applyComposerText();
  }

  void _onKeyboardBackspace() {
    _composer.backspace();
    _applyComposerText();
  }

  void _onKeyboardSpace() {
    if (_composer.text.characters.length >= _maxLength) {
      return;
    }
    _composer.addSpace();
    _applyComposerText();
  }

  void _onKeyboardEnter() {
    if (_composer.text.characters.length >= _maxLength) {
      return;
    }
    _composer.addNewLine();
    _applyComposerText();
  }

  void _applyComposerText() {
    final text = _composer.text;
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.characters.length),
    );
    ref.read(translationControllerProvider.notifier).updateInputText(text);
  }

  Future<void> _closeKeyboard() async {
    setState(() {
      _showCustomKeyboard = false;
    });
    _focusNode.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
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
    _composer.loadFromText(_textController.text);
    _applyComposerText();
    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
  }

  void _loadComposerFromText(String text) {
    _composer.loadFromText(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final translationState = ref.watch(translationControllerProvider);

    final directionLabel =
        translationState.direction == TranslationDirection.jaToKo
            ? '日本語 → 韓国語'
            : '韓国語 → 日本語';

    final placeholderText =
        translationState.direction == TranslationDirection.jaToKo
            ? '日本語を入力してください'
            : '한국어를 입력해 주세요';

    return AppPageScaffold(
      title: '翻訳',
      showBackButton: true,
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
                // 言語切り替え
                FCard.raw(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          directionLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(translationControllerProvider.notifier)
                                .toggleDirection();
                            // 新しい方向に応じてキーボードモードを切り替え
                            final newDirection =
                                ref.read(translationControllerProvider).direction;
                            final shouldUseCustom =
                                newDirection == TranslationDirection.koToJa;
                            if (_useCustomKeyboard != shouldUseCustom) {
                              setState(() {
                                _useCustomKeyboard = shouldUseCustom;
                                _showCustomKeyboard = false;
                              });
                              // テキストをクリアしてcomposerをリセット
                              _textController.clear();
                              _composer.loadFromText('');
                              ref
                                  .read(translationControllerProvider.notifier)
                                  .clearInput();
                            }
                          },
                          icon: const Icon(Icons.swap_horiz, size: 24),
                          tooltip: '言語を入れ替え',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 入力欄
                ModernTextInput(
                  controller: _textController,
                  focusNode: _focusNode,
                  placeholder: placeholderText,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: _maxLength,
                  showCharacterCount: true,
                  readOnly: _useCustomKeyboard,
                  showCursor: true,
                  keyboardType: _useCustomKeyboard
                      ? TextInputType.none
                      : TextInputType.multiline,
                  onChanged: (text) {
                    ref
                        .read(translationControllerProvider.notifier)
                        .updateInputText(text);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // 翻訳ボタン
                Row(
                  children: [
                    Expanded(
                      child: FButton(
                        onPress: translationState.isTranslating ||
                                translationState.inputText.trim().isEmpty
                            ? null
                            : () async {
                                await _closeKeyboard();
                                await ref
                                    .read(translationControllerProvider.notifier)
                                    .translate();
                              },
                        child: translationState.isTranslating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('翻訳する'),
                      ),
                    ),
                    if (translationState.inputText.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: () {
                          _textController.clear();
                          _loadComposerFromText('');
                          ref
                              .read(translationControllerProvider.notifier)
                              .clearInput();
                        },
                        icon: const Icon(Icons.clear, size: 20),
                        tooltip: 'クリア',
                      ),
                    ],
                  ],
                ),

                // エラーメッセージ
                if (translationState.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            translationState.errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 翻訳結果
                if (translationState.translatedText != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.translate,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '翻訳結果',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // 韓国語の場合のみ再生ボタンを表示
                            if (translationState.direction ==
                                TranslationDirection.jaToKo)
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(wordAudioServiceProvider.notifier)
                                      .speak(translationState.translatedText!);
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                tooltip: '韓国語を再生',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          translationState.translatedText!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 履歴セクション
                if (translationState.history.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    '直近の翻訳',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...translationState.history.map(
                    (result) => _TranslationHistoryItem(
                      result: result,
                      onTap: () {
                        _textController.text = result.sourceText;
                        _loadComposerFromText(result.sourceText);
                        ref
                            .read(translationControllerProvider.notifier)
                            .restoreFromHistory(result);
                      },
                      onAddToWordbook: () {
                        final String initialWord;
                        final String initialMeaning;

                        if (result.direction == TranslationDirection.jaToKo) {
                          initialWord = result.translatedText;
                          initialMeaning = result.sourceText;
                        } else {
                          initialWord = result.sourceText;
                          initialMeaning = result.translatedText;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => WordFormScreen(
                              initialWord: initialWord,
                              initialMeaning: initialMeaning,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          // カスタムキーボード
          if (_showCustomKeyboard || _focusNode.hasFocus)
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
                showKeys: _useCustomKeyboard && _showCustomKeyboard,
                onClose: _closeKeyboard,
                onSwitchToDefaultKeyboard: _switchToDefaultKeyboard,
                onSwitchToCustomKeyboard: _switchToCustomKeyboard,
              ),
            ),
        ],
      ),
    );
  }
}

/// 翻訳履歴アイテム
class _TranslationHistoryItem extends StatelessWidget {
  const _TranslationHistoryItem({
    required this.result,
    required this.onTap,
    required this.onAddToWordbook,
  });

  final TranslationResult result;
  final VoidCallback onTap;
  final VoidCallback onAddToWordbook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directionIcon = result.direction == TranslationDirection.jaToKo
        ? '日→韓'
        : '韓→日';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                directionIcon,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.sourceText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    result.translatedText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAddToWordbook,
              icon: Icon(
                Icons.add,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              tooltip: '単語帳に追加',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
