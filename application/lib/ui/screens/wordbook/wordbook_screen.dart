import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import 'word_detail_screen.dart';
import 'word_form_screen.dart';

class WordbookScreen extends ConsumerStatefulWidget {
  const WordbookScreen({super.key});

  @override
  ConsumerState<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends ConsumerState<WordbookScreen> {
  final TextEditingController _searchController = TextEditingController();
  WordCategory _category = WordCategory.WORDS;
  Set<WordStatus> _statusFilters = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncWords = ref.watch(wordbookProvider);
    final filteredWords = ref.watch(
      filteredWordsProvider(
        category: _category,
        statusFilters: _statusFilters,
        searchQuery: _searchController.text,
      ),
    );

    final isLoading = asyncWords.isLoading;
    final theme = Theme.of(context);

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: FHeader(
              title: Text('📖 単語帳', style: theme.textTheme.headlineSmall),
              suffixes: [
                FButton(
                  style: FButtonStyle.ghost(),
                  onPress: () => _openForm(),
                  child: const Text('新規単語追加'),
                ),
              ],
            ),
          ),
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SegmentedButton<WordCategory>(
              segments: [
                for (final category in WordCategory.values)
                  ButtonSegment(
                    value: category,
                    label: Text(category.label),
                  ),
              ],
              selected: {_category},
              onSelectionChanged: (selection) {
                if (selection.isEmpty) return;
                setState(() => _category = selection.first);
              },
              showSelectedIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '単語・意味・例文で検索',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Wrap(
              spacing: 8,
              children: [
                for (final status in WordStatus.values)
                  FilterChip(
                    label: Text(status.label),
                    selected: _statusFilters.contains(status),
                    onSelected: (_) => _toggleStatus(status),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                  ref.read(wordbookProvider.notifier).refresh(),
              child: filteredWords.isEmpty
                  ? _EmptyState(
                      onAdd: _openForm,
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredWords.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return _WordCard(
                          word: word,
                          onTap: () => _openDetail(word.id),
                        );
                      },
                    ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  void _toggleStatus(WordStatus status) {
    setState(() {
      final updated = {..._statusFilters};
      if (updated.contains(status)) {
        updated.remove(status);
      } else {
        updated.add(status);
      }
      _statusFilters = updated;
    });
  }

  Future<void> _openForm([Word? word]) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordFormScreen(word: word),
      ),
    );
  }

  Future<void> _openDetail(String wordId) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailScreen(wordId: wordId),
      ),
    );
  }
}

class _WordCard extends ConsumerWidget {
  const _WordCard({
    required this.word,
    required this.onTap,
  });

  final Word word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text(word.status.label),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                word.word,
                style: theme.textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                word.meaning,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  word.example ?? '例文なし',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: () async {
                    await ref
                        .read(wordAudioServiceProvider.notifier)
                        .speak(word.word);
                  },
                  child: const Icon(Icons.volume_up_outlined, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            children: [
              const Icon(
                Icons.book_outlined,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              const Text(
                'まだ単語/文章がありません',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '覚えたい単語/文章を追加して、マイ単語帳を作りましょう。',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAdd,
                child: const Text('単語/文章を追加'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
