import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import 'settings/blocked_accounts_screen.dart';
import '../../features/profile/domain/providers/profile_providers.dart';
import '../../features/typing/domain/providers/typing_settings_provider.dart';
import '../../features/typing/data/models/typing_settings.dart';
import '../../features/theme/theme_mode_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('本当にログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

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
    final displayName = currentUser?.displayName ?? '未設定';
    final username = currentUser?.username != null ? '@${currentUser!.username}' : '--';
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: const Text('設定'),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          _SettingsSection(
            title: 'アカウント',
            children: [
              _SettingsTile(
                title: '表示名',
                subtitle: displayName,
                trailing: TextButton(
                  onPressed: currentUser == null || _isUpdatingDisplayName
                      ? null
                      : () => _editDisplayName(currentUser),
                  child: _isUpdatingDisplayName
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('編集'),
                ),
              ),
              _SettingsTile(
                title: 'ユーザーID',
                subtitle: username,
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: currentUser == null
                      ? null
                      : () => _copyUsername(currentUser.username),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('ブロックしているアカウント'),
                  subtitle: Text(
                    'ブロックしたユーザーの一覧と解除',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BlockedAccountsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: '通知',
            children: [
              _SwitchTile(
                title: 'プッシュ通知',
                subtitle: 'アプリからのお知らせを受け取る',
                value: _pushNotifications,
                onChanged: (value) {
                  if (_isUpdatingPush) return;
                  _updatePushNotifications(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                      title: '触覚フィードバック',
                      subtitle: 'キー入力時のバイブレーション',
                      value: typingSettings.hapticsEnabled,
                      onChanged: (value) {
                        if (isTypingLoading) return;
                        typingController.toggleHaptics(value);
                      },
                    ),
                    _SwitchTile(
                      title: 'ヒント表示',
                      subtitle: '次に押すキーを表示する',
                      value: typingSettings.hintsEnabled,
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
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'テーマ',
            children: [
              Builder(builder: (context) {
                final themeModeAsync = ref.watch(themeModeProvider);
                final themeMode = themeModeAsync.value ?? ThemeMode.dark;
                final controller = ref.read(themeModeProvider.notifier);
                final isLoading = themeModeAsync.isLoading;
                final isDark = themeMode == ThemeMode.dark;
                return _SwitchTile(
                  title: 'ダークテーマ',
                  subtitle: 'オフで白基調のテーマに切り替え',
                  value: isDark,
                  onChanged: (value) {
                    if (isLoading) return;
                    controller.toggle(value);
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'データ & サポート',
            withDividers: false,
            children: [
              FButton(
                onPress: () {},
                style: FButtonStyle.outline(),
                child: const Text('フィードバックを送る'),
              ),
              const SizedBox(height: 12),
              FButton(
                onPress: _isLoggingOut ? null : _handleLogout,
                style: FButtonStyle.secondary(),
                child: _isLoggingOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('ログアウト'),
              ),
              const SizedBox(height: 8),
              FButton(
                onPress: () {},
                style: FButtonStyle.destructive(),
                child: const Text('アカウントを削除'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyUsername(String username) {
    Clipboard.setData(ClipboardData(text: '@$username'));
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      const SnackBar(content: Text('ユーザーIDをコピーしました')),
    );
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
                TextButton(
                  onPressed: saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: saving
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
        FCard.raw(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (withDividers && i != children.length - 1)
                    Divider(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Material(color: Colors.transparent, child: trailing),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: value,
        onChanged: onChanged,
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
