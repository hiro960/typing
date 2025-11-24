import 'package:flutter/material.dart';

/// X（旧Twitter）風のモダンなテキスト入力欄
class ModernTextInput extends StatefulWidget {
  const ModernTextInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.placeholder = '何か入力してください',
    this.minLines = 1,
    this.maxLines,
    this.maxLength,
    this.enabled = true,
    this.showCharacterCount = false,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.showCursor,
    this.keyboardType,
    this.onTap,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String placeholder;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool showCharacterCount;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool? showCursor;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  State<ModernTextInput> createState() => _ModernTextInputState();
}

class _ModernTextInputState extends State<ModernTextInput>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _borderAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textLength = widget.controller.text.length;
    final isOverLimit =
        widget.maxLength != null && textLength > widget.maxLength!;

    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Material(
          color: _isFocused
              ? theme.colorScheme.surface
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          elevation: _isFocused ? 2 : 0,
          shadowColor: theme.colorScheme.primary.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
                width: _borderAnimation.value,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    showCursor: widget.showCursor,
                    keyboardType: widget.keyboardType,
                    minLines: widget.minLines,
                    maxLines: _isFocused
                        ? (widget.maxLines ?? 10)
                        : (widget.minLines + 1),
                    maxLength: widget.maxLength,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterText: '',
                    ),
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                  ),
                ),
                if (widget.showCharacterCount || (_isFocused && textLength > 0))
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.showCharacterCount && widget.maxLength != null)
                          Text(
                            '$textLength / ${widget.maxLength}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isOverLimit
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        else if (textLength > 0)
                          Text(
                            '$textLength文字',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// アクションボタン付きのモダンなテキスト入力欄
class ModernTextInputWithActions extends StatelessWidget {
  const ModernTextInputWithActions({
    super.key,
    required this.controller,
    this.focusNode,
    this.placeholder = '何か入力してください',
    this.minLines = 1,
    this.maxLines,
    this.maxLength,
    this.enabled = true,
    this.showCharacterCount = false,
    this.onChanged,
    this.actions = const [],
    this.readOnly = false,
    this.showCursor,
    this.keyboardType,
    this.onTap,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String placeholder;
  final int minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool showCharacterCount;
  final ValueChanged<String>? onChanged;
  final List<Widget> actions;
  final bool readOnly;
  final bool? showCursor;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ModernTextInput(
          controller: controller,
          focusNode: focusNode,
          placeholder: placeholder,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          showCharacterCount: showCharacterCount,
          onChanged: onChanged,
          readOnly: readOnly,
          showCursor: showCursor,
          keyboardType: keyboardType,
          onTap: onTap,
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions,
          ),
        ],
      ],
    );
  }
}
