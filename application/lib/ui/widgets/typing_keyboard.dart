import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _KeyboardMode {
  hangul,
  symbols,
}

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
  _KeyboardMode _currentMode = _KeyboardMode.hangul;

  static const _hangulRows = [
    ['ㅂ', 'ㅈ', 'ㄷ', 'ㄱ', 'ㅅ', 'ㅛ', 'ㅕ', 'ㅑ', 'ㅐ', 'ㅔ'],
    ['ㅁ', 'ㄴ', 'ㅇ', 'ㄹ', 'ㅎ', 'ㅗ', 'ㅓ', 'ㅏ', 'ㅣ'],
    ['⇧', 'ㅋ', 'ㅌ', 'ㅊ', 'ㅍ', 'ㅠ', 'ㅜ', 'ㅡ', '⌫'],
    ['123', 'space', '.', '⏎'],
  ];

  static const _symbolRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['!', '@', '#', '?', '.', ',', ';', ':'],
    ['-', '/', '+', '=', '(', ')', '"', "'", '⌫'],
    ['ABC', 'space', '!', '⏎'],
  ];

  // シフトキー押下時の変換マップ（濃音子音 + 母音）
  static const _shiftMappings = {
    'ㄱ': 'ㄲ',
    'ㄷ': 'ㄸ',
    'ㅂ': 'ㅃ',
    'ㅅ': 'ㅆ',
    'ㅈ': 'ㅉ',
    'ㅐ': 'ㅒ',
    'ㅔ': 'ㅖ',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final rows = _currentMode == _KeyboardMode.hangul ? _hangulRows : _symbolRows;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(6),),
        border: Border.all(color: colors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (widget.nextKeyLabel != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 6),
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
          for (final row in rows) ...[
            _KeyboardRow(
              keys: row,
              isShiftActive: _shiftActive,
              currentMode: _currentMode,
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
    developer.log('Key tapped: $label');
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
        widget.onEnter();
        setState(() => _shiftActive = false);
        _notifyFeedback();
        return;
      case '123':
        // 数字・記号キーボードに切り替え
        setState(() {
          _currentMode = _KeyboardMode.symbols;
          _shiftActive = false;
        });
        _notifyFeedback();
        return;
      case 'ABC':
        // ハングルキーボードに切り替え
        setState(() {
          _currentMode = _KeyboardMode.hangul;
          _shiftActive = false;
        });
        _notifyFeedback();
        return;
      default:
        final value = _shiftActive
            ? (_shiftMappings[label] ?? label)
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
    required this.currentMode,
    required this.highlightShift,
  });

  final List<String> keys;
  final void Function(String key) onKeyTap;
  final Set<String> highlightedKeys;
  final bool isShiftActive;
  final _KeyboardMode currentMode;
  final bool highlightShift;

  // シフトキー押下時の変換マップ（濃音子音 + 母音）
  static const _shiftMappings = {
    'ㄱ': 'ㄲ',
    'ㄷ': 'ㄸ',
    'ㅂ': 'ㅃ',
    'ㅅ': 'ㅆ',
    'ㅈ': 'ㅉ',
    'ㅐ': 'ㅒ',
    'ㅔ': 'ㅖ',
  };

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
                displayLabel: _getDisplayLabel(keys[i]),
                onTap: onKeyTap,
                isHighlighted: _isHighlighted(keys[i]),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getDisplayLabel(String key) {
    // ハングルモードかつシフト有効時、シフト変換可能な文字は変換後を表示
    if (currentMode == _KeyboardMode.hangul &&
        isShiftActive &&
        _shiftMappings.containsKey(key)) {
      return _shiftMappings[key]!;
    }
    return key;
  }

  int _flex(String key) {
    switch (key) {
      case 'space':
        return 6;
      case '123':
      case 'ABC':
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
    required this.displayLabel,
    required this.onTap,
    required this.isHighlighted,
  });

  final String label;
  final String displayLabel;
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
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(displayLabel.length > 1 ? 8 : 6),
          color: backgroundColor,
          border: Border.all(
            color: isHighlighted
                ? const Color(0xFFFFA500)
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Text(
          displayLabel == 'space' ? 'space' : displayLabel,
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


