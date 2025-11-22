import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/diary/data/models/blocked_account.dart';
import '../../../features/diary/domain/providers/diary_providers.dart';
import '../../../features/auth/domain/providers/auth_providers.dart';

class BlockedAccountsScreen extends ConsumerStatefulWidget {
  const BlockedAccountsScreen({super.key});

  @override
  ConsumerState<BlockedAccountsScreen> createState() =>
      _BlockedAccountsScreenState();
}

class _BlockedAccountsScreenState
    extends ConsumerState<BlockedAccountsScreen> {
  bool _isLoading = true;
  String? _error;
  List<BlockedAccount> _blocks = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final repo = ref.read(diaryRepositoryProvider);
      final items = await repo.fetchBlockedAccounts();
      setState(() => _blocks = items);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _unblock(BlockedAccount entry) async {
    try {
      final repo = ref.read(diaryRepositoryProvider);
      await repo.unblock(entry.id);
      setState(() {
        _blocks = _blocks.where((b) => b.id != entry.id).toList();
      });
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${entry.blockedUser?.displayName ?? entry.blockedId}をブロック解除しました')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('解除に失敗しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ブロックしているアカウント'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(theme),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Center(child: Text('読み込みに失敗しました: $_error')),
        ],
      );
    }
    if (_blocks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 80),
          Center(child: Text('ブロック中のアカウントはありません')),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _blocks.length,
      separatorBuilder: (_, __) => Divider(
        indent: 16,
        endIndent: 16,
        color: theme.colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) {
        final entry = _blocks[index];
        final user = entry.blockedUser;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
            child: user?.profileImageUrl == null
                ? Text(user?.displayName.substring(0, 1) ?? '?')
                : null,
          ),
          title: Text(user?.displayName ?? '不明なユーザー'),
          subtitle: Text(user != null ? '@${user.username}' : entry.blockedId),
          trailing: TextButton(
            onPressed: () => _unblock(entry),
            child: const Text('解除'),
          ),
        );
      },
    );
  }
}
