import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/diary/data/models/diary_post.dart';

class DiaryPostCard extends StatelessWidget {
  const DiaryPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onToggleLike,
    required this.onToggleBookmark,
    required this.onToggleRepost,
    required this.onComment,
    this.showActions = true,
    this.onQuote,
    this.onBlock,
    this.onReport,
  });

  final DiaryPost post;
  final VoidCallback onTap;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleRepost;
  final VoidCallback onComment;
  final bool showActions;
  final VoidCallback? onQuote;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = post.user.profileImageUrl;
    final hashtags = post.tags.map((tag) => '#$tag').toList();
    final subtitle = [
      '@${post.user.username}',
      _relativeTime(post.createdAt),
      if (post.isEdited) '編集済み',
    ].where((value) => value.isNotEmpty).join(' ・ ');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.repostInfo?.isRepost ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${post.repostInfo?.repostedBy?.displayName ?? 'ユーザー'}さんがリポストしました',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: avatar != null
                        ? CachedNetworkImageProvider(avatar)
                        : null,
                    child: avatar == null
                        ? Text(post.user.displayName.substring(0, 1))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user.displayName,
                          style: theme.textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            if (onBlock != null || onReport != null)
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'report') {
                                    onReport?.call();
                                  } else if (value == 'block') {
                                    onBlock?.call();
                                  }
                                },
                                itemBuilder: (context) => [
                                  if (onReport != null)
                                    const PopupMenuItem(
                                      value: 'report',
                                      child: Text('通報'),
                                    ),
                                  if (onBlock != null)
                                    const PopupMenuItem(
                                      value: 'block',
                                      child: Text('ブロック'),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(post.content, style: theme.textTheme.bodyLarge),
              if (post.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
                _ImageGrid(imageUrls: post.imageUrls),
              ],
              if (post.quotedPost != null) ...[
                const SizedBox(height: 12),
                _QuotedPostCard(quotedPost: post.quotedPost!),
              ],
              if (hashtags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hashtags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (showActions) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ActionButton(
                      icon: post.liked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: post.liked
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      count: post.likesCount,
                      onPressed: onToggleLike,
                    ),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      count: post.commentsCount,
                      onPressed: onComment,
                    ),
                    _ActionButton(
                      icon: Icons.autorenew,
                      color: post.reposted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      count: post.repostsCount,
                      onPressed: onToggleRepost,
                    ),
                    _ActionButton(
                      icon: Icons.format_quote,
                      onPressed: onQuote ?? onComment,
                      count: post.quotesCount,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        post.bookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: post.bookmarked
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: onToggleBookmark,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.count,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final int count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        '$count',
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: color),
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: imageUrls.first,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final crossAxisCount = imageUrls.length > 2 ? 2 : 1;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

class _QuotedPostCard extends StatelessWidget {
  const _QuotedPostCard({required this.quotedPost});

  final DiaryQuotedPost quotedPost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quotedPost.user.displayName,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            quotedPost.content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
