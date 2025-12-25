import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

enum _KeyboardMode { hangul, symbols1, symbols2 }

class TypingKeyboard extends StatefulWidget {
  const TypingKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onSpace,
    required this.onEnter,
    this.highlightedKeys = const {},
    this.highlightShift = false,
    this.highlightSymbol = false,
    this.nextKeyLabel,
    this.enableSound = false,
    this.enableHaptics = true,
    this.showToolbar = false,
    this.showKeys = true,
    this.onClose,
    this.onSwitchToDefaultKeyboard,
    this.onSwitchToCustomKeyboard,
    this.onPaste,
  });

  final void Function(String value) onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onSpace;
  final VoidCallback onEnter;
  final Set<String> highlightedKeys;
  final bool highlightShift;
  final bool highlightSymbol;
  final String? nextKeyLabel;
  final bool enableSound;
  final bool enableHaptics;

  /// ツールバー（閉じる・キーボード切り替え）を表示するか
  final bool showToolbar;

  /// キーボード本体を表示するか（falseの場合はツールバーのみ表示）
  final bool showKeys;

  /// 閉じるボタンが押された時のコールバック
  final VoidCallback? onClose;

  /// デフォルトキーボードへの切り替えボタンが押された時のコールバック
  final VoidCallback? onSwitchToDefaultKeyboard;

  /// カスタムキーボードへの切り替えボタンが押された時のコールバック
  final VoidCallback? onSwitchToCustomKeyboard;

  /// ペーストボタンが押された時のコールバック
  final VoidCallback? onPaste;

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

  // iPhone韓国語キーボード 数字・記号ページ1
  static const _symbols1Rows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['-', '/', ':', ';', '(', ')', '₩', '&', '@', '"'],
    ['#+=', '.', ',', '?', '!', "'", '⌫'],
    ['한글', 'space', '⏎'],
  ];

  // iPhone韓国語キーボード 記号ページ2
  static const _symbols2Rows = [
    ['[', ']', '{', '}', '#', '%', '^', '*', '+', '='],
    ['_', '\\', '|', '~', '<', '>', '€', '\$', '¥', '•'],
    ['123', '.', ',', '?', '!', "'", '⌫'],
    ['한글', 'space', '⏎'],
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
    final rows = switch (_currentMode) {
      _KeyboardMode.hangul => _hangulRows,
      _KeyboardMode.symbols1 => _symbols1Rows,
      _KeyboardMode.symbols2 => _symbols2Rows,
    };

    // 親のpaddingを無視して画面幅いっぱいに広げる
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              top: BorderSide(color: colors.primary.withValues(alpha: 0.08)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ツールバー（オプション）- 横幅いっぱいに広がる
              if (widget.showToolbar)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    border: widget.showKeys
                        ? Border(
                            bottom: BorderSide(
                              color: colors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // キーボード切り替えボタン
                      if (widget.showKeys &&
                          widget.onSwitchToDefaultKeyboard != null)
                        GestureDetector(
                          onTap: widget.onSwitchToDefaultKeyboard,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Icon(
                              Iconsax.keyboard,
                              size: 22,
                              color: colors.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      if (!widget.showKeys &&
                          widget.onSwitchToCustomKeyboard != null)
                        GestureDetector(
                          onTap: widget.onSwitchToCustomKeyboard,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Icon(
                              Iconsax.keyboard,
                              size: 22,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      // ペーストボタン
                      if (widget.onPaste != null && widget.showKeys)
                        GestureDetector(
                          onTap: widget.onPaste,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Icon(
                              Iconsax.clipboard_text,
                              size: 22,
                              color: colors.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      const Spacer(),
                      // 閉じるボタン
                      if (widget.onClose != null)
                        GestureDetector(
                          onTap: widget.onClose,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text(
                              '閉じる',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              // キーボード本体（パディング付き）- showKeysがtrueの場合のみ表示
              if (widget.showKeys)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ヒント表示
                      Row(
                        children: [
                          if (widget.nextKeyLabel != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 6),
                                const Icon(Iconsax.lamp_charge, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  widget.nextKeyLabel!,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (widget.nextKeyLabel != null)
                        const SizedBox(height: 8)
                      else
                        const SizedBox(height: 4),
                      for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
                        _KeyboardRow(
                          keys: rows[rowIndex],
                          isShiftActive: _shiftActive,
                          currentMode: _currentMode,
                          highlightShift: widget.highlightShift,
                          highlightSymbol: widget.highlightSymbol,
                          highlightedKeys: widget.highlightedKeys,
                          onKeyTap: _handleKeyTap,
                          rowIndex: rowIndex,
                        ),
                        const SizedBox(height: 8), // iPhoneキーボードに近い行間
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
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
        widget.onEnter();
        setState(() => _shiftActive = false);
        _notifyFeedback();
        return;
      case '123':
        // 数字・記号キーボード（ページ1）に切り替え
        setState(() {
          _currentMode = _KeyboardMode.symbols1;
          _shiftActive = false;
        });
        _notifyFeedback();
        return;
      case '#+=':
        // 記号キーボード（ページ2）に切り替え
        setState(() {
          _currentMode = _KeyboardMode.symbols2;
          _shiftActive = false;
        });
        _notifyFeedback();
        return;
      case '한글':
        // ハングルキーボードに切り替え
        setState(() {
          _currentMode = _KeyboardMode.hangul;
          _shiftActive = false;
        });
        _notifyFeedback();
        return;
      default:
        final value = _shiftActive ? (_shiftMappings[label] ?? label) : label;
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
    required this.highlightSymbol,
    required this.rowIndex,
  });

  final List<String> keys;
  final void Function(String key) onKeyTap;
  final Set<String> highlightedKeys;
  final bool isShiftActive;
  final _KeyboardMode currentMode;
  final bool highlightShift;
  final bool highlightSymbol;
  final int rowIndex;

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
    // ハングルモードの2行目（index 1）には左右にキー半分のスペーサーを追加
    final needsSidePadding =
        currentMode == _KeyboardMode.hangul && rowIndex == 1;

    return Row(
      children: [
        // 左側スペーサー（キー半分の幅）
        if (needsSidePadding) const Spacer(flex: 1),
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
        // 右側スペーサー（キー半分の幅）
        if (needsSidePadding) const Spacer(flex: 1),
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
    // ハングルモードの3行目（index 2）でシフトとバックスペースを1.5倍幅に
    final isHangulRow2 = currentMode == _KeyboardMode.hangul && rowIndex == 2;

    switch (key) {
      case 'space':
        return 5;
      case '123':
      case '#+=':
      case '한글':
        return 2;
      case '⌫':
      case '⇧':
        // ハングルモードの3行目では1.5倍幅（flex: 3、通常キーはflex: 2）
        return isHangulRow2 ? 3 : 1;
      default:
        // ハングルモードの2行目と3行目では通常キーもflex: 2で統一
        final needsDoubleFlex = currentMode == _KeyboardMode.hangul &&
            (rowIndex == 1 || rowIndex == 2);
        return needsDoubleFlex ? 2 : 1;
    }
  }

  bool _isHighlighted(String key) {
    // シフトキーの処理
    if (key == '⇧') {
      // シフトが必要で、まだシフトが押されていない場合のみハイライト
      return highlightShift && !isShiftActive;
    }

    // 123キーの処理
    if (key == '123') {
      // ハングルモードでシンボルキーボードの文字を入力する場合のみハイライト
      return highlightSymbol && currentMode == _KeyboardMode.hangul;
    }

    // シフトが必要だがまだ押されていない場合、他のキーはハイライトしない
    if (highlightShift && !isShiftActive) {
      return false;
    }

    // シンボル文字が必要だがハングルモードの場合、他のキーはハイライトしない
    if (highlightSymbol && currentMode == _KeyboardMode.hangul) {
      return false;
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
    // フォントサイズを決定
    final double fontSize;
    if (label == '⇧' || label == '⌫') {
      fontSize = 20; // シフトとバックスペースは大きめ
    } else if (label == 'space') {
      fontSize = 14; // スペースキーは小さめ
    } else if (label == '123' || label == '#+=' || label == '한글' || label == '⏎') {
      fontSize = 16; // その他の特殊キーは控えめ
    } else {
      fontSize = 22; // 通常キーは大きめ
    }

    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        height: 44, // iPhoneデフォルトキーボードに近い高さ
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), // iPhoneキーボードに近い角丸
          color: backgroundColor,
          border: Border.all(
            color: isHighlighted
                ? const Color(0xFFFFA500)
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            width: isHighlighted ? 2 : 1,
          ),
        ),
        child: Text(
          displayLabel == 'space' ? '스페이스' : displayLabel,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: isHighlighted
                ? const Color(0xFFFF8C00)
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
