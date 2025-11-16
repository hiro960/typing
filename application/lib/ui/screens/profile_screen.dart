import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/providers/auth_providers.dart';
import '../../features/profile/data/models/user_stats_model.dart';
import '../../features/profile/domain/providers/profile_providers.dart';

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
    AsyncValue<List<Map<String, dynamic>>> postsAsync,
    String? currentUserId,
  ) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          children: [
            FHeader(
              title: Text('👤 プロフィール', style: theme.textTheme.headlineSmall),
              suffixes: [
                FHeaderAction(
                  icon: const Icon(Icons.settings_outlined),
                  onPress: onOpenSettings,
                ),
              ],
            ),
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
            if (currentUserId != profile.id) ...[
              FButton(
                onPress: () {},
                style: FButtonStyle.outline(),
                child: const Text('フォローする'),
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
                  children: posts.take(20).map((post) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _MiniPostCard(post: post),
                    );
                  }).toList(),
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

class _MiniPostCard extends StatelessWidget {
  const _MiniPostCard({required this.post});

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = post['content'] as String? ?? '';
    final likesCount = post['likesCount'] as int? ?? 0;
    final createdAt = post['createdAt'] as String? ?? '';

    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimeAgo(createdAt),
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Icon(Icons.favorite, size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 4),
                Text('$likesCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 0) {
        return '${diff.inDays}日前';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}時間前';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}分前';
      } else {
        return 'たった今';
      }
    } catch (e) {
      return '';
    }
  }
}
