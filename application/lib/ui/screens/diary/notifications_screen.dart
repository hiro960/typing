import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/diary/data/models/diary_notification.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
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
    final isLight = theme.brightness == Brightness.light;
    return Material(
      color: isLight ? Colors.white : theme.colorScheme.surface,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: FHeader(
                title: Text('🔔 通知', style: theme.textTheme.headlineSmall),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'すべて',
                    selected: !state.unreadOnly,
                    onSelected: (value) {
                      if (!value) return;
                      ref
                          .read(diaryNotificationsControllerProvider.notifier)
                          .toggleUnreadOnly(false);
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '未読のみ',
                    selected: state.unreadOnly,
                    onSelected: (value) {
                      if (!value) return;
                      ref
                          .read(diaryNotificationsControllerProvider.notifier)
                          .toggleUnreadOnly(true);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.notifications.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.errorMessage != null &&
                        state.notifications.isEmpty) {
                      return Center(child: Text(state.errorMessage!));
                    }
                    if (state.notifications.isEmpty) {
                      return const Center(child: Text('通知はありません'));
                    }
                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 100) {
                          ref
                              .read(
                                diaryNotificationsControllerProvider.notifier,
                              )
                              .loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount:
                            state.notifications.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.notifications.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
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
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: notification.actor.profileImageUrl != null
              ? NetworkImage(notification.actor.profileImageUrl!)
              : null,
          child: notification.actor.profileImageUrl == null
              ? Text(notification.actor.displayName.substring(0, 1))
              : null,
        ),
        title: Text(
          title,
          style: notification.isRead
              ? theme.textTheme.bodyMedium
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: notification.isRead
            ? null
            : const Icon(Icons.fiber_manual_record, size: 12),
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
