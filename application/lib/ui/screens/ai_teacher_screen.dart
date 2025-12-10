import 'package:chaletta/features/auth/data/models/user_model.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/widgets/ai_gradient_button.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:chaletta/ui/widgets/modern_text_input.dart';
import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:chaletta/ui/widgets/typing_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/typing/domain/services/hangul_composer.dart';
import '../utils/toast_helper.dart';

class AiTeacherScreen extends ConsumerStatefulWidget {
  const AiTeacherScreen({super.key});

  @override
  ConsumerState<AiTeacherScreen> createState() => _AiTeacherScreenState();
}

class _AiTeacherScreenState extends ConsumerState<AiTeacherScreen> {
  final _controller = TextEditingController();
  final _resultController = TextEditingController();
  final _focusNode = FocusNode();
  late final HangulComposer _composer;

  bool _isLoading = false;
  String? _error;
  bool _useCustomKeyboard = true;
  bool _showCustomKeyboard = false;

  @override
  void initState() {
    super.initState();
    _composer = HangulComposer()..loadFromText(_controller.text);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() => _showCustomKeyboard = false);
      return;
    }
    if (_useCustomKeyboard) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _composer.loadFromText(_controller.text);
      _applyComposerText();
      setState(() => _showCustomKeyboard = true);
    } else {
      setState(() => _showCustomKeyboard = false);
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
    _controller.value = TextEditingValue(
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
    _composer.loadFromText(_controller.text);
    _applyComposerText();
    setState(() {
      _useCustomKeyboard = true;
      _showCustomKeyboard = true;
    });
  }

  Future<void> _askJpKr() async {
    await _executeAction(
      action: () =>
          ref.read(aiCorrectionServiceProvider).askJpKr(_controller.text),
    );
  }

  Future<void> _translateKrJp() async {
    await _executeAction(
      action: () =>
          ref.read(aiCorrectionServiceProvider).translateKrJp(_controller.text),
    );
  }

  Future<void> _executeAction({
    required Future<String> Function() action,
  }) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _resultController.clear();
    });

    try {
      final result = await action();
      if (!mounted) return;
      setState(() {
        _resultController.text = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'エラーが発生しました: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isPremiumUser = user?.isPremiumUser ?? false;

    if (!isPremiumUser) {
      return const PremiumFeatureGateScreen(focusFeature: 'AI先生');
    }

    return AppPageScaffold(
      title: 'AI先生に聞く',
      showBackButton: true,
      childPad: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                ModernTextInputWithActions(
                  controller: _controller,
                  focusNode: _focusNode,
                  placeholder: '質問や知りたい単語、言い方、翻訳したい文章を入力してください',
                  minLines: 5,
                  maxLines: 15,
                  enabled: !_isLoading,
                  showCharacterCount: false,
                  readOnly: _useCustomKeyboard,
                  showCursor: true,
                  keyboardType:
                      _useCustomKeyboard ? TextInputType.none : TextInputType.multiline,
                  onTap: _useCustomKeyboard
                      ? () {
                          _composer.loadFromText(_controller.text);
                          _applyComposerText();
                        }
                      : null,
                  onChanged: (value) {
                    if (!_useCustomKeyboard) {
                      _composer.loadFromText(value);
                    }
                  },
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: AiGradientButton(
                            label: '質問\n(日➡︎韓)',
                            icon: Iconsax.translate,
                            onTap: _isLoading ? null : _askJpKr,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AiGradientButton(
                            label: '翻訳\n(韓➡︎日)',
                            icon: Iconsax.translate,
                            onTap: _isLoading ? null : _translateKrJp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_isLoading) ...[
                  const SizedBox(height: AppSpacing.xl),
                  const Center(child: CircularProgressIndicator()),
                ],
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error!,
                      style:
                          TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                ],
                if (_resultController.text.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '回答',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      FButton.icon(
                        style: FButtonStyle.ghost(),
                        child: const Icon(Iconsax.copy, size: 18),
                        onPress: () {
                          Clipboard.setData(
                            ClipboardData(text: _resultController.text),
                          );
                          ToastHelper.show(context, 'コピーしました');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ModernTextInput(
                    controller: _resultController,
                    placeholder: '',
                    minLines: 10,
                    maxLines: 20,
                    enabled: false,
                  ),
                ],
              ],
            ),
          ),
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
