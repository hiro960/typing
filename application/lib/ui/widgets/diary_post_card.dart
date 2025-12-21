import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../features/diary/data/models/diary_post.dart';
import '../app_theme.dart';
import '../screens/profile/profile_screen.dart';
import 'user_avatar.dart';
import 'verified_badge.dart';

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
    this.onTranslate,
    this.translatedText,
    this.isTranslating = false,
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
  final VoidCallback? onTranslate;
  final String? translatedText;
  final bool isTranslating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surface, AppColors.surfaceAlt]
              : [AppColors.lightSurface, AppColors.lightSurfaceAlt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.lightBorder.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.16),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
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
                        UserAvatar(
                          displayName: post.user.displayName,
                          imageUrl: avatar,
                          useCachedImage: true,
                          onTap: () => _navigateToProfile(context),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _navigateToProfile(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserNameWithBadge(
                                  displayName: post.user.displayName,
                                  userType: post.user.type,
                                  style: theme.textTheme.titleMedium,
                                  badgeSize: VerifiedBadgeSize.medium,
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
                    if (translatedText != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.translate,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '日本語訳',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              translatedText!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (post.imageUrls.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _ImageCarousel(imageUrls: post.imageUrls),
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
                                    AppColors.primary.withValues(alpha: 0.12),
                                labelStyle: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                ? Iconsax.heart_tick
                                : Iconsax.heart,
                            color: post.liked
                                ? AppColors.primary
                                : theme.colorScheme.onSurfaceVariant,
                            count: post.likesCount,
                            onPressed: onToggleLike,
                          ),
                          _ActionButton(
                            icon: Iconsax.message,
                            count: post.commentsCount,
                            onPressed: onComment,
                          ),
                          _ActionButton(
                            icon: Iconsax.quote_up,
                            onPressed: onQuote ?? onComment,
                            count: post.quotesCount,
                          ),
                          const Spacer(),
                          if (onTranslate != null)
                            IconButton(
                              icon: isTranslating
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    )
                                  : Icon(
                                      Iconsax.translate,
                                      color: translatedText != null
                                          ? AppColors.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                              onPressed: isTranslating ? null : onTranslate,
                            ),
                          IconButton(
                            icon: Icon(
                              post.bookmarked
                                  ? Iconsax.bookmark_2
                                  : Iconsax.bookmark,
                              color: post.bookmarked
                                  ? AppColors.primary
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
                              Icon(Iconsax.edit, size: 20),
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
                              Icon(Iconsax.flag, size: 20),
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
                              Icon(Iconsax.slash, size: 20),
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
      ),
    );
  }

  Widget? _visibilityBadge(BuildContext context) {
    final theme = Theme.of(context);
    if (post.visibility == 'private') {
      return _VisibilityPill(
        icon: Iconsax.lock,
        label: '下書き',
        backgroundColor: theme.colorScheme.error.withValues(alpha: 0.08),
        foregroundColor: theme.colorScheme.error,
      );
    }
    if (post.visibility == 'followers') {
      return _VisibilityPill(
        icon: Iconsax.people,
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
            ?.copyWith(
              color: color ??
                  Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
            ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentIndex = 0;

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
                icon: const Icon(Iconsax.close_circle, color: Colors.white, size: 30),
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
    final theme = Theme.of(context);
    
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(context, widget.imageUrls[index]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ),
        ],
      ],
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
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [AppColors.surface, AppColors.surfaceAlt]
              : [AppColors.lightSurface, AppColors.lightSurfaceAlt],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.border.withValues(alpha: 0.4)
              : AppColors.lightBorder.withValues(alpha: 0.7),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                displayName: quotedPost.user.displayName,
                imageUrl: avatar,
                useCachedImage: true,
                onTap: () => _navigateToProfile(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserNameWithBadge(
                        displayName: quotedPost.user.displayName,
                        userType: quotedPost.user.type,
                        style: theme.textTheme.titleSmall,
                        badgeSize: VerifiedBadgeSize.small,
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
            _ImageCarousel(imageUrls: quotedPost.imageUrls),
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
                          AppColors.primary.withValues(alpha: 0.12),
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
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
