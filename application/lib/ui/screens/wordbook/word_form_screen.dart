import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/typing_keyboard.dart';

class WordFormScreen extends ConsumerStatefulWidget {
  const WordFormScreen({
    super.key,
    this.word,
    this.initialWord,
    this.initialMeaning,
  });

  final Word? word;
  final String? initialWord;
  final String? initialMeaning;

  bool get isEditing => word != null;

  @override
  ConsumerState<WordFormScreen> createState() => _WordFormScreenState();
}

class _WordFormScreenState extends ConsumerState<WordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _wordController;
  late final TextEditingController _meaningController;
  late final TextEditingController _exampleController;
  late final TextEditingController _tagsController;
  late TextEditingController _activeComposerController;
  late WordCategory _category;
  late WordStatus _status;
  late final FocusNode _wordFocusNode;
  late final FocusNode _meaningFocusNode;
  late final FocusNode _exampleFocusNode;
  late final HangulComposer _composer;
  bool _submitting = false;
  bool _useCustomKeyboard = true;
  bool _showCustomKeyboard = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.word;
    final initialWord = initial?.word ?? widget.initialWord ?? '';
    final initialMeaning = initial?.meaning ?? widget.initialMeaning ?? '';
    _wordController = TextEditingController(text: initialWord);
    _meaningController = TextEditingController(text: initialMeaning);
    _exampleController = TextEditingController(text: initial?.example ?? '');
    _tagsController =
        TextEditingController(text: initial?.tags.join(' ') ?? '');
    _activeComposerController = _wordController;
    _category = initial?.category ?? WordCategory.WORDS;
    _status = initial?.status ?? WordStatus.REVIEWING;
    _wordFocusNode = FocusNode();
    _meaningFocusNode = FocusNode();
    _exampleFocusNode = FocusNode();
    _composer = HangulComposer();
    _composer.loadFromText(_wordController.text);
    _applyComposerText();
    _wordFocusNode.addListener(_onFocusChange);
    _meaningFocusNode.addListener(_onFocusChange);
    _exampleFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    final anyHasFocus = _wordFocusNode.hasFocus ||
        _meaningFocusNode.hasFocus ||
        _exampleFocusNode.hasFocus;

    if (_wordFocusNode.hasFocus) {
      _activeComposerController = _wordController;
    } else if (_meaningFocusNode.hasFocus) {
      _activeComposerController = _meaningController;
    } else if (_exampleFocusNode.hasFocus) {
      _activeComposerController = _exampleController;
    }

    if (anyHasFocus && _useCustomKeyboard) {
      setState(() => _showCustomKeyboard = true);
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _tagsController.dispose();
    _wordFocusNode.dispose();
    _meaningFocusNode.dispose();
    _exampleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: widget.isEditing ? '単語を編集' : '新しい単語/文章を追加',
      showBackButton: true,
      childPad: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _wordController,
                      focusNode: _wordFocusNode,
                      readOnly: _useCustomKeyboard,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: '単語/文章 *',
                        helperText: 'カスタムキーボードで入力します',
                      ),
                      maxLength: 100,
                      onTap: () {
                        if (_useCustomKeyboard) {
                          _loadComposerFromField(_wordController);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '単語/文章を入力してください';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _meaningController,
                      focusNode: _meaningFocusNode,
                      readOnly: _useCustomKeyboard,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: '意味 *',
                      ),
                      maxLength: 200,
                      onTap: () {
                        if (_useCustomKeyboard) {
                          _loadComposerFromField(_meaningController);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '意味を入力してください';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _exampleController,
                      focusNode: _exampleFocusNode,
                      readOnly: _useCustomKeyboard,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: '例文',
                      ),
                      maxLines: 4,
                      maxLength: 500,
                      onTap: () {
                        if (_useCustomKeyboard) {
                          _loadComposerFromField(_exampleController);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<WordCategory>(
                      initialSelection: _category,
                      label: const Text('カテゴリー'),
                      dropdownMenuEntries: [
                        for (final category in WordCategory.values)
                          DropdownMenuEntry(
                            value: category,
                            label: category.label,
                          ),
                      ],
                      onSelected: (value) {
                        if (value == null) return;
                        _closeKeyboard();
                        setState(() => _category = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownMenu<WordStatus>(
                      initialSelection: _status,
                      label: const Text('ステータス'),
                      dropdownMenuEntries: [
                        for (final status in WordStatus.values)
                          DropdownMenuEntry(
                            value: status,
                            label: status.label,
                          ),
                      ],
                      onSelected: (value) {
                        if (value == null) return;
                        _closeKeyboard();
                        setState(() => _status = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    FButton(
                      mainAxisSize: MainAxisSize.max,
                      onPress: _submitting ? null : _save,
                      child: Text(widget.isEditing ? '更新する' : '保存する'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showCustomKeyboard || _wordFocusNode.hasFocus || _meaningFocusNode.hasFocus || _exampleFocusNode.hasFocus)
            SafeArea(
              top: false,
              left: false,
              right: false,
              child: TypingKeyboard(
                onTextInput: _handleComposerInput,
                onBackspace: _handleComposerBackspace,
                onSpace: _handleComposerSpace,
                onEnter: _handleComposerEnter,
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    try {
      if (widget.isEditing) {
        await ref.read(wordbookProvider.notifier).updateWord(
              widget.word!.id,
              word: _wordController.text.trim(),
              meaning: _meaningController.text.trim(),
              example: _exampleController.text.trim().isEmpty
                  ? null
                  : _exampleController.text.trim(),
              category: _category,
              status: _status,
              tags: [],
            );
      } else {
        await ref.read(wordbookProvider.notifier).addWord(
              word: _wordController.text.trim(),
              meaning: _meaningController.text.trim(),
              example: _exampleController.text.trim().isEmpty
                  ? null
                  : _exampleController.text.trim(),
              category: _category,
              status: _status,
              tags: [],
            );
      }

      if (!mounted) return;
      ToastHelper.show(
        context,
        widget.isEditing ? '単語を更新しました' : '単語を追加しました',
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ToastHelper.showError(context, '保存に失敗しました: $error');
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  TextEditingController get _activeController {
    return _activeComposerController;
  }

  void _loadComposerFromField(TextEditingController controller) {
    _activeComposerController = controller;
    _composer.loadFromText(controller.text);
    _applyComposerText();
  }

  void _switchToDefaultKeyboard() {
    setState(() {
      _useCustomKeyboard = false;
      _showCustomKeyboard = false;
    });
    // 現在のフォーカスを維持してデフォルトキーボードを表示
    if (_wordFocusNode.hasFocus) {
      _wordFocusNode.requestFocus();
    } else if (_meaningFocusNode.hasFocus) {
      _meaningFocusNode.requestFocus();
    } else if (_exampleFocusNode.hasFocus) {
      _exampleFocusNode.requestFocus();
    }
  }

  Future<void> _switchToCustomKeyboard() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    final controller = _activeController;
    _composer.loadFromText(controller.text);
    _applyComposerText();
    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
    // 現在のフォーカスを再設定
    if (_wordFocusNode.hasFocus) {
      _wordFocusNode.requestFocus();
    } else if (_meaningFocusNode.hasFocus) {
      _meaningFocusNode.requestFocus();
    } else if (_exampleFocusNode.hasFocus) {
      _exampleFocusNode.requestFocus();
    }
  }

  Future<void> _closeKeyboard() async {
    setState(() {
      _showCustomKeyboard = false;
    });
    _wordFocusNode.unfocus();
    _meaningFocusNode.unfocus();
    _exampleFocusNode.unfocus();
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _handleComposerInput(String value) {
    _composer.input(value);
    _applyComposerText();
  }

  void _handleComposerBackspace() {
    _composer.backspace();
    _applyComposerText();
  }

  void _handleComposerSpace() {
    _composer.addSpace();
    _applyComposerText();
  }

  void _handleComposerEnter() {
    _composer.addNewLine();
    _applyComposerText();
  }

  void _applyComposerText() {
    final text = _composer.text;
    final controller = _activeComposerController;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.characters.length,
      ),
    );
  }

  List<String> _parseTags(String input) {
    return input
        .split(RegExp(r'\s+'))
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .map((tag) => tag.startsWith('#') ? tag : '#$tag')
        .toSet()
        .toList();
  }
}
