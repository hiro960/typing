import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/diary/data/models/diary_post.dart';
import '../screens/profile_screen.dart';

class DiaryPostCard extends StatelessWidget {
  const DiaryPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onToggleLike,
    required this.onToggleBookmark,
    required this.onComment,
    this.showActions = true,
    this.onQuote,
    this.onBlock,
    this.onReport,
    this.onEdit,
    this.currentUserId,
  });

  final DiaryPost post;
  final VoidCallback onTap;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleBookmark;
  final VoidCallback onComment;
  final bool showActions;
  final VoidCallback? onQuote;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;
  final VoidCallback? onEdit;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = post.user.profileImageUrl;
    final hashtags = post.tags.map((tag) => '#$tag').toList();
    final subtitle = [
      '@${post.user.username}',
      _relativeTimeText(post.createdAt),
      if (post.isEdited) '編集済み',
    ].where((value) => value.isNotEmpty).join(' ・ ');
    final visibilityBadge = _visibilityBadge(context);

    final isOwnPost = currentUserId != null && post.user.id == currentUserId;
    final canEdit = isOwnPost &&
        post.createdAt != null &&
        DateTime.now().difference(post.createdAt!).inHours < 24;
    final hasMenu = (!isOwnPost && ((onReport != null) || (onBlock != null))) ||
        (canEdit && onEdit != null);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToProfile(context),
                        child: CircleAvatar(
                          backgroundImage: avatar != null
                              ? CachedNetworkImageProvider(avatar)
                              : null,
                          child: avatar == null
                              ? Text(post.user.displayName.substring(0, 1))
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _navigateToProfile(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.user.displayName,
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (visibilityBadge != null) ...[
                        const SizedBox(width: 8),
                        visibilityBadge,
                      ],
                      const SizedBox(width: 40),
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
                    DiaryQuotedPostCard(quotedPost: post.quotedPost!),
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
            if (hasMenu)
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'report') {
                      onReport?.call();
                    } else if (value == 'block') {
                      onBlock?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    if (canEdit && onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 12),
                            Text('編集'),
                          ],
                        ),
                      ),
                    if (!isOwnPost && onReport != null)
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.flag, size: 20),
                            SizedBox(width: 12),
                            Text('通報'),
                          ],
                        ),
                      ),
                    if (!isOwnPost && onBlock != null)
                      const PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            Icon(Icons.block, size: 20),
                            SizedBox(width: 12),
                            Text('ブロック'),
                          ],
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

  Widget? _visibilityBadge(BuildContext context) {
    final theme = Theme.of(context);
    if (post.visibility == 'private') {
      return _VisibilityPill(
        icon: Icons.lock_outline,
        label: '下書き',
        backgroundColor: theme.colorScheme.error.withValues(alpha: 0.08),
        foregroundColor: theme.colorScheme.error,
      );
    }
    if (post.visibility == 'followers') {
      return _VisibilityPill(
        icon: Icons.group_outlined,
        label: 'フォロワーのみ',
        backgroundColor:
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
        foregroundColor: theme.colorScheme.onSecondaryContainer,
      );
    }
    return null;
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: post.user.id,
          onOpenSettings: () {},
        ),
      ),
    );
  }
}

class _VisibilityPill extends StatelessWidget {
  const _VisibilityPill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
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

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrls.length == 1) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, imageUrls.first),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: imageUrls.first,
              fit: BoxFit.cover,
            ),
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
        return GestureDetector(
          onTap: () => _showFullScreenImage(context, imageUrls[index]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class DiaryQuotedPostCard extends StatelessWidget {
  const DiaryQuotedPostCard({super.key, required this.quotedPost});

  final DiaryQuotedPost quotedPost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = quotedPost.user.profileImageUrl;
    final subtitle = [
      '@${quotedPost.user.username}',
      _relativeTimeText(quotedPost.createdAt),
    ].where((value) => value.isNotEmpty).join(' ・ ');
    final hashtags = quotedPost.tags.map((tag) => '#$tag').toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.4),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _navigateToProfile(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      avatar != null ? CachedNetworkImageProvider(avatar) : null,
                  child: avatar == null
                      ? Text(quotedPost.user.displayName.substring(0, 1))
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quotedPost.user.displayName,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quotedPost.content,
            style: theme.textTheme.bodyMedium,
          ),
          if (quotedPost.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ImageGrid(imageUrls: quotedPost.imageUrls),
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
        ],
      ),
    );
  }
  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: quotedPost.user.id,
          onOpenSettings: () {},
        ),
      ),
    );
  }
}

String _relativeTimeText(DateTime? time) {
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
