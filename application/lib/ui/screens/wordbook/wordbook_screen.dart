import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../widgets/app_page_scaffold.dart';
import 'word_detail_screen.dart';
import 'word_form_screen.dart';
import 'word_quiz_screen.dart';

class WordbookScreen extends ConsumerStatefulWidget {
  const WordbookScreen({super.key});

  @override
  ConsumerState<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends ConsumerState<WordbookScreen> {
  WordCategory _category = WordCategory.WORDS;
  Set<WordStatus> _statusFilters = {};

  @override
  Widget build(BuildContext context) {
    final asyncWords = ref.watch(wordbookProvider);
    final filteredWords = ref.watch(
      filteredWordsProvider(
        category: _category,
        statusFilters: _statusFilters,
        searchQuery: '',
      ),
    );

    final reviewableWords = (asyncWords.value ?? [])
        .where((word) => word.status != WordStatus.MASTERED)
        .toList();
    final canStartQuiz = reviewableWords.isNotEmpty;

    final isLoading = asyncWords.isLoading;
    final theme = Theme.of(context);

    return AppPageScaffold(
      childPad: false,
      header: FHeader(
        title: Row(
          children: [
            Icon(
              Icons.book_outlined,
              size: 22,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text('単語帳', style: theme.textTheme.headlineSmall),
          ],
        ),
        suffixes: [
          FHeaderAction(
            icon: Badge(
              isLabelVisible: canStartQuiz,
              label: Text('${reviewableWords.length}'),
              child: const Icon(Icons.quiz_outlined),
            ),
            onPress: canStartQuiz ? () => _startQuiz(reviewableWords) : null,
          ),
          FHeaderAction(
            icon: const Icon(Icons.add),
            onPress: () => _openForm(),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: FTabs(
              key: ValueKey(_category),
              initialIndex: WordCategory.values.indexOf(_category),
              onChange: (index) {
                final selected = WordCategory.values[index];
                setState(() => _category = selected);
              },
              children: WordCategory.values
                  .map(
                    (category) => FTabEntry(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          category.label,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      child: const SizedBox.shrink(),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final status in WordStatus.values)
                  _StatusFilterChip(
                    label: status.label,
                    selected: _statusFilters.contains(status),
                    onTap: () => _toggleStatus(status),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(wordbookProvider.notifier).refresh(),
              child: filteredWords.isEmpty
                  ? _EmptyState(onAdd: _openForm)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredWords.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
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
    );
  }

  Future<void> _startQuiz(List<Word> words) async {
    if (words.isEmpty) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => WordQuizScreen(words: words)),
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
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => WordFormScreen(word: word)));
  }

  Future<void> _openDetail(String wordId) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => WordDetailScreen(wordId: wordId)),
    );
  }
}

class _WordCard extends ConsumerWidget {
  const _WordCard({required this.word, required this.onTap});

  final Word word;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _statusColor(word.status, theme),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    word.status.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  FButton.icon(
                    style: FButtonStyle.ghost(),
                    onPress: () async {
                      await ref
                          .read(wordAudioServiceProvider.notifier)
                          .speak(word.word);
                    },
                    child: const Icon(Icons.volume_up_outlined, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                word.word,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                word.meaning,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  word.example ?? '例文なし',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(WordStatus status, ThemeData theme) {
  switch (status) {
    case WordStatus.MASTERED:
      return theme.colorScheme.secondary;
    case WordStatus.REVIEWING:
      return theme.colorScheme.primary;
    case WordStatus.NEEDS_REVIEW:
      return theme.colorScheme.tertiary;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Column(
            children: [
              Icon(
                Icons.book_outlined,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 16),
              Text(
                'まだ単語/文章がありません',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '覚えたい単語/文章を追加して、マイ単語帳を作りましょう。',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              FButton(
                onPress: onAdd,
                child: const Text('単語/文章を追加'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(
                Icons.check,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
