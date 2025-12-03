import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/auth/data/models/user_status_response.dart';
import '../../../features/profile/domain/providers/profile_providers.dart';
import '../../../core/exceptions/app_exception.dart';
import '../../../core/utils/logger.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_page_scaffold.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _isCheckingUsername = false;
  String? _usernameError;
  Timer? _debounceTimer;
  File? _selectedImage;

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

  /// 画像を選択
  Future<void> _pickImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
      );
      if (picked == null) return;
      setState(() {
        _selectedImage = File(picked.path);
      });
    } catch (error) {
      AppLogger.error('Failed to pick image', tag: 'ProfileSetup', error: error);
      if (mounted) {
        SnackBarHelper.showError(context, error);
      }
    }
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
      // 1. ユーザー登録（画像なしで）
      AppLogger.info('Registering user...', tag: 'ProfileSetup');
      final request = UserSetupRequest(
        username: username,
        displayName: displayName,
        bio: bio.isNotEmpty ? bio : null,
      );
      final authRepository = ref.read(authRepositoryProvider);
      var user = await authRepository.setupUser(request);
      AppLogger.auth('User registered successfully: ${user.id}');

      // 2. 画像が選択されている場合は登録後にアップロード
      if (_selectedImage != null) {
        AppLogger.info('Uploading profile image...', tag: 'ProfileSetup');
        final profileRepository = ref.read(profileRepositoryProvider);
        final imageUrl = await profileRepository.uploadProfileImage(_selectedImage!);
        AppLogger.info('Profile image uploaded: $imageUrl', tag: 'ProfileSetup');

        // 3. プロフィール画像を更新
        user = await profileRepository.updateProfileImage(
          userId: user.id,
          profileImageUrl: imageUrl,
        );
        AppLogger.info('Profile image updated', tag: 'ProfileSetup');
      }

      // 4. 認証状態を更新（これでホーム画面に遷移）
      ref.read(authStateProvider.notifier).updateUser(user);
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

    showFDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context, style, animation) => FDialog.adaptive(
        style: style,
        animation: animation,
        title: const Text('エラー'),
        body: Text(message),
        actions: [
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FButton(
            style: FButtonStyle.primary(),
            onPress: () async {
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
    return AppPageScaffold(
      title: 'プロフィールの設定',
      showBackButton: true,
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
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.person, size: 48, color: Colors.white)
                          : null,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedImage != null ? 'タップで変更' : 'プロフィール画像を選択',
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
                    helper: '変更できません。',
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
            'ユーザー名は重複不可で、変更はできません。',
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
