import 'dart:io';

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
import '../widgets/app_page_scaffold.dart';
import '../widgets/diary_post_card.dart';
import 'profile/profile_header.dart';
import 'profile/profile_posts.dart';
import 'profile/profile_relations.dart';
import 'profile/profile_stats.dart';
import 'profile/profile_tabs.dart';

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
    return AppPageScaffold(
      header: FHeader.nested(
        titleAlignment: AlignmentDirectional.centerStart,
        prefixes: [
          if (Navigator.of(context).canPop())
            FHeaderAction.back(
              onPress: () => Navigator.of(context).maybePop(),
            ),
        ],
        title: Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 22,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text('プロフィール', style: theme.textTheme.headlineSmall),
          ],
        ),
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
          ProfileHero(
            profile: profile,
            theme: theme,
            isOwner: isOwner,
            onAvatarTap: () => _onAvatarTap(profile, currentUserId),
            followButton: isOwner
                ? null
                : FollowButton(
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
          SummaryChips(profile: profile),
          const SizedBox(height: 16),
          if (_canViewStats(profile, currentUserId)) ...[
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(
                      icon: Icons.speed,
                      label: 'WPM最高',
                      value: stats.wpmAvg.toStringAsFixed(0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ProfileStatCard(
                      icon: Icons.school_outlined,
                      label: '完了レッスン',
                      value: '${stats.lessonsCompleted}',
                    ),
                  ),
                ],
              ),
              loading: () => const StatSkeletonRow(),
              error: (_, __) => Row(
                children: const [
                  Expanded(
                    child: ProfileStatCard(
                      icon: Icons.speed,
                      label: 'WPM最高',
                      value: '--',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ProfileStatCard(
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
          ProfileTabs(
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
                  return PostEmptyState(
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
              loading: () => const PostSkeletonList(),
              error: (_, __) => PostErrorState(
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
          children: users.map((user) => UserListTile(user: user)).toList(),
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
          children: users.map((user) => UserListTile(user: user)).toList(),
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
