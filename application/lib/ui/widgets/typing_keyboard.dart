import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypingKeyboard extends StatefulWidget {
  const TypingKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSpace,
    required this.onEnter,
    this.highlightedKeys = const {},
    this.highlightShift = false,
    this.nextKeyLabel,
    this.enableSound = false,
    this.enableHaptics = true,
  });

  final void Function(String value) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final Set<String> highlightedKeys;
  final bool highlightShift;
  final String? nextKeyLabel;
  final bool enableSound;
  final bool enableHaptics;

  @override
  State<TypingKeyboard> createState() => _TypingKeyboardState();
}

class _TypingKeyboardState extends State<TypingKeyboard> {
  bool _shiftActive = false;

  static const _rows = [
    ['ㅂ', 'ㅈ', 'ㄷ', 'ㄱ', 'ㅅ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅐ', 'ㅔ'],
    ['ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ'],
    ['⇧', 'ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ', '⌫'],
    ['123', '🌐', 'space', '✓', '⏎'],
  ];

  static const _doubleConsonants = {
    'ㄱ': 'ㄲ',
    'ㄷ': 'ㄸ',
    'ㅂ': 'ㅃ',
    'ㅅ': 'ㅆ',
    'ㅈ': 'ㅉ',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _TimerChip(
                label: widget.nextKeyLabel ?? 'ヒントON',
                color: colors.secondary,
              ),
              const Spacer(),
              if (widget.nextKeyLabel != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      widget.nextKeyLabel!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (final row in _rows) ...[
            _KeyboardRow(
              keys: row,
              isShiftActive: _shiftActive,
              highlightShift: widget.highlightShift,
              highlightedKeys: widget.highlightedKeys,
              onKeyTap: _handleKeyTap,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  void _handleKeyTap(String label) {
    switch (label) {
      case '⇧':
        setState(() => _shiftActive = !_shiftActive);
        _notifyFeedback();
        return;
      case '⌫':
        widget.onBackspace();
        setState(() => _shiftActive = false);
        _notifyFeedback();
        return;
      case 'space':
        widget.onSpace();
        setState(() => _shiftActive = false);
        _notifyFeedback();
        return;
      case '⏎':
      case '✓':
        widget.onEnter();
        setState(() => _shiftActive = false);
        _notifyFeedback();
        return;
      case '123':
      case '🌐':
        // まだモック。実装時に切り替えを追加
        return;
      default:
        final value = _shiftActive
            ? (_doubleConsonants[label] ?? label)
            : label;
        widget.onTextInput(value);
        if (_shiftActive) {
          setState(() => _shiftActive = false);
        }
        _notifyFeedback();
    }
  }

  void _notifyFeedback() {
    if (widget.enableSound) {
      SystemSound.play(SystemSoundType.click);
    }
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }
}

class _KeyboardRow extends StatelessWidget {
  const _KeyboardRow({
    required this.keys,
    required this.onKeyTap,
    required this.highlightedKeys,
    required this.isShiftActive,
    required this.highlightShift,
  });

  final List<String> keys;
  final void Function(String key) onKeyTap;
  final Set<String> highlightedKeys;
  final bool isShiftActive;
  final bool highlightShift;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          Expanded(
            flex: _flex(keys[i]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _KeyboardKey(
                label: keys[i],
                onTap: onKeyTap,
                isHighlighted: _isHighlighted(keys[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }

  int _flex(String key) {
    switch (key) {
      case 'space':
        return 4;
      case '123':
      case '🌐':
      case '⌫':
      case '⇧':
        return 2;
      default:
        return 1;
    }
  }

  bool _isHighlighted(String key) {
    if (key == '⇧') {
      return highlightShift || isShiftActive;
    }
    if (key == 'space') {
      return highlightedKeys.contains(' ');
    }
    return highlightedKeys.contains(key);
  }
}

class _KeyboardKey extends StatelessWidget {
  const _KeyboardKey({
    required this.label,
    required this.onTap,
    required this.isHighlighted,
  });

  final String label;
  final void Function(String key) onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = const Color(0xFFFFD700);
    final backgroundColor = isHighlighted
        ? highlightColor.withValues(alpha: 0.25)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(label.length > 1 ? 16 : 12),
          color: backgroundColor,
          border: Border.all(
            color: isHighlighted
                ? const Color(0xFFFFA500)
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Text(
          label == 'space' ? 'space' : label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isHighlighted
                ? const Color(0xFFFF8C00)
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
