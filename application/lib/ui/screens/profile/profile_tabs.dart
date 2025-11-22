import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({
    super.key,
    required this.selectedIndex,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FTabs(
      key: ValueKey(selectedIndex),
      initialIndex: selectedIndex,
      onChange: (index) => onChanged(index),
      children: [
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '投稿',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'フォロワー',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
        FTabEntry(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'フォロー中',
              style: theme.textTheme.bodySmall,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
