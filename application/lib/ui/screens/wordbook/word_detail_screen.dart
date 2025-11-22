import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../app_spacing.dart';
import 'word_form_screen.dart';

class WordDetailScreen extends ConsumerStatefulWidget {
  const WordDetailScreen({super.key, required this.wordId});

  final String wordId;

  @override
  ConsumerState<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  bool _updatingStatus = false;

  @override
  Widget build(BuildContext context) {
    final asyncWords = ref.watch(wordbookProvider);
    final words = asyncWords.value;
    Word? selected;
    if (words != null) {
      for (final entry in words) {
        if (entry.id == widget.wordId) {
          selected = entry;
          break;
        }
      }
    }

    if (selected == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('単語詳細')),
        body: const Center(child: Text('単語が見つかりませんでした。')),
      );
    }

    final word = selected;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(word.word),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _openForm(context, word),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, word),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.xl - 4),
        children: [
          _StatusHeader(
            status: word.status,
            category: word.category,
            onSpeak: () => ref
                .read(wordAudioServiceProvider.notifier)
                .speak(word.word),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('ステータス', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<WordStatus>(
            segments: [
              for (final status in WordStatus.values)
                ButtonSegment(
                  value: status,
                  label: Text(status.label),
                ),
            ],
            selected: {word.status},
            showSelectedIcon: false,
            onSelectionChanged: _updatingStatus
                ? null
                : (selection) {
                    if (selection.isNotEmpty &&
                        selection.first != word.status) {
                      _updateStatus(selection.first, word);
                    }
                  },
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(word.word, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            word.meaning,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '例文',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(word.example ?? '例文が登録されていません。'),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'タグ',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (word.tags.isEmpty)
            const Text('タグなし')
          else
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final tag in word.tags)
                  Chip(
                    label: Text(tag),
                  ),
              ],
            ),
          const SizedBox(height: 24),
          _MetadataRow(
            label: '復習回数',
            value: '${word.reviewCount}',
          ),
          _MetadataRow(
            label: '正解率',
            value: '${(word.successRate * 100).toStringAsFixed(0)}%',
          ),
          _MetadataRow(
            label: '最終更新',
            value: _formatDate(word.updatedAt),
          ),
          _MetadataRow(
            label: '作成日',
            value: _formatDate(word.createdAt),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(BuildContext context, Word word) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordFormScreen(word: word),
      ),
    );
  }

  Future<void> _updateStatus(WordStatus status, Word word) async {
    setState(() => _updatingStatus = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(wordbookProvider.notifier).updateWord(
            word.id,
            status: status,
          );
      messenger.showSnackBar(
        SnackBar(content: Text('ステータスを「${status.label}」に変更しました')),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('更新に失敗しました: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _updatingStatus = false);
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, Word word) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除しますか？'),
        content: Text('「${word.word}」を単語帳から削除します。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(wordbookProvider.notifier).deleteWord(word.id);
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(content: Text('「${word.word}」を削除しました。')),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '-';
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}/$month/$day $hour:$minute';
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.status,
    required this.category,
    required this.onSpeak,
  });

  final WordStatus status;
  final WordCategory category;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = Theme.of(context).colorScheme;
    final base = _statusColor(status, colors);
    final background = base.withValues(alpha: 0.12);
    final borderColor = base.withValues(alpha: 0.4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _statusColor(status, colors),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.label,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.volume_up_outlined),
            tooltip: '音声再生',
            onPressed: onSpeak,
          ),
        ],
      ),
    );
  }

  Color _statusColor(WordStatus status, ColorScheme scheme) {
    switch (status) {
      case WordStatus.MASTERED:
        return scheme.tertiary;
      case WordStatus.REVIEWING:
        return scheme.primary;
      case WordStatus.NEEDS_REVIEW:
        return scheme.error;
    }
  }
}
