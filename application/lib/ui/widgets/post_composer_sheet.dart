import 'package:flutter/material.dart';

import '../../mock/mock_data.dart';

class PostComposerSheet extends StatelessWidget {
  const PostComposerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: viewInsets + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.15,
                ),
                child: const Text('H'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('@hana_typing', style: theme.textTheme.titleMedium),
                    Text(
                      '中級者 🏅',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('下書き')),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '今日は何をしましたか？韓国語で書いてみましょう。',
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.25,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '残り 280 文字',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(left: 8, bottom: 8),
            title: Row(
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text('文法ヒント', style: theme.textTheme.titleMedium),
              ],
            ),
            children: const [
              _HintLine('오늘은 ~했어요.（今日は〜しました）'),
              _HintLine('날씨가 ~네요.（〜ですね の柔らかい表現）'),
              _HintLine('기분이 ~어요.（気分の表現）'),
              _HintLine('요즘 ~에 빠졌어요.（最近〜にハマっています）'),
              _HintLine('~하고 싶어요!（〜したいです）'),
              _HintLine('~중이에요.（〜しているところです）'),
              _HintLine('~같아요.（〜みたいです / 〜っぽい）'),
              _HintLine('~해줘서 고마워요!（〜してくれてありがとう）'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ComposerIconButton(icon: Icons.photo_outlined, onPressed: () {}),
              const SizedBox(width: 12),
              _ComposerIconButton(
                icon: Icons.auto_fix_high_outlined,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: const Text('投稿する')),
          ),
        ],
      ),
    );
  }
}

class _HintLine extends StatelessWidget {
  const _HintLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon),
      ),
    );
  }
}
