import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/domain/providers/auth_providers.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/logger.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isCheckingUsername = false;
  String? _usernameError;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// ユーザー名のバリデーション
  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return null; // 空の場合はチェックしない
    }

    // 3〜20文字
    if (username.length < 3 || username.length > 20) {
      return 'ユーザー名は3〜20文字で入力してください';
    }

    // 英数字とアンダースコアのみ
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(username)) {
      return '英数字とアンダースコアのみ使用できます';
    }

    return null;
  }

  /// ユーザー名の重複チェック (デバウンス付き)
  void _checkUsernameAvailability(String username) {
    setState(() {
      _usernameError = _validateUsername(username);
    });

    if (_usernameError != null || username.isEmpty) {
      return;
    }

    // デバウンス処理 (500ms)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isCheckingUsername = true;
      });

      try {
        final isAvailable =
            await ref.read(authRepositoryProvider).checkUsernameAvailability(username);

        if (mounted) {
          setState(() {
            _usernameError = isAvailable ? null : 'このユーザー名は既に使用されています';
            _isCheckingUsername = false;
          });
        }
      } catch (e) {
        AppLogger.error('Failed to check username availability', tag: 'ProfileSetup', error: e);
        if (mounted) {
          setState(() {
            _usernameError = 'ユーザー名の確認に失敗しました';
            _isCheckingUsername = false;
          });
        }
      }
    });
  }

  /// プロフィール設定を完了
  Future<void> _completeSetup() async {
    if (_isLoading || !_canSubmit) return;

    final displayName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    final bio = _bioController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // ユーザー登録API呼び出し
      await ref.read(authStateProvider.notifier).setupUser(
            username: username,
            displayName: displayName,
            bio: bio.isNotEmpty ? bio : null,
          );

      AppLogger.auth('User setup completed successfully');

      // 成功した場合、AppShellが自動的にホーム画面に遷移する
    } on ApiException catch (e) {
      AppLogger.error('API error during user setup', tag: 'ProfileSetup', error: e);

      if (mounted) {
        String message = e.message;

        // 特定のエラーコードに応じたメッセージ
        if (e.code == 'CONFLICT') {
          if (e.message.contains('Username')) {
            message = 'このユーザー名は既に使用されています';
          } else {
            message = '既に登録済みです';
          }
        }

        _showErrorDialog(message);
      }
    } catch (e) {
      AppLogger.error('Unexpected error during user setup', tag: 'ProfileSetup', error: e);

      if (mounted) {
        _showErrorDialog('ユーザー登録に失敗しました。時間をおいて再試行してください。');
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
    // refをキャプチャ (widgetがunmountされた後でも使用可能)
    final authNotifier = ref.read(authStateProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // ログアウトしてログイン画面に戻る
              await authNotifier.logout();
            },
            child: const Text('再ログイン'),
          ),
        ],
      ),
    );
  }

  bool get _canSubmit =>
      _displayNameController.text.trim().isNotEmpty &&
      _usernameController.text.trim().isNotEmpty &&
      _usernameError == null &&
      !_isCheckingUsername;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FHeaderAction.back(onPress: () => Navigator.of(context).maybePop()),
        ],
        title: const Text('プロフィールの設定'),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      child: Icon(Icons.person, size: 48, color: Colors.white),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'プロフィール画像を選択',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _SetupField(
                    controller: _displayNameController,
                    label: '表示名',
                    hint: '例: Hana Suzuki',
                    helper: 'いつでも変更できます。',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  _SetupField(
                    controller: _usernameController,
                    label: 'ユーザー名',
                    prefixText: '@',
                    hint: 'hana_typing',
                    helper: '30日に1回のみ変更できます。',
                    errorText: _usernameError,
                    isValidating: _isCheckingUsername,
                    onChanged: (value) {
                      setState(() {});
                      _checkUsernameAvailability(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: '自己紹介',
                        hintText: '推し活や学習スタイルを自由に入力',
                        filled: true,
                        fillColor: theme.colorScheme.surface.withValues(
                          alpha: 0.4,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '表示名とユーザー名はタイムラインやフォローリストに表示されます。'
            'ユーザー名は重複不可で、変更は30日に1回だけです。',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          FButton(
            onPress: _canSubmit && !_isLoading ? _completeSetup : null,
            child: Text(_isLoading ? '登録中...' : '保存してはじめる'),
          ),
        ],
      ),
    );
  }
}

class _SetupField extends StatelessWidget {
  const _SetupField({
    required this.controller,
    required this.label,
    required this.hint,
    this.helper,
    this.prefixText,
    this.onChanged,
    this.errorText,
    this.isValidating = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? helper;
  final String? prefixText;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool isValidating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefixText,
          helperText: helper,
          errorText: errorText,
          filled: true,
          fillColor: theme.colorScheme.surface.withValues(alpha: 0.4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          suffixIcon: isValidating
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : errorText == null && controller.text.trim().isNotEmpty
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
        ),
      ),
    );
  }
}
