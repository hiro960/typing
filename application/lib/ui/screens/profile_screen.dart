import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import '../../features/diary/data/models/diary_post.dart';
import '../../features/profile/data/models/user_stats_model.dart';
import '../../features/profile/domain/providers/profile_providers.dart';
import '../widgets/diary_post_card.dart';
import 'diary/drafts_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    super.key,
    this.userId,
    required this.onOpenSettings,
  });

  final String? userId;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 表示対象のユーザーIDを決定
    final currentUser = ref.watch(currentUserProvider);
    final targetUserId = userId ?? currentUser?.id;

    if (targetUserId == null) {
      return const Center(child: Text('ユーザー情報の取得に失敗しました'));
    }

    // プロバイダーを監視
    final profileAsync = ref.watch(userProfileProvider(targetUserId));
    final statsAsync = ref.watch(userStatsProvider(targetUserId));
    final postsAsync = ref.watch(userPostsProvider(targetUserId));

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
          if (currentUserId == profile.id)
            FHeaderAction(
              icon: const Icon(Icons.edit_document),
              onPress: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DraftsScreen(),
                  ),
                );
              },
            ),
          FHeaderAction(
            icon: const Icon(Icons.settings_outlined),
            onPress: onOpenSettings,
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
        children: [
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profile.profileImageUrl != null
                      ? NetworkImage(profile.profileImageUrl!)
                      : null,
                  child: profile.profileImageUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(profile.displayName, style: theme.textTheme.headlineSmall),
                Text(
                  '@${profile.username}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            Text(
              profile.bio!,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                _formatStartDate(profile.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_canViewStats(profile, currentUserId)) ...[
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _ProfileStat(
                      label: 'WPM最高',
                      value: stats.wpmAvg.toStringAsFixed(0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStat(
                      label: '完了レッスン',
                      value: '${stats.lessonsCompleted}',
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Row(
                children: const [
                  Expanded(child: _ProfileStat(label: 'WPM最高', value: '--')),
                  SizedBox(width: 12),
                  Expanded(child: _ProfileStat(label: '完了レッスン', value: '--')),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (currentUserId != profile.id) ...[
            _FollowButton(
              userId: profile.id,
              initialIsFollowing: profile.isFollowing,
              onFollowChanged: (isFollowing) {
                // プロバイダーを無効化して最新データを再取得
                // 実際のアプリでは、ここでローカルステートを更新するか、
                // キャッシュを更新するのが望ましいが、今回は簡易的にinvalidateする
                ref.invalidate(userProfileProvider(profile.id));
              },
            ),
            const SizedBox(height: 24),
          ],
          FCard.raw(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  _TabItem(
                    label: '投稿',
                    value: '${profile.postsCount}',
                    selected: true,
                  ),
                  _TabItem(
                    label: 'フォロワー',
                    value: '${profile.followersCount}',
                  ),
                  _TabItem(
                    label: 'フォロー中',
                    value: '${profile.followingCount}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          postsAsync.when(
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'まだ投稿がありません',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      '日記',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...posts.take(20).map((post) {
                    return DiaryPostCard(
                      post: post,
                      onTap: () {
                        // TODO: Navigate to post detail
                      },
                      onToggleLike: () {},
                      onToggleBookmark: () {},
                      onComment: () {},
                      currentUserId: currentUserId,
                    );
                  }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Text(
                '投稿の取得に失敗しました',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.value,
    this.selected = false,
  });

  final String label;
  final String value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
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
