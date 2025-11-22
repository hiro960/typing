import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/domain/providers/auth_providers.dart';
import 'settings/blocked_accounts_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _dailyReminder = true;
  bool _streakAlerts = true;
  bool _keySounds = true;
  bool _haptics = true;
  bool _showHints = true;
  bool _highContrast = false;
  double _dailyGoal = 15;
  bool _isLoggingOut = false;

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
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: const Text('設定'),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          _SettingsSection(
            title: 'アカウント',
            children: [
              _SettingsTile(
                title: '表示名',
                subtitle: 'Hana Suzuki',
                trailing: TextButton(onPressed: () {}, child: const Text('編集')),
              ),
              _SettingsTile(
                title: 'ユーザーID',
                subtitle: '@hana_typing',
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {},
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
                onChanged: (value) =>
                    setState(() => _pushNotifications = value),
              ),
              _SwitchTile(
                title: '学習リマインダー',
                subtitle: '毎日19時にリマインド',
                value: _dailyReminder,
                onChanged: (value) => setState(() => _dailyReminder = value),
              ),
              _SwitchTile(
                title: 'ストリーク警告',
                subtitle: 'ストリーク終了前に通知',
                value: _streakAlerts,
                onChanged: (value) => setState(() => _streakAlerts = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: '学習体験',
            children: [
              _SwitchTile(
                title: 'キー音',
                subtitle: 'タイプ音でリズムを把握',
                value: _keySounds,
                onChanged: (value) => setState(() => _keySounds = value),
              ),
              _SwitchTile(
                title: 'ハプティクス',
                subtitle: '正解/不正解で軽い振動',
                value: _haptics,
                onChanged: (value) => setState(() => _haptics = value),
              ),
              _SwitchTile(
                title: 'ヒント表示',
                subtitle: '入力時にヒントを表示',
                value: _showHints,
                onChanged: (value) => setState(() => _showHints = value),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1日の目標時間', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${_dailyGoal.round()}分',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Slider(
                        value: _dailyGoal,
                        min: 5,
                        max: 30,
                        divisions: 5,
                        label: '${_dailyGoal.round()}分',
                        onChanged: (value) =>
                            setState(() => _dailyGoal = value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'テーマ',
            children: [
              _SettingsTile(
                title: 'ダークテーマ',
                subtitle: '黒基調 + 青アクセント',
                trailing: const Icon(Icons.lock_outline),
              ),
              _SwitchTile(
                title: 'ハイコントラストモード',
                subtitle: '文字コントラストを強調',
                value: _highContrast,
                onChanged: (value) => setState(() => _highContrast = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'データ & サポート',
            withDividers: false,
            children: [
              FButton(
                onPress: () {},
                style: FButtonStyle.secondary(),
                child: const Text('学習履歴をエクスポート'),
              ),
              const SizedBox(height: 12),
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
