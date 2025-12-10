import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/diary/data/models/blocked_account.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import '../../widgets/user_avatar.dart';

class BlockedAccountsScreen extends ConsumerWidget {
  const BlockedAccountsScreen({super.key});

  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    BlockedAccount entry,
  ) async {
    try {
      final repo = ref.read(diaryRepositoryProvider);
      await repo.unblock(entry.id);
      await ref.refresh(blockedAccountsProvider.future);
      ToastHelper.show(
        context,
        '${entry.blockedUser?.displayName ?? entry.blockedId}をブロック解除しました',
      );
    } catch (e) {
      ToastHelper.showError(context, '解除に失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final blocksAsync = ref.watch(blockedAccountsProvider);

    return AppPageScaffold(
      title: 'ブロックしているアカウント',
      showBackButton: true,
      onRefresh: () => ref.refresh(blockedAccountsProvider.future),
      child: blocksAsync.when(
        data: (blocks) {
          if (blocks.isEmpty) {
            return const PageEmptyView(
              icon: Iconsax.slash,
              title: 'ブロック中のアカウントはありません',
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: blocks.length,
            separatorBuilder: (_, __) => Divider(
              indent: 16,
              endIndent: 16,
              color: theme.colorScheme.outlineVariant,
            ),
            itemBuilder: (context, index) {
              final entry = blocks[index];
              final user = entry.blockedUser;
              return ListTile(
                leading: UserAvatar(
                  displayName: user?.displayName ?? '不明なユーザー',
                  imageUrl: user?.profileImageUrl,
                ),
                title: Text(user?.displayName ?? '不明なユーザー'),
                subtitle:
                    Text(user != null ? '@${user.username}' : entry.blockedId),
                trailing: TextButton(
                  onPressed: () => _unblock(context, ref, entry),
                  child: const Text('解除'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => PageErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(blockedAccountsProvider),
        ),
      ),
    );
  }
}
