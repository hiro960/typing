import 'package:flutter/material.dart';

class TypingKeyboardMock extends StatelessWidget {
  const TypingKeyboardMock({
    super.key,
    required this.highlightedKeys,
    required this.highlightShift,
    required this.timerLabel,
    this.nextKeyLabel,
  });

  final Set<String> highlightedKeys;
  final bool highlightShift;
  final String timerLabel;
  final String? nextKeyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _keyboardRows;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _TimerChip(
                label: timerLabel,
                color: theme.colorScheme.secondary,
              ),
              const Spacer(),
              if (nextKeyLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFA500)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.keyboard_double_arrow_up,
                        size: 16,
                        color: Color(0xFFFFA500),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        nextKeyLabel!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFFFA500),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (final row in rows) ...[
            _KeyboardRow(
              keys: row,
              highlighted: highlightedKeys,
              highlightShift: highlightShift,
            ),
            const SizedBox(height: 10),
          ],
        ],
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
        border: Border.all(
          color: color.withValues(alpha: 0.4),
        ),
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

class _KeyboardRow extends StatelessWidget {
  const _KeyboardRow({
    required this.keys,
    required this.highlighted,
    required this.highlightShift,
  });

  final List<_KeyData> keys;
  final Set<String> highlighted;
  final bool highlightShift;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          Expanded(
            flex: keys[i].flex,
            child: _KeyboardKey(
              data: keys[i],
              isHighlighted:
                  highlighted.contains(keys[i].label) ||
                  (keys[i].label == '⇧' && highlightShift),
            ),
          ),
          if (i != keys.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  const _KeyboardKey({required this.data, required this.isHighlighted});

  final _KeyData data;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = const Color(0xFFFFD700);
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHighlighted
            ? highlightColor.withValues(alpha: 0.25)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(data.isWide ? 16 : 12),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFFFFA500)
              : theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Text(
        data.label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isHighlighted
              ? const Color(0xFFFF8C00)
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _KeyData {
  const _KeyData(this.label, {this.flex = 10, this.isWide = false});

  final String label;
  final int flex;
  final bool isWide;
}

const _keyboardRows = [
  [
    _KeyData('ㅂ'),
    _KeyData('ㅈ'),
    _KeyData('ㄷ'),
    _KeyData('ㄱ'),
    _KeyData('ㅅ'),
    _KeyData('ㅛ'),
    _KeyData('ㅕ'),
    _KeyData('ㅑ'),
    _KeyData('ㅐ'),
    _KeyData('ㅔ'),
  ],
  [
    _KeyData('ㅁ'),
    _KeyData('ㄴ'),
    _KeyData('ㅇ'),
    _KeyData('ㄹ'),
    _KeyData('ㅎ'),
    _KeyData('ㅗ'),
    _KeyData('ㅓ'),
    _KeyData('ㅏ'),
    _KeyData('ㅣ'),
  ],
  [
    _KeyData('⇧', flex: 15, isWide: true),
    _KeyData('ㅋ'),
    _KeyData('ㅌ'),
    _KeyData('ㅊ'),
    _KeyData('ㅍ'),
    _KeyData('ㅠ'),
    _KeyData('ㅜ'),
    _KeyData('ㅡ'),
    _KeyData('⌫', flex: 15, isWide: true),
  ],
  [
    _KeyData('123', flex: 18, isWide: true),
    _KeyData('🌐', flex: 18, isWide: true),
    _KeyData('space', flex: 40, isWide: true),
    _KeyData('✓', flex: 14, isWide: true),
    _KeyData('⏎', flex: 14, isWide: true),
  ],
];
