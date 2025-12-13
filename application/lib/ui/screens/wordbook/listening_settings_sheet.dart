import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/wordbook/domain/providers/wordbook_providers.dart';

class ListeningSettingsSheet extends ConsumerWidget {
  const ListeningSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(listeningSettingsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return settingsAsync.when(
      data: (settings) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ハンドル
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // タイトル
              Text(
                '聞き流し設定',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // 再生速度
              _SettingItem(
                label: '再生速度',
                value: '${settings.speechRate.toStringAsFixed(1)}x',
                child: Slider(
                  value: settings.speechRate,
                  min: 0.5,
                  max: 1.5,
                  divisions: 10,
                  onChanged: (value) {
                    ref
                        .read(listeningSettingsProvider.notifier)
                        .setSpeechRate(value);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 日本語→韓国語の間隔
              _SettingItem(
                label: '日本語→韓国語の間隔',
                value: '${settings.japaneseToKoreanMs}ms',
                child: Slider(
                  value: settings.japaneseToKoreanMs.toDouble(),
                  min: 300,
                  max: 2000,
                  divisions: 17,
                  onChanged: (value) {
                    ref
                        .read(listeningSettingsProvider.notifier)
                        .setJapaneseToKoreanMs(value.toInt());
                  },
                ),
              ),
              const SizedBox(height: 16),

              // 単語間の間隔
              _SettingItem(
                label: '単語間の間隔',
                value: '${settings.wordToWordMs}ms',
                child: Slider(
                  value: settings.wordToWordMs.toDouble(),
                  min: 500,
                  max: 3000,
                  divisions: 25,
                  onChanged: (value) {
                    ref
                        .read(listeningSettingsProvider.notifier)
                        .setWordToWordMs(value.toInt());
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 閉じるボタン
              SizedBox(
                width: double.infinity,
                child: FButton(
                  onPress: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('設定の読み込みに失敗しました: $error'),
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.label,
    required this.value,
    required this.child,
  });

  final String label;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
