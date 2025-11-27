import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/domain/providers/auth_providers.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/logger.dart';

class SocialAuthScreen extends ConsumerStatefulWidget {
  const SocialAuthScreen({super.key});

  @override
  ConsumerState<SocialAuthScreen> createState() => _SocialAuthScreenState();
}

class _SocialAuthScreenState extends ConsumerState<SocialAuthScreen> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Auth0でログイン
      await ref.read(authStateProvider.notifier).login();

      // 成功した場合、listenManualが検知して自動的に画面を閉じる
      AppLogger.auth('Login successful in SocialAuthScreen');
    } on AuthException catch (e) {
      AppLogger.error('Auth error during login', tag: 'SocialAuthScreen', error: e);

      if (mounted) {
        // ユーザーがキャンセルした場合はエラーを表示しない
        if (e.code != 'LOGIN_CANCELLED') {
          _showErrorDialog(e.message);
        }
      }
    } catch (e) {
      AppLogger.error('Unexpected error during login', tag: 'SocialAuthScreen', error: e);

      if (mounted) {
        _showErrorDialog('ログインに失敗しました。時間をおいて再試行してください。');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showFDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: const Text('ログインエラー'),
        body: Text(message),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 認証状態の変化を監視し、認証済み状態になったら画面を閉じる
    ref.listen<AuthStateData>(
      authStateProvider,
      (previous, next) {
        if (next.status == AuthStatus.authenticated ||
            next.status == AuthStatus.authenticatedButNotRegistered) {
          // ログイン成功したので、この画面を閉じる
          AppLogger.auth('Auth state changed to ${next.status}, popping screen');
          Navigator.of(context).pop();
        }
      },
    );

    final theme = Theme.of(context);
    const providers = [
      (label: 'Google / Apple / X で続ける', icon: Icons.login),
    ];

    return FScaffold(
      header: FHeader.nested(
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
                      '認証ページへ移動し、SNSで認証を行います。',
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
                  onPress: _isLoading ? null : _handleLogin,
                  style: FButtonStyle.primary(),
                  prefix: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(provider.icon),
                  child: Text(_isLoading ? 'ログイン中...' : provider.label),
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
