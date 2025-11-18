import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late final HangulComposer _composer;
  bool _submitting = false;
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
    _composer = HangulComposer();
    _composer.loadFromText(_wordController.text);
    _applyComposerText();
    _wordFocusNode.addListener(() {
      if (!_wordFocusNode.hasFocus && _showCustomKeyboard) {
        setState(() => _showCustomKeyboard = false);
      }
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _tagsController.dispose();
    _wordFocusNode.dispose();
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
                      readOnly: true,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: '単語/文章 *',
                        helperText: 'カスタムキーボードで入力します',
                      ),
                      maxLength: 100,
                      onTap: () {
                        setState(() => _showCustomKeyboard = true);
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
                      decoration: const InputDecoration(
                        labelText: '意味 *',
                      ),
                      maxLength: 200,
                      onTap: _hideCustomKeyboard,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '意味を入力してください';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _exampleController,
                      decoration: const InputDecoration(
                        labelText: '例文',
                      ),
                      maxLines: 4,
                      maxLength: 500,
                      onTap: _hideCustomKeyboard,
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
                        _hideCustomKeyboard();
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
                        _hideCustomKeyboard();
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
                      onTap: _hideCustomKeyboard,
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _showCustomKeyboard
                ? ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: TypingKeyboard(
                      onTextInput: _handleComposerInput,
                      onBackspace: _handleComposerBackspace,
                      onSpace: _handleComposerSpace,
                      onEnter: _hideCustomKeyboard,
                      enableHaptics: true,
                      enableSound: false,
                    ),
                  )
                : const SizedBox.shrink(),
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

  void _hideCustomKeyboard() {
    if (_showCustomKeyboard) {
      setState(() => _showCustomKeyboard = false);
    }
    if (_wordFocusNode.hasFocus) {
      _wordFocusNode.unfocus();
    }
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

  void _applyComposerText() {
    final text = _composer.text;
    _wordController.value = TextEditingValue(
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
