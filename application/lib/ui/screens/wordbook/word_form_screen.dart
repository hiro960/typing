import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../../widgets/typing_keyboard.dart';

class WordFormScreen extends ConsumerStatefulWidget {
  const WordFormScreen({super.key, this.word});

  final Word? word;

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
    _wordController = TextEditingController(text: initial?.word ?? '');
    _meaningController = TextEditingController(text: initial?.meaning ?? '');
    _exampleController = TextEditingController(text: initial?.example ?? '');
    _tagsController =
        TextEditingController(text: initial?.tags.join(' ') ?? '');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? '単語を編集' : '新しい単語/文章を追加'),
      ),
      body: Column(
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
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'タグ（スペース区切りで最大10件）',
                        helperText: '#挨拶 #日常 のように入力してください',
                      ),
                      onTap: _closeKeyboard,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _submitting ? null : _save,
                        child: Text(widget.isEditing ? '更新する' : '保存する'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: SafeArea(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
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
                            color: Theme.of(context).colorScheme.outlineVariant,
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
                          if (_showCustomKeyboard ||
                              _wordFocusNode.hasFocus ||
                              _meaningFocusNode.hasFocus ||
                              _exampleFocusNode.hasFocus)
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
                        onTextInput: _handleComposerInput,
                        onBackspace: _handleComposerBackspace,
                        onSpace: _handleComposerSpace,
                        onEnter: _handleComposerEnter,
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final tags = _parseTags(_tagsController.text);
    if (tags.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タグは最大10個までです。')),
      );
      return;
    }
    if (tags.any((tag) => tag.length > 20)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タグは20文字以内で入力してください。')),
      );
      return;
    }

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
              tags: tags,
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
              tags: tags,
            );
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditing ? '単語を更新しました' : '単語を追加しました'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存に失敗しました: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  TextEditingController get _activeController {
    if (_wordFocusNode.hasFocus) return _wordController;
    if (_meaningFocusNode.hasFocus) return _meaningController;
    if (_exampleFocusNode.hasFocus) return _exampleController;
    return _wordController;
  }

  void _loadComposerFromField(TextEditingController controller) {
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
    final controller = _activeController;
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
