import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key, required this.onCompose});

  final VoidCallback onCompose;

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: FHeader(
                title: Text('📝 日記', style: theme.textTheme.headlineSmall),
                suffixes: [
                  FHeaderAction(icon: const Icon(Icons.search), onPress: () {}),
                  FHeaderAction(
                    icon: const Icon(Icons.add_circle_outline),
                    onPress: widget.onCompose,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FTabs(
                initialIndex: _selectedFilter,
                onChange: (index) => setState(() => _selectedFilter = index),
                style: (tabsStyle) {
                  final surface = theme.colorScheme.surface;
                  final borderColor = theme.colorScheme.onSurface.withValues(
                    alpha: 0.15,
                  );
                  return tabsStyle.copyWith(
                    decoration: tabsStyle.decoration.copyWith(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(18),
                      color: surface.withValues(alpha: 0.4),
                    ),
                    indicatorDecoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
                children: [
                  for (final filter in timelineFilters)
                    FTabEntry(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(filter),
                      ),
                      child: const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _DiaryTimeline(filterIndex: _selectedFilter),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiaryPostCard extends StatelessWidget {
  const _DiaryPostCard({required this.post});

  final DiaryPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.15,
                  ),
                  child: Text(post.username.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.username} ・ ${post.handle}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '${post.level} ・ ${post.timeAgo}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FButton.icon(
                  onPress: () {},
                  child: const Icon(Icons.more_horiz),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(post.content, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              post.translationHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.hashtags
                  .map(
                    (tag) => Material(
                      color: Colors.transparent,
                      child: Chip(label: Text(tag)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: '${post.likes}',
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                ),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.autorenew, label: '${post.reposts}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: () {},
      style: FButtonStyle.ghost(),
      prefix: Icon(icon, size: 16),
      child: Text(label),
    );
  }
}

class _DiaryTimeline extends StatelessWidget {
  const _DiaryTimeline({required this.filterIndex});

  final int filterIndex;

  @override
  Widget build(BuildContext context) {
    final List<DiaryPost> posts;
    switch (filterIndex) {
      case 0:
        posts = diaryPosts;
        break;
      case 1:
        posts = diaryPosts;
        break;
      default:
        posts = diaryPosts;
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 120),
      physics: const BouncingScrollPhysics(),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _DiaryPostCard(post: posts[index]),
    );
  }
}
