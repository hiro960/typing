import 'dart:io';

import 'package:chaletta/ui/widgets/premium_feature_gate.dart';
import 'package:chaletta/ui/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';
import '../../../features/diary/data/models/diary_post.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/profile/data/models/user_stats_model.dart';
import '../../../features/profile/domain/providers/profile_providers.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import '../../widgets/ai_gradient_button.dart';
import '../../widgets/sheet_content.dart';
import '../../app_spacing.dart';
import '../../widgets/diary_post_card.dart';
import '../diary/post_create_screen.dart';
import '../diary/post_detail_screen.dart';
import 'profile_header.dart';
import 'profile_posts.dart';
import 'profile_relations.dart';
import 'profile_stats.dart';
import 'profile_tabs.dart';
import '../analysis/analysis_screen.dart';

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

  /// ネットワークエラーのトースト表示済みフラグ（重複表示防止）
  bool _hasShownNetworkError = false;

  void _openDetail(DiaryPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailScreen(initialPost: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 表示対象のユーザーIDを決定
    final currentUser = ref.watch(currentUserProvider);
    final targetUserId = widget.userId ?? currentUser?.id;

    if (targetUserId == null) {
      return const Center(child: Text('ユーザー情報の取得に失敗しました'));
    }

    // 自分のプロフィールかどうか
    final isOwnProfile = widget.userId == null || widget.userId == currentUser?.id;

    // プロバイダーを監視
    final profileAsync = ref.watch(userProfileProvider(targetUserId));
    final statsAsync = ref.watch(userStatsProvider(targetUserId));

    // タブに応じてデータを取得
    // 投稿タブの場合のみ投稿を取得
    final postsAsync = _selectedTabIndex == 0
        ? ref.watch(userPostsProvider(targetUserId))
        : const AsyncValue.data(<DiaryPost>[]);

    // 自分のプロフィールの場合、ローカルデータを先に表示
    if (isOwnProfile && currentUser != null) {
      return profileAsync.when(
        data: (profile) {
          // データ取得成功時はエラーフラグをリセット
          _hasShownNetworkError = false;
          return _buildContent(
            context,
            theme,
            profile,
            statsAsync,
            postsAsync,
            ref,
            currentUser.id,
          );
        },
        loading: () => _buildContent(
          context,
          theme,
          currentUser,
          statsAsync,
          postsAsync,
          ref,
          currentUser.id,
        ),
        error: (error, _) {
          // ネットワークエラー時にトーストを表示（重複表示防止）
          if (!_hasShownNetworkError) {
            _hasShownNetworkError = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ToastHelper.show(context, 'ネットワークに接続できませんでした');
              }
            });
          }
          // ローカルデータで画面を表示（プルダウンで再試行可能）
          return _buildContent(
            context,
            theme,
            currentUser,
            statsAsync,
            postsAsync,
            ref,
            currentUser.id,
          );
        },
      );
    }

    // 他人のプロフィールの場合は従来通り
    return profileAsync.when(
      data: (profile) {
        _hasShownNetworkError = false;
        return _buildContent(
          context,
          theme,
          profile,
          statsAsync,
          postsAsync,
          ref,
          currentUser?.id,
        );
      },
      loading: () => _ProfileSkeletonScreen(onOpenSettings: widget.onOpenSettings),
      error: (error, _) => AppPageScaffold(
        title: 'プロフィール',
        titleIcon: Icons.person_outline,
        showBackButton: true,
        child: PageErrorView(
          message: error is AppException ? error.message : error.toString(),
          onRetry: () => ref.invalidate(userProfileProvider(targetUserId)),
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
    final isPremiumUser = profile.isPremiumUser;
    return AppPageScaffold(
      title: 'プロフィール',
      titleIcon: Icons.person_outline,
      showBackButton: true,
      actions: [
        if (isOwner)
          FHeaderAction(
            icon: const Icon(Icons.settings_outlined),
            onPress: widget.onOpenSettings,
          ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userProfileProvider(profile.id));
          ref.invalidate(userStatsProvider(profile.id));
          if (_selectedTabIndex == 0) {
            ref.invalidate(userPostsProvider(profile.id));
          } else if (_selectedTabIndex == 1) {
            ref.invalidate(userFollowersProvider(profile.id));
          } else {
            ref.invalidate(userFollowingProvider(profile.id));
          }
        },
        child: ListView(
          padding: AppPadding.profilePage,
          children: [
            const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
          SummaryChips(profile: profile),
          const SizedBox(height: AppSpacing.lg),
          if (_canViewStats(profile, currentUserId)) ...[
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(
                      label: 'WPM最高',
                      value: stats.wpmAvg.toStringAsFixed(0),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ProfileStatCard(
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
                      label: 'WPM最高',
                      value: '--',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ProfileStatCard(
                      label: '完了レッスン',
                      value: '--',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (isOwner) ...[
            AiGradientButton(
              label: '詳細分析を見る',
              onTap: () {
                if (!isPremiumUser) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PremiumFeatureGateScreen(
                        focusFeature: '詳細分析',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AnalysisScreen(),
                  ),
                );
              },
              icon: Icons.analytics_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          ProfileTabs(
            selectedIndex: _selectedTabIndex,
            postsCount: profile.postsCount,
            followersCount: profile.followersCount,
            followingCount: profile.followingCount,
            onChanged: (index) => setState(() => _selectedTabIndex = index),
          ),
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
                      return DiaryPostCard(
                        post: post,
                        onTap: () => _openDetail(post),
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
                        onComment: () => _openDetail(post),
                        onQuote: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  PostCreateScreen(quotedPost: post),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        currentUserId: currentUserId,
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
    final choice = await showFSheet<String>(
      context: context,
      side: FLayout.btt,
      useRootNavigator: true,
      barrierDismissible: true,
      draggable: true,
      builder: (context) => SheetContent(
        children: [
          SheetOption(
            label: '写真を選択',
            icon: Icons.photo_library_outlined,
            onPress: () => Navigator.of(context).pop('pick'),
          ),
          if (profile.profileImageUrl != null)
            SheetOption(
              label: '画像を削除',
              icon: Icons.delete_outline,
              onPress: () => Navigator.of(context).pop('remove'),
            ),
        ],
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
      SnackBarHelper.showError(context, error);
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
      SnackBarHelper.show(context, remove ? 'プロフィール画像を削除しました' : 'プロフィール画像を更新しました');
    } catch (error) {
      SnackBarHelper.showError(context, error);
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

class _ProfileSkeletonScreen extends StatelessWidget {
  const _ProfileSkeletonScreen({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'プロフィール',
      titleIcon: Icons.person_outline,
      showBackButton: true,
      actions: [
        FHeaderAction(
          icon: const Icon(Icons.settings_outlined),
          onPress: onOpenSettings,
        ),
      ],
      child: ShimmerLoading(
        child: ListView(
          padding: AppPadding.profilePage,
          children: [
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerCircle(size: 80),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(width: 120, height: 24),
                      SizedBox(height: 8),
                      ShimmerBlock(width: 80, height: 16),
                      SizedBox(height: 8),
                      ShimmerBlock(width: 160, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl + AppSpacing.lg),
            Row(
              children: const [
                Expanded(child: ShimmerBlock(height: 32)),
                SizedBox(width: 8),
                Expanded(child: ShimmerBlock(height: 32)),
                SizedBox(width: 8),
                Expanded(child: ShimmerBlock(height: 32)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const StatSkeletonRow(),
            const SizedBox(height: AppSpacing.lg),
            const ShimmerBlock(height: 44),
            const SizedBox(height: AppSpacing.md),
            const PostSkeletonList(),
          ],
        ),
      ),
    );
  }
}
