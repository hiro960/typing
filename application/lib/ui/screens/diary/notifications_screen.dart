import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/diary/data/models/diary_notification.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/user_avatar.dart';
import 'post_detail_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diaryNotificationsControllerProvider.notifier).loadInitial();
    });
  }

  Future<void> _refresh() async {
    await ref.read(diaryNotificationsControllerProvider.notifier).refresh();
  }

  void _openPost(DiaryNotification notification) {
    final post = notification.post;
    if (post == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PostDetailScreen(initialPost: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryNotificationsControllerProvider);

    final theme = Theme.of(context);
    final unreadCount =
        state.notifications.where((notification) => !notification.isRead).length;
    return AppPageScaffold(
      header: FHeader(
        title: Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 22,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text('通知', style: theme.textTheme.headlineSmall),
          ],
        ),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.mark_email_read_outlined),
            onPress: state.notifications.isEmpty
                ? null
                : () {
                    ref
                        .read(
                          diaryNotificationsControllerProvider.notifier,
                        )
                        .markAllRead();
                  },
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _FilterTabs(
              unreadOnly: state.unreadOnly,
              unreadCount: unreadCount,
              onChanged: (value) {
                if (value == state.unreadOnly) return;
                ref
                    .read(diaryNotificationsControllerProvider.notifier)
                    .toggleUnreadOnly(value);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.notifications.isEmpty) {
                    return const _NotificationSkeletonList();
                  }
                  if (state.errorMessage != null &&
                      state.notifications.isEmpty) {
                    return _ErrorView(
                      message: state.errorMessage!,
                      onRetry: _refresh,
                    );
                  }
                  if (state.notifications.isEmpty) {
                    return _EmptyState(onReload: _refresh);
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (state.hasMore &&
                          !state.isLoadingMore &&
                          notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 100) {
                        ref
                            .read(
                              diaryNotificationsControllerProvider.notifier,
                            )
                            .loadMore();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      itemCount:
                          state.notifications.length +
                          (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text('読み込み中...'),
                              ],
                            ),
                          );
                        }
                        final notification = state.notifications[index];
                        return _NotificationTile(
                          notification: notification,
                          onTap: () {
                            _openPost(notification);
                            if (!notification.isRead) {
                              ref
                                  .read(
                                    diaryNotificationsControllerProvider
                                        .notifier,
                                  )
                                  .markAsRead(notification.id);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final DiaryNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _title(notification);
    final subtitle =
        notification.post?.content ?? notification.comment?.content ?? '';
    final backgroundColor = notification.isRead
        ? Colors.transparent
        : theme.colorScheme.primary.withValues(alpha: 0.08);
    final relativeTime = _formatRelativeTime(notification.createdAt);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FTile(
        onPress: onTap,
        prefix: UserAvatar(
          displayName: notification.actor.displayName,
          imageUrl: notification.actor.profileImageUrl,
          backgroundColor: _avatarColor(notification.type, theme),
          foregroundColor: theme.colorScheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: notification.isRead
              ? theme.textTheme.bodyMedium
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        suffix: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (relativeTime.isNotEmpty)
              Text(
                relativeTime,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            if (!notification.isRead) ...[
              const SizedBox(height: 6),
              const Icon(Icons.fiber_manual_record, size: 12),
            ],
          ],
        ),
      ),
    );
  }

  String _title(DiaryNotification notification) {
    switch (notification.type) {
      case 'COMMENT':
        return '${notification.actor.displayName}さんがコメントしました';

      case 'QUOTE':
        return '${notification.actor.displayName}さんがあなたの投稿を引用しました';

      case 'FOLLOW':
        return '${notification.actor.displayName}さんがあなたをフォローしました';
      case 'LIKE':
      default:
        return '${notification.actor.displayName}さんがいいねしました';
    }
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.unreadOnly,
    required this.unreadCount,
    required this.onChanged,
  });

  final bool unreadOnly;
  final int unreadCount;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = unreadOnly ? 1 : 0;

    return FTabs(
      key: ValueKey(selectedIndex),
      initialIndex: selectedIndex,
      onChange: (index) => onChanged(index == 1),
      children: [
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 16,
                  color: !unreadOnly
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'すべて',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: !unreadOnly
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_chat_unread_outlined,
                  size: 16,
                  color: unreadOnly
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  '未読のみ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: unreadOnly
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 6),
                  _CountBadge(
                    count: unreadCount,
                    color: unreadOnly
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ],
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReload});

  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '通知はありません',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '新しいコメントやリアクションが届くとここに表示されます。',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FButton(
            onPress: onReload,
            child: const Text('再読み込み'),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Center(
          child: Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '読み込みに失敗しました',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FButton(
            onPress: onRetry,
            child: const Text('再試行'),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _NotificationSkeletonList extends StatelessWidget {
  const _NotificationSkeletonList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor =
        theme.colorScheme.onSurface.withValues(alpha: 0.06);
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBlock(
                    widthFactor: 0.85,
                    height: 14,
                    color: baseColor,
                  ),
                  const SizedBox(height: 8),
                  _SkeletonBlock(
                    widthFactor: 0.65,
                    height: 12,
                    color: baseColor,
                  ),
                  const SizedBox(height: 6),
                  _SkeletonBlock(
                    widthFactor: 0.4,
                    height: 12,
                    color: baseColor,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.widthFactor,
    required this.height,
    required this.color,
  });

  final double widthFactor;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

Color _avatarColor(String type, ThemeData theme) {
  switch (type) {
    case 'COMMENT':
      return theme.colorScheme.primary;
    case 'QUOTE':
      return theme.colorScheme.secondary;
    case 'FOLLOW':
      return theme.colorScheme.tertiary;
    case 'LIKE':
    default:
      return theme.colorScheme.secondaryContainer;
  }
}

String _formatRelativeTime(DateTime? createdAt) {
  if (createdAt == null) return '';
  final now = DateTime.now();
  final diff = now.difference(createdAt);
  if (diff.isNegative || diff.inSeconds < 5) return 'たった今';
  if (diff.inMinutes < 1) return '${diff.inSeconds}秒前';
  if (diff.inHours < 1) return '${diff.inMinutes}分前';
  if (diff.inHours < 24) return '${diff.inHours}時間前';
  if (diff.inDays < 30) return '${diff.inDays}日前';
  final months = (diff.inDays / 30).floor();
  if (months < 12) return '${months}か月前';
  final years = (diff.inDays / 365).floor();
  return '${years}年前';
}
