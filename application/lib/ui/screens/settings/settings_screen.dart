import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:characters/characters.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../settings/blocked_accounts_screen.dart';
import '../../../features/profile/domain/providers/profile_providers.dart';
import '../../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../../features/typing/data/models/typing_settings.dart';
import '../../../features/theme/theme_mode_provider.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/sheet_content.dart';
import '../../app_spacing.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _feedbackEmail = 'support@chaletta.app';

  bool _pushNotifications = true;
  bool _isLoggingOut = false;
  bool _isUpdatingDisplayName = false;
  bool _isUpdatingPush = false;
  ProviderSubscription<UserModel?>? _userSub;

  @override
  void initState() {
    super.initState();
    // 現在のユーザー設定を反映
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _pushNotifications = user.settings.notifications.push;
    }
    // ProviderSubscriptionを使い initState で購読
    _userSub = ref.listenManual<UserModel?>(
      currentUserProvider,
      (previous, next) {
        if (!mounted || next == null) return;
        final push = next.settings.notifications.push;
        if (push != _pushNotifications) {
          setState(() => _pushNotifications = push);
        }
      },
    );
  }

  @override
  void dispose() {
    _userSub?.close();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    // 確認ダイアログを表示
    final confirmed = await DialogHelper.showConfirmDialog(
      context,
      title: 'ログアウト',
      content: '本当にログアウトしますか？',
      positiveLabel: 'ログアウト',
      isDestructive: true,
    );

    if (!confirmed || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      // ログアウト処理を実行
      await ref.read(authStateProvider.notifier).logout();

      if (!mounted) return;

      // ログアウト成功 - 設定画面を閉じる
      // これによりAppShellのOnboardingScreenが表示される
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      // エラー表示
      ToastHelper.showError(context, 'ログアウトに失敗しました: $e');
    }
  }

  Future<void> _handleDeleteAccount() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // 確認ダイアログを表示
    final confirmed = await DialogHelper.showConfirmDialog(
      context,
      title: 'アカウント削除',
      content: '本当にアカウントを削除しますか？\nこの操作は取り消せません。\nすべての投稿と学習記録が削除されます。',
      positiveLabel: '削除する',
      isDestructive: true,
    );

    if (!confirmed || !mounted) return;

    setState(() => _isLoggingOut = true);

    try {
      // アカウント削除実行
      await ref.read(profileRepositoryProvider).deleteAccount(user.id);

      // ログアウト処理も実行（ローカルデータのクリア）
      await ref.read(authStateProvider.notifier).logout();

      if (!mounted) return;

      // 成功メッセージを表示してから設定画面を閉じる
      ToastHelper.show(context, 'アカウントを削除しました');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      ToastHelper.showError(context, 'アカウント削除に失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final blockedAsync = ref.watch(blockedAccountsProvider);
    final blockedCount = blockedAsync.value?.length;
    final displayName = currentUser?.displayName ?? '未設定';
    final username = currentUser?.username != null ? '@${currentUser!.username}' : '--';
    return AppPageScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: const Text('設定'),
      ),
      child: ListView(
        padding: AppPadding.settingsPage,
        children: [
          _ProfileHeader(
            displayName: displayName,
            username: username,
            profileImageUrl: currentUser?.profileImageUrl,
            onEdit: currentUser == null || _isUpdatingDisplayName
                ? null
                : () => _editDisplayName(currentUser),
            onCopyId: currentUser == null
                ? null
                : () => _copyUsername(currentUser.username),
            isSaving: _isUpdatingDisplayName,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: 'アカウント',
            children: [
              FTile(
                prefix: const Icon(Icons.alternate_email),
                title: const Text('ユーザーID'),
                subtitle: Text(username),
                suffix: FButton.icon(
                  style: FButtonStyle.ghost(),
                  child: const Icon(Icons.copy),
                  onPress: currentUser == null
                      ? null
                      : () => _copyUsername(currentUser.username),
                ),
              ),
              FTile(
                prefix: const Icon(Icons.block_outlined),
                title: const Text('ブロックしているアカウント'),
                subtitle: Text(
                  blockedAsync.when(
                    data: (blocks) => blocks.isEmpty
                        ? 'ブロックしたユーザーの一覧と解除'
                        : 'ブロック中: ${blocks.length}件',
                    loading: () => '件数を読み込み中...',
                    error: (_, __) => '件数の取得に失敗しました',
                  ),
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (blockedCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$blockedCount件',
                          style: theme.typography.xs.copyWith(
                            color: theme.colors.primary,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    blockedAsync.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                  ],
                ),
                onPress: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BlockedAccountsScreen(),
                    ),
                  );
                  if (!mounted) return;
                  ref.invalidate(blockedAccountsProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: '通知',
            children: [
              _SwitchTile(
                icon: Icons.notifications_outlined,
                title: 'プッシュ通知',
                subtitle: 'アプリからのお知らせを受け取る',
                value: _pushNotifications,
                isBusy: _isUpdatingPush,
                statusText: _isUpdatingPush ? '保存中...' : null,
                onChanged: (value) {
                  if (_isUpdatingPush) return;
                  _updatePushNotifications(value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: '学習体験',
            children: [
              Builder(builder: (context) {
                final typingSettingsAsync = ref.watch(typingSettingsProvider);
                final typingSettings =
                    typingSettingsAsync.value ?? const TypingSettings();
                final typingController =
                    ref.read(typingSettingsProvider.notifier);
                final isTypingLoading = typingSettingsAsync.isLoading;

                return Column(
                  children: [
                    _SwitchTile(
                      icon: Icons.vibration,
                      title: '触覚フィードバック',
                      subtitle: 'キー入力時のバイブレーション',
                      value: typingSettings.hapticsEnabled,
                      isBusy: isTypingLoading,
                      onChanged: (value) {
                        if (isTypingLoading) return;
                        typingController.toggleHaptics(value);
                      },
                    ),
                    Divider(
                      color: theme.colors.border,
                    ),
                    _SwitchTile(
                      icon: Icons.lightbulb_outline,
                      title: 'ヒント表示',
                      subtitle: '次に押すキーを表示する',
                      value: typingSettings.hintsEnabled,
                      isBusy: isTypingLoading,
                      onChanged: (value) {
                        if (isTypingLoading) return;
                        typingController.toggleHints(value);
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: 'テーマ',
            children: [
              Builder(builder: (context) {
                final themeModeAsync = ref.watch(themeModeProvider);
                final themeMode = themeModeAsync.value ?? ThemeMode.dark;
                final controller = ref.read(themeModeProvider.notifier);
                final isLoading = themeModeAsync.isLoading;
                final isDark = themeMode == ThemeMode.dark;
                final themeLabel = isDark ? 'ダーク' : 'ライト';
                return _SwitchTile(
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  title: 'ダークテーマ',
                  subtitle: '現在: $themeLabel。オフで白基調のテーマに切り替え',
                  value: isDark,
                  isBusy: isLoading,
                  statusText: isLoading ? '保存中...' : null,
                  onChanged: (value) {
                    if (isLoading) return;
                    controller.toggle(value);
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: 'サポート',
            children: [
              FTile(
                prefix: const Icon(Icons.feedback_outlined),
                title: const Text('フィードバックを送る'),
                subtitle: Text(
                  '改善点や不具合の報告はこちらから',
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
                onPress: _showFeedbackSheet,
                suffix: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('アカウント操作', style: theme.typography.base.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    FTile(
                      prefix: const Icon(Icons.logout),
                      title: const Text('ログアウト'),
                      subtitle: Text(
                        '他のアカウントでログインする場合はこちら',
                        style: theme.typography.sm.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      onPress: _isLoggingOut ? null : _handleLogout,
                      suffix: _isLoggingOut
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.chevron_right),
                    ),
                    Divider(
                      color: theme.colors.destructive.withValues(alpha: 0.4),
                    ),
                    FTile(
                      prefix: Icon(
                        Icons.delete_forever_outlined,
                        color: theme.colors.destructive,
                      ),
                      title: Text(
                        'アカウントを削除',
                        style: TextStyle(color: theme.colors.destructive),
                      ),
                      subtitle: Text(
                        '投稿・学習記録をすべて削除します',
                        style: theme.typography.sm.copyWith(
                          color: theme.colors.destructive.withValues(alpha: 0.8),
                        ),
                      ),
                      onPress: _isLoggingOut ? null : _handleDeleteAccount,
                      suffix: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyUsername(String username) {
    Clipboard.setData(ClipboardData(text: '@$username'));
    SnackBarHelper.show(context, 'ユーザーIDをコピーしました');
  }

  Future<void> _updatePushNotifications(bool enabled) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _pushNotifications = enabled);
      return;
    }

    final previous = _pushNotifications;
    setState(() {
      _isUpdatingPush = true;
      _pushNotifications = enabled;
    });

    try {
      final updatedSettings = await ref
          .read(profileRepositoryProvider)
          .updateSettings(push: enabled);
      // ローカルのユーザー情報も更新
      final updatedUser = user.copyWith(settings: updatedSettings);
      ref.read(authStateProvider.notifier).updateUser(updatedUser);
    } catch (error) {
      // 失敗したら元に戻す
      setState(() => _pushNotifications = previous);
      ToastHelper.showError(context, 'プッシュ通知設定の更新に失敗しました');
    } finally {
      if (mounted) {
        setState(() => _isUpdatingPush = false);
      }
    }
  }

  Future<void> _editDisplayName(UserModel user) async {
    setState(() => _isUpdatingDisplayName = true);
    final controller = TextEditingController(text: user.displayName);
    String? errorText;
    bool saving = false;

    String? validate(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return '表示名を入力してください';
      if (trimmed.length > 40) return '40文字以内で入力してください';
      return null;
    }

    final newName = await showFDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context, style, animation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FDialog.adaptive(
              style: style,
              animation: animation,
              title: const Text('表示名を編集'),
              body: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 40,
                decoration: InputDecoration(
                  hintText: '表示名',
                  errorText: errorText,
                ),
                onChanged: (value) => setState(() {
                  errorText = validate(value);
                }),
              ),
              actions: [
                FButton(
                  style: FButtonStyle.outline(),
                  onPress: saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                FButton(
                  style: FButtonStyle.primary(),
                  onPress: saving
                      ? null
                      : () async {
                          final text = controller.text;
                          final error = validate(text);
                          if (error != null) {
                            setState(() => errorText = error);
                            return;
                          }
                          setState(() => saving = true);
                          try {
                            final repo = ref.read(profileRepositoryProvider);
                            final updated = await repo.updateProfile(
                              userId: user.id,
                              displayName: text.trim(),
                            );
                            Navigator.of(context).pop(updated.displayName);
                            ref.read(authStateProvider.notifier).updateUser(updated);
                          } catch (e) {
                            setState(() {
                              saving = false;
                              errorText = e.toString();
                            });
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );

    setState(() => _isUpdatingDisplayName = false);

    if (newName != null) {
      ToastHelper.show(context, '表示名を「$newName」に更新しました');
    }
  }

  void _showFeedbackSheet() {
    showFSheet<void>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.theme.colors.background,
            border: Border.symmetric(
              horizontal: BorderSide(color: context.theme.colors.border),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'フィードバックを送る',
                  style: context.theme.typography.xl2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colors.foreground,
                    height: 1.5,
                  ),
                ),
                Text(
                  '不具合の報告や改善のアイデアをメールでお送りください。',
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: context.theme.colors.primary.withValues(alpha: 0.06),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: context.theme.colors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _feedbackEmail,
                              style: context.theme.typography.base.copyWith(
                                color: context.theme.colors.foreground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'メールアプリで新規作成し、このアドレスに送信してください。',
                              style: context.theme.typography.xs.copyWith(
                                color: context.theme.colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FButton.icon(
                        style: FButtonStyle.ghost(),
                        onPress: () {
                          Clipboard.setData(
                            const ClipboardData(text: _feedbackEmail),
                          );
                          ToastHelper.show(context, 'メールアドレスをコピーしました');
                        },
                        child: const Icon(Icons.copy_outlined),
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
    this.withDividers = true,
  });

  final String title;
  final List<Widget> children;
  final bool withDividers;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.typography.base.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (withDividers && i != children.length - 1)
                  Divider(
                    color: theme.colors.border,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.isBusy = false,
    this.statusText,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final bool isBusy;
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final subtitleColor =
        theme.colors.mutedForeground;
    return Opacity(
      opacity: isBusy ? 0.85 : 1,
      child: FTile(
        prefix: icon != null ? Icon(icon) : null,
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: theme.typography.sm.copyWith(
                color: subtitleColor,
              ),
            ),
            if (statusText != null || isBusy)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  statusText ?? '保存中...',
                  style: theme.typography.xs.copyWith(
                    color: theme.colors.primary,
                  ),
                ),
              ),
          ],
        ),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isBusy)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            if (isBusy) const SizedBox(width: 8),
            AbsorbPointer(
              absorbing: isBusy,
              child: FSwitch(
                value: value,
                onChange: onChanged,
              ),
            ),
          ],
        ),
        onPress: isBusy ? null : () => onChanged(!value),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.displayName,
    required this.username,
    required this.profileImageUrl,
    required this.onEdit,
    required this.onCopyId,
    required this.isSaving,
  });

  final String displayName;
  final String username;
  final String? profileImageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onCopyId;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(
              displayName: displayName,
              imageUrl: profileImageUrl,
              radius: 28,
              backgroundColor: theme.colors.primary,
              foregroundColor: theme.colors.primaryForeground,
              textStyle: theme.typography.lg.copyWith(
                color: theme.colors.primaryForeground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.typography.lg.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        username,
                        style: theme.typography.sm.copyWith(
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      FButton.icon(
                        style: FButtonStyle.ghost(),
                        onPress: onCopyId,
                        child: const Icon(Icons.copy_outlined, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FButton(
              style: FButtonStyle.ghost(),
              onPress: onEdit,
              child: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('編集'),
            ),
          ],
        ),
      ),
    );
  }
}
