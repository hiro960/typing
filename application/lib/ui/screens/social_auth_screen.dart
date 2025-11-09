import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../shell/app_shell.dart';
import 'profile_setup_screen.dart';

class SocialAuthScreen extends StatelessWidget {
  const SocialAuthScreen({super.key});

  void _handleProviderTap(BuildContext context, {required bool needsProfile}) {
    if (needsProfile) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ProfileSetupScreen()),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const providers = [
      (label: 'Google で続ける', icon: Icons.g_translate),
      (label: 'Apple で続ける', icon: Icons.apple),
      (label: 'X で続ける', icon: Icons.alternate_email),
    ];

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: const Text('ログイン / 新規登録'),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SNSアカウントで一度のログイン。メールやパスワードは不要です。',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            FCard.raw(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.security_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      '毎日の学習を1タップで開始',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '各SNSの認証ページへ移動し、許可するとアプリに戻ります。',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...providers.map(
              (provider) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FButton(
                  onPress: () =>
                      _handleProviderTap(context, needsProfile: true),
                  style: FButtonStyle.secondary(),
                  prefix: Icon(provider.icon),
                  child: Text(provider.label),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'ログイン後、表示名やユーザー名が未設定の場合はプロフィールのセットアップ画面が開きます。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
