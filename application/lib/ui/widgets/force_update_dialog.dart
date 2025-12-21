import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/app_version/domain/providers/app_version_providers.dart';
import '../../core/utils/logger.dart';
import '../app_spacing.dart';

/// 強制アップデートダイアログを表示
///
/// このダイアログは閉じることができない（スキップ不可）
class ForceUpdateDialog extends ConsumerWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(versionCheckProvider);
    final theme = Theme.of(context);

    return PopScope(
      // 戻るボタンで閉じられないようにする
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // アイコン
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.arrow_up,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // タイトル
              Text(
                'アップデートが必要です',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // 説明文
              Text(
                '最新版にアップデートしてください。\n現在の機能を引き続きご利用いただくには、最新バージョンが必要です。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // バージョン情報
              if (state.currentVersion != null && state.minimumVersion != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '現在: ${state.currentVersion} → 必要: ${state.minimumVersion}以上',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),

              // アップデートボタン
              SizedBox(
                width: double.infinity,
                child: FButton(
                  onPress: () => _openStore(state.storeUrl),
                  child: const Text('ストアでアップデート'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(String? url) async {
    if (url == null) {
      AppLogger.error('Store URL is null', tag: 'ForceUpdateDialog');
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      AppLogger.error(
        'Failed to open store',
        tag: 'ForceUpdateDialog',
        error: e,
      );
    }
  }
}

/// 強制アップデートダイアログを表示するヘルパー
class ForceUpdateDialogHelper {
  static bool _isShowing = false;

  /// ダイアログを表示（重複表示防止付き）
  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false, // バリアタップで閉じられない
      useRootNavigator: true,
      builder: (context) => const ForceUpdateDialog(),
    ).whenComplete(() {
      _isShowing = false;
    });
  }
}
