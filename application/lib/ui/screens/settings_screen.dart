import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:characters/characters.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import 'settings/blocked_accounts_screen.dart';
import '../../features/profile/domain/providers/profile_providers.dart';
import '../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../features/typing/data/models/typing_settings.dart';
import '../../features/theme/theme_mode_provider.dart';
import '../../features/diary/domain/providers/diary_providers.dart';
import '../utils/dialog_helper.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/user_avatar.dart';
import '../app_spacing.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ログアウトに失敗しました: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                          color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$blockedCount件',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
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
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
              Text('アカウント操作', style: theme.textTheme.titleMedium),
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
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
                      color: theme.colorScheme.error.withValues(alpha: 0.4),
                    ),
                    FTile(
                      prefix: Icon(
                        Icons.delete_forever_outlined,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'アカウントを削除',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      subtitle: Text(
                        '投稿・学習記録をすべて削除します',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error.withValues(alpha: 0.8),
                        ),
                      ),
                      onPress: () {},
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
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        const SnackBar(content: Text('プッシュ通知設定の更新に失敗しました')),
      );
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

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('表示名を編集'),
              content: TextField(
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
                      const SizedBox(height: AppSpacing.sm),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('表示名を「$newName」に更新しました')),
      );
    }
  }

  void _showFeedbackSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('フィードバックを送る', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                '不具合の報告や改善のアイデアをメールでお送りください。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _feedbackEmail,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'メールアプリで新規作成し、このアドレスに送信してください。',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('メールアドレスをコピーしました')),
                        );
                      },
                      child: const Icon(Icons.copy_outlined),
                    ),
                  ],
                ),
              ),
            ],
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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (withDividers && i != children.length - 1)
                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
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
    final theme = Theme.of(context);
    final subtitleColor =
        theme.colorScheme.onSurface.withValues(alpha: 0.6);
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: subtitleColor,
              ),
            ),
            if (statusText != null || isBusy)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  statusText ?? '保存中...',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(
              displayName: displayName,
              imageUrl: profileImageUrl,
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              textStyle: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        username,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
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
