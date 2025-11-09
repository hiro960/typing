import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../mock/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  icon: const Icon(Icons.more_horiz),
                  onPress: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=300&q=80',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Hana Suzuki', style: theme.textTheme.headlineSmall),
                  Text(
                    '@hana_typing',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Material(
                    color: Colors.transparent,
                    child: Chip(label: Text('중급자 🏅')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '「今日も 한 문장」チャレンジ中。推しのコメントを書くために韓国語を頑張っています！',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text('2024年1月から学習中', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: _ProfileStat(label: 'WPM最高', value: '78'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ProfileStat(label: '完了レッスン', value: '42'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FButton(
              onPress: () {},
              style: FButtonStyle.outline(),
              child: const Text('フォローする'),
            ),
            const SizedBox(height: 24),
            FCard.raw(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    _TabItem(label: '投稿', value: '42', selected: true),
                    _TabItem(label: 'フォロワー', value: '128'),
                    _TabItem(label: 'フォロー中', value: '56'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...diaryPosts.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _MiniPostCard(post: post),
              ),
            ),
          ],
        ),
      ),
    );
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

  final DiaryPost post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(post.timeAgo, style: theme.textTheme.bodySmall),
                const Spacer(),
                Icon(Icons.favorite, size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 4),
                Text('${post.likes}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
