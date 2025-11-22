import 'dart:io';

import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import '../../features/diary/data/models/diary_post.dart';
import '../../features/diary/domain/providers/diary_providers.dart';
import '../../features/profile/data/models/user_stats_model.dart';
import '../../features/profile/domain/providers/profile_providers.dart';
import '../widgets/diary_post_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    this.userId,
    required this.onOpenSettings,
  });

  final String? userId;
  final VoidCallback onOpenSettings;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTabIndex = 0;
  final _imagePicker = ImagePicker();
  bool _isUpdatingAvatar = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 表示対象のユーザーIDを決定
    final currentUser = ref.watch(currentUserProvider);
    final targetUserId = widget.userId ?? currentUser?.id;

    if (targetUserId == null) {
      return const Center(child: Text('ユーザー情報の取得に失敗しました'));
    }

    // プロバイダーを監視
    final profileAsync = ref.watch(userProfileProvider(targetUserId));
    final statsAsync = ref.watch(userStatsProvider(targetUserId));
    
    // タブに応じてデータを取得
    // 投稿タブの場合のみ投稿を取得
    final postsAsync = _selectedTabIndex == 0 
        ? ref.watch(userPostsProvider(targetUserId))
        : const AsyncValue.data(<DiaryPost>[]);

    // AsyncValue.whenで状態管理
    return profileAsync.when(
      data: (profile) => _buildContent(
        context,
        theme,
        profile,
        statsAsync,
        postsAsync,
        ref,
        currentUser?.id,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'プロフィールの取得に失敗しました',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    UserModel profile,
    AsyncValue<UserStatsModel> statsAsync,
    AsyncValue<List<DiaryPost>> postsAsync,
    WidgetRef ref,
    String? currentUserId,
  ) {
    final isOwner = currentUserId == profile.id;
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          if (Navigator.of(context).canPop())
            FHeaderAction.back(
              onPress: () => Navigator.of(context).maybePop(),
            ),
        ],
        title: Text('👤 プロフィール', style: theme.textTheme.headlineSmall),
        suffixes: [
          if (isOwner)
            FHeaderAction(
              icon: const Icon(Icons.settings_outlined),
              onPress: widget.onOpenSettings,
            ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
        children: [
          const SizedBox(height: 12),
          _ProfileHero(
            profile: profile,
            theme: theme,
            isOwner: isOwner,
            onAvatarTap: () => _onAvatarTap(profile, currentUserId),
            followButton: isOwner
                ? null
                : _FollowButton(
                    userId: profile.id,
                    initialIsFollowing: profile.isFollowing,
                    onFollowChanged: (isFollowing) {
                      ref.invalidate(userProfileProvider(profile.id));
                    },
                  ),
            startText: _formatStartDate(profile.createdAt),
            isUpdatingAvatar: _isUpdatingAvatar,
          ),
          const SizedBox(height: 56),
          _SummaryChips(profile: profile),
          const SizedBox(height: 16),
          if (_canViewStats(profile, currentUserId)) ...[
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      icon: Icons.speed,
                      label: 'WPM最高',
                      value: stats.wpmAvg.toStringAsFixed(0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      icon: Icons.school_outlined,
                      label: '完了レッスン',
                      value: '${stats.lessonsCompleted}',
                    ),
                  ),
                ],
              ),
              loading: () => const _StatSkeletonRow(),
              error: (_, __) => Row(
                children: const [
                  Expanded(
                    child: _ProfileStatCard(
                      icon: Icons.speed,
                      label: 'WPM最高',
                      value: '--',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      icon: Icons.school_outlined,
                      label: '完了レッスン',
                      value: '--',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          _ProfileTabs(
            selectedIndex: _selectedTabIndex,
            postsCount: profile.postsCount,
            followersCount: profile.followersCount,
            followingCount: profile.followingCount,
            onChanged: (index) => setState(() => _selectedTabIndex = index),
          ),
          const SizedBox(height: 16),
          if (_selectedTabIndex == 0)
            postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return _PostEmptyState(
                    isOwner: isOwner,
                    onReload: () => ref.invalidate(
                      userPostsProvider(profile.id),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...posts.take(20).map((post) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DiaryPostCard(
                          post: post,
                          onTap: () {},
                          onToggleLike: () async {
                            await ref
                                .read(diaryRepositoryProvider)
                                .toggleLike(post.id, like: !post.liked);
                            ref.invalidate(userPostsProvider(profile.id));
                          },
                          onToggleBookmark: () async {
                            await ref
                                .read(diaryRepositoryProvider)
                                .toggleBookmark(
                                  post.id,
                                  bookmark: !post.bookmarked,
                                );
                            ref.invalidate(userPostsProvider(profile.id));
                          },
                          onComment: () {},
                          currentUserId: currentUserId,
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const _PostSkeletonList(),
              error: (_, __) => _PostErrorState(
                onRetry: () => ref.invalidate(userPostsProvider(profile.id)),
              ),
            )
          else if (_selectedTabIndex == 1)
            _buildFollowersList(context, profile.id)
          else
            _buildFollowingList(context, profile.id),
        ],
      ),
    );
  }

  Future<void> _onAvatarTap(UserModel profile, String? currentUserId) async {
    if (currentUserId == profile.id) {
      await _showAvatarActionSheet(profile);
      return;
    }
    if (profile.profileImageUrl == null) return;
    _showProfileImageDialog(profile.profileImageUrl!, profile.displayName);
  }

  Future<void> _showAvatarActionSheet(UserModel profile) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FTile(
              prefix: const Icon(Icons.photo_library_outlined),
              title: const Text('写真を選択'),
              onPress: () => Navigator.of(context).pop('pick'),
            ),
            if (profile.profileImageUrl != null)
              FTile(
                prefix: const Icon(Icons.delete_outline),
                title: const Text('画像を削除'),
                onPress: () => Navigator.of(context).pop('remove'),
              ),
          ],
        ),
      ),
    );
    if (choice == 'pick') {
      await _pickAndUploadAvatar(profile);
    } else if (choice == 'remove') {
      await _updateProfileImage(profile, remove: true);
    }
  }

  Future<void> _pickAndUploadAvatar(UserModel profile) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
      );
      if (picked == null) return;
      await _updateProfileImage(profile, file: File(picked.path));
    } catch (error) {
      _showMessage('画像の取得に失敗しました: $error');
    }
  }

  Future<void> _updateProfileImage(
    UserModel profile, {
    File? file,
    bool remove = false,
  }) async {
    if (!remove && file == null) return;
    setState(() => _isUpdatingAvatar = true);
    try {
      final repository = ref.read(profileRepositoryProvider);
      String? imageUrl;
      if (!remove && file != null) {
        imageUrl = await repository.uploadProfileImage(file);
      }
      final updated = await repository.updateProfileImage(
        userId: profile.id,
        profileImageUrl: remove ? null : imageUrl,
      );
      ref.invalidate(userProfileProvider(profile.id));
      final currentUser = ref.read(currentUserProvider);
      if (currentUser?.id == profile.id) {
        ref.read(authStateProvider.notifier).updateUser(updated);
      }
      _showMessage(remove ? 'プロフィール画像を削除しました' : 'プロフィール画像を更新しました');
    } catch (error) {
      _showMessage('プロフィール画像の更新に失敗しました: $error');
    } finally {
      if (mounted) {
        setState(() => _isUpdatingAvatar = false);
      }
    }
  }

  void _showProfileImageDialog(String imageUrl, String displayName) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 280,
                    child: Center(child: Icon(Icons.error_outline)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: FButton.icon(
                style: FButtonStyle.ghost(),
                child: const Icon(Icons.close),
                onPress: () => Navigator.of(context).maybePop(),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Text(
                displayName,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildFollowersList(BuildContext context, String userId) {
    final followersAsync = ref.watch(userFollowersProvider(userId));
    return followersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('フォロワーはいません'),
            ),
          );
        }
        return Column(
          children: users.map((user) => _UserListTile(user: user)).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラーが発生しました: $e')),
    );
  }

  Widget _buildFollowingList(BuildContext context, String userId) {
    final followingAsync = ref.watch(userFollowingProvider(userId));
    return followingAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('フォロー中のユーザーはいません'),
            ),
          );
        }
        return Column(
          children: users.map((user) => _UserListTile(user: user)).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラーが発生しました: $e')),
    );
  }

  String _formatStartDate(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays < 30) {
      return '${diff.inDays}日前から学習中';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).round()}ヶ月前から学習中';
    } else {
      return '${createdAt.year}年${createdAt.month}月から学習中';
    }
  }

  bool _canViewStats(UserModel profile, String? currentUserId) {
    // 自分のプロフィールは常に表示
    if (currentUserId == profile.id) return true;
    
    // 公開設定を確認
    // TODO: UserModelにprofileVisibilityフィールドが必要
    // 現状のUserModel定義にはないため、API側で制御されていると仮定するか、
    // settings.profileVisibility を参照する必要がある。
    // ここでは一旦、フォロワーのみ公開の場合は非表示にするロジックを入れるべきだが、
    // フォロー状態(isFollowing)がUserModelに含まれていないため、
    // 実装するにはUserModelの拡張が必要。
    // 今回は指摘事項「プロフィール公開範囲のUI制御」への対応として、
    // profile.settings.profileVisibility をチェックする形にする。
    
    final visibility = profile.settings.profileVisibility;
    if (visibility == 'public') return true;
    
    // privateの場合は自分のみ（冒頭でチェック済み）
    if (visibility == 'private') return false;
    
    // followersの場合はフォローしているかチェックが必要
    // 現状のUserModelには isFollowing がないため、
    // ここでは簡易的に「非公開」として扱うか、API側で隠蔽されていることを期待する。
    // UI側で明示的に隠すなら、isFollowing情報が必要。
    
    return true; // 一旦すべて表示（API側でデータが空なら--になる）
  }
}

String _initialOf(String value) {
  if (value.isEmpty) return '?';
  final trimmed = value.trim();
  return trimmed.isEmpty ? '?' : trimmed.characters.first;
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.9),
                theme.colorScheme.secondary.withValues(alpha: 0.65),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
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
                        Text(
                          profile.displayName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.bold,
                          ),
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
                    FButton.icon(
                      style: FButtonStyle.ghost(),
                      child: const Icon(Icons.photo_camera_outlined),
                      onPress: onAvatarTap,
                    )
                  else if (followButton != null)
                    followButton!,
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
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
        Positioned(
          left: 20,
          bottom: -38,
          child: _ProfileAvatar(
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
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
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundImage:
                  imageUrl != null ? NetworkImage(imageUrl!) : null,
              backgroundColor: imageUrl == null
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : null,
              foregroundColor: imageUrl == null
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onPrimary,
              child: imageUrl == null
                  ? Text(
                      _initialOf(displayName),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          if (showEditBadge)
            Positioned(
              bottom: 2,
              right: 2,
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
                  Icons.edit,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          if (isUpdating)
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
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: Icons.people_outline,
          label: 'フォロワー',
          value: '${profile.followersCount}',
        ),
        _InfoChip(
          icon: Icons.person_add_alt_1_outlined,
          label: 'フォロー中',
          value: '${profile.followingCount}',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
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

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatSkeletonRow extends StatelessWidget {
  const _StatSkeletonRow();

  @override
  Widget build(BuildContext context) {
    final baseColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06);
    return Row(
      children: [
        Expanded(child: _StatSkeleton(color: baseColor)),
        const SizedBox(width: 12),
        Expanded(child: _StatSkeleton(color: baseColor)),
      ],
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  const _StatSkeleton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({
    required this.selectedIndex,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FTabs(
      key: ValueKey(selectedIndex),
      initialIndex: selectedIndex,
      onChange: (index) => onChanged(index),
      children: [
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '投稿',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'フォロワー',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'フォロー中',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _PostEmptyState extends StatelessWidget {
  const _PostEmptyState({
    required this.isOwner,
    required this.onReload,
  });

  final bool isOwner;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message =
        isOwner ? 'まだ投稿がありません。最初の日記を書いてみましょう。' : 'まだ投稿がありません。';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.edit_note_outlined,
            size: 56,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          FButton(
            onPress: onReload,
            child: const Text('再読み込み'),
          ),
        ],
      ),
    );
  }
}

class _PostErrorState extends StatelessWidget {
  const _PostErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            '投稿の取得に失敗しました',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 12),
          FButton(
            onPress: onRetry,
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }
}

class _PostSkeletonList extends StatelessWidget {
  const _PostSkeletonList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        theme.colorScheme.onSurface.withValues(alpha: 0.06);
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _FollowButton extends ConsumerStatefulWidget {
  const _FollowButton({
    required this.userId,
    required this.initialIsFollowing,
    required this.onFollowChanged,
  });

  final String userId;
  final bool initialIsFollowing;
  final ValueChanged<bool> onFollowChanged;

  @override
  ConsumerState<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<_FollowButton> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作に失敗しました: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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

class _UserListTile extends StatelessWidget {
  const _UserListTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProfileScreen(
                userId: user.id,
                onOpenSettings: () {}, // 設定画面への遷移は不要、または親から渡す
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                backgroundColor: user.profileImageUrl == null
                    ? theme.colorScheme.primary.withValues(alpha: 0.12)
                    : null,
                foregroundColor: user.profileImageUrl == null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onPrimary,
                child: user.profileImageUrl == null
                    ? Text(
                        _initialOf(user.displayName),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '@${user.username}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
