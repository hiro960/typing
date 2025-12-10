import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/auth/data/models/user_model.dart';
import '../../../features/profile/domain/providers/profile_providers.dart';
import '../../app_theme.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/verified_badge.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.profile,
    required this.theme,
    required this.isOwner,
    required this.onAvatarTap,
    required this.followButton,
    required this.startText,
    required this.isUpdatingAvatar,
  });

  final UserModel profile;
  final ThemeData theme;
  final bool isOwner;
  final VoidCallback onAvatarTap;
  final Widget? followButton;
  final String startText;
  final bool isUpdatingAvatar;

  @override
  Widget build(BuildContext context) {
    final foreground = theme.colorScheme.onPrimary;
    // アバターの半径46 + 下にはみ出す分38 = 余分な高さが必要
    const avatarOverflow = 38.0;

    return Stack(
      children: [
        // 下部にアバターのはみ出し分のスペースを確保
        Padding(
          padding: const EdgeInsets.only(bottom: avatarOverflow),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryBright.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserNameWithBadge(
                            displayName: profile.displayName,
                            userType: profile.type,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: foreground,
                              fontWeight: FontWeight.bold,
                            ),
                            badgeSize: VerifiedBadgeSize.large,
                            spacing: 8,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${profile.username}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: foreground.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isOwner)
                      Material(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Iconsax.camera),
                          color: foreground,
                          onPressed: onAvatarTap,
                        ),
                      )
                    else if (followButton != null)
                      followButton!,
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      size: 16,
                      color: foreground.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      startText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: foreground.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    profile.bio!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foreground.withValues(alpha: 0.95),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
        // アバターをStack内に配置（bottom: 0でStack下端に揃える）
        Positioned(
          left: 20,
          bottom: 0,
          child: ProfileAvatar(
            imageUrl: profile.profileImageUrl,
            displayName: profile.displayName,
            onTap: onAvatarTap,
            showEditBadge: isOwner,
            isUpdating: isUpdatingAvatar,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.displayName,
    required this.onTap,
    required this.showEditBadge,
    required this.isUpdating,
    required this.theme,
  });

  final String? imageUrl;
  final String displayName;
  final VoidCallback onTap;
  final bool showEditBadge;
  final bool isUpdating;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    Widget avatar = UserAvatar(
      displayName: displayName,
      imageUrl: imageUrl,
      radius: 46,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      showShadow: true,
      onTap: onTap,
      badge: showEditBadge
          ? GestureDetector(
              onTap: onTap,
              child: Container(
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
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Iconsax.edit,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            )
          : null,
    );

    // カスタムのローディング表示を追加
    if (isUpdating) {
      avatar = Stack(
        children: [
          avatar,
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }
}

class SummaryChips extends StatelessWidget {
  const SummaryChips({super.key, required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        InfoChip(
          icon: Iconsax.people,
          label: 'フォロワー',
          value: '${profile.followersCount}',
          isDark: isDark,
        ),
        InfoChip(
          icon: Iconsax.user_add,
          label: 'フォロー中',
          value: '${profile.followingCount}',
          isDark: isDark,
        ),
      ],
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surface, AppColors.surfaceAlt]
              : [AppColors.lightSurface, AppColors.lightSurfaceAlt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.4)
              : AppColors.lightBorder.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class FollowButton extends ConsumerStatefulWidget {
  const FollowButton({
    super.key,
    required this.userId,
    required this.initialIsFollowing,
    required this.onFollowChanged,
  });

  final String userId;
  final bool initialIsFollowing;
  final ValueChanged<bool> onFollowChanged;

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  late bool _isFollowing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialIsFollowing;
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(profileRepositoryProvider);
      if (_isFollowing) {
        await repository.unfollowUser(widget.userId);
      } else {
        await repository.followUser(widget.userId);
      }

      if (mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
          _isLoading = false;
        });
        widget.onFollowChanged(_isFollowing);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ToastHelper.showError(context, '操作に失敗しました: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: _isLoading ? null : _toggleFollow,
      style: _isFollowing ? FButtonStyle.secondary() : FButtonStyle.primary(),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(_isFollowing ? 'フォロー中' : 'フォローする'),
    );
  }
}
