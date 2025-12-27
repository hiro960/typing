import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../../../ui/app_theme.dart';
import '../../data/models/original_content.dart';
import '../../domain/providers/original_content_providers.dart';
import 'original_content_form_screen.dart';
import 'original_content_practice_screen.dart';

/// オリジナル文章一覧画面
class OriginalContentListScreen extends ConsumerWidget {
  const OriginalContentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentsAsync = ref.watch(originalContentsProvider);
    final theme = Theme.of(context);
    final accentColor = FeatureGradients.shadowing.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('オリジナル文章'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        icon: const Icon(Iconsax.add),
        label: const Text('新規作成'),
      ),
      body: contentsAsync.when(
        data: (contents) => contents.isEmpty
            ? _buildEmptyState(context, theme, accentColor)
            : _buildList(context, contents),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('エラーが発生しました: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    Color accentColor,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.document_text,
                size: 36,
                color: accentColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'オリジナル文章がありません',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '自分だけの韓国語文章を追加して\n練習しましょう',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => _navigateToForm(context),
              icon: const Icon(Iconsax.add),
              label: const Text('文章を追加'),
              style: FilledButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<OriginalContent> contents) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final content = contents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: _ContentCard(content: content),
        );
      },
    );
  }

  void _navigateToForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const OriginalContentFormScreen(),
      ),
    );
  }
}

/// コンテンツカード
class _ContentCard extends ConsumerWidget {
  const _ContentCard({required this.content});

  final OriginalContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMastered = content.isMastered;
    final isPracticed = content.isPracticed;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isMastered
              ? Colors.green.withValues(alpha: 0.5)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isMastered ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPractice(context),
        onLongPress: () => _showOptions(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isMastered
                ? LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: isDark ? 0.15 : 0.05),
                      Colors.green.withValues(alpha: isDark ? 0.05 : 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ステータスアイコン
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getStatusColor(isPracticed, isMastered)
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(isPracticed, isMastered),
                    size: 16,
                    color: _getStatusColor(isPracticed, isMastered),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // コンテンツ情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        if (content.audioPath.isNotEmpty) ...[
                          Icon(
                            Iconsax.volume_high,
                            size: 14,
                            color: Colors.green.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(content.durationSeconds),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ] else ...[
                          Icon(
                            Iconsax.volume_slash,
                            size: 14,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '音声なし',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                        ],
                        if (content.practiceCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(isPracticed, isMastered)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${content.practiceCount}回',
                              style: TextStyle(
                                fontSize: 11,
                                color: _getStatusColor(isPracticed, isMastered),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // メニューボタン
              PopupMenuButton<String>(
                icon: Icon(
                  Iconsax.more,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 20,
                ),
                onSelected: (value) => _handleMenuAction(context, ref, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Iconsax.edit, size: 18),
                        SizedBox(width: 8),
                        Text('編集'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Iconsax.trash, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('削除', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPractice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OriginalContentPracticeScreen(contentId: content.id),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.edit),
              title: const Text('編集'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEdit(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.trash, color: Colors.red),
              title: const Text('削除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _navigateToEdit(context);
        break;
      case 'delete':
        _confirmDelete(context, ref);
        break;
    }
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OriginalContentFormScreen(content: content),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: Text('「${content.title}」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(originalContentSaverProvider.notifier).delete(content.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('削除しました')),
        );
      }
    }
  }

  Color _getStatusColor(bool isPracticed, bool isMastered) {
    if (isMastered) return Colors.green;
    if (isPracticed) return Colors.blue;
    return Colors.grey;
  }

  IconData _getStatusIcon(bool isPracticed, bool isMastered) {
    if (isMastered) return Iconsax.medal_star;
    if (isPracticed) return Iconsax.tick_circle;
    return Iconsax.play_circle;
  }

  String _formatDuration(int seconds) {
    if (seconds == 0) return '0:00';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
