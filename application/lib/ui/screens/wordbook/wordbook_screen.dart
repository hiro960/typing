import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../features/wordbook/data/models/word_model.dart';
import '../../../features/wordbook/domain/providers/wordbook_providers.dart';
import '../../../features/settings/domain/providers/display_settings_provider.dart';
import '../../../features/settings/data/models/display_settings.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/page_state_views.dart';
import '../../app_spacing.dart';
import 'listening_screen.dart';
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
    final viewMode =
        ref.watch(wordbookViewModeProvider).value ?? WordbookViewMode.card;
    final displaySettings =
        ref.watch(displaySettingsProvider).value ?? const DisplaySettings();
    final fontScale = displaySettings.dictionaryFontScale;

    final reviewableWords = (asyncWords.value ?? [])
        .where((word) => word.status != WordStatus.MASTERED)
        .toList();
    final canStartQuiz = reviewableWords.isNotEmpty;

    final isLoading = asyncWords.isLoading;
    final theme = Theme.of(context);

    return AppPageScaffold(
      title: '単語帳',
      titleIcon: Iconsax.book,
      actions: [
        FHeaderAction(
          icon: Icon(
            viewMode == WordbookViewMode.card
                ? Iconsax.task_square
                : Iconsax.grid_1,
          ),
          onPress: () {
            ref.read(wordbookViewModeProvider.notifier).toggle();
          },
        ),
        FHeaderAction(
          icon: const Icon(Iconsax.play),
          onPress: canStartQuiz ? () => _startListening(reviewableWords) : null,
        ),
        FHeaderAction(
          icon: Badge(
            isLabelVisible: canStartQuiz,
            label: Text('${reviewableWords.length}'),
            child: const Icon(Iconsax.receipt_text),
          ),
          onPress: canStartQuiz ? () => _startQuiz(reviewableWords) : null,
        ),
        FHeaderAction(
          icon: const Icon(Iconsax.add),
          onPress: () => _openForm(),
        ),
      ],
      child: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(minHeight: 2),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppPadding.homePage.left,
              8,
              AppPadding.homePage.right,
              0,
            ),
            child: FTabs(
              key: ValueKey(_category),
              initialIndex: WordCategory.values.indexOf(_category),
              onChange: (index) {
                final selected = WordCategory.values[index];
                setState(() => _category = selected);
              },
              children: WordCategory.values
                  .map(
                    (category) {
                      final isSelected = category == _category;
                      final icon = category == WordCategory.WORDS
                          ? Iconsax.book_1
                          : Iconsax.note;
                      return FTabEntry(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 16,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: const SizedBox.shrink(),
                      );
                    },
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppPadding.homePage.left,
              12,
              AppPadding.homePage.right,
              0,
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
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
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(wordbookProvider.notifier).refresh(),
              child: filteredWords.isEmpty
                  ? PageEmptyView(
                      icon: Iconsax.book,
                      title: 'まだ単語/文章がありません',
                      description: '覚えたい単語/文章を追加して、マイ単語帳を作りましょう。',
                      actionLabel: '単語/文章を追加',
                      onAction: _openForm,
                    )
                  : MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(fontScale),
                      ),
                      child: viewMode == WordbookViewMode.card
                          ? GridView.builder(
                              padding: EdgeInsets.fromLTRB(
                                AppPadding.homePage.left,
                                0,
                                AppPadding.homePage.right,
                                AppSpacing.xl,
                              ),
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
                            )
                          : ListView.separated(
                              padding: EdgeInsets.fromLTRB(
                                AppPadding.homePage.left,
                                0,
                                AppPadding.homePage.right,
                                AppSpacing.xl,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filteredWords.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final word = filteredWords[index];
                                return _WordListTile(
                                  word: word,
                                  onTap: () => _openDetail(word.id),
                                );
                              },
                            ),
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

  Future<void> _startListening(List<Word> words) async {
    if (words.isEmpty) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ListeningScreen(words: words)),
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
                    child: const Icon(Iconsax.volume_high, size: 18),
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
                Iconsax.tick_square,
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

class _WordListTile extends ConsumerWidget {
  const _WordListTile({required this.word, required this.onTap});

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
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor(word.status, theme),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      word.meaning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FButton.icon(
                style: FButtonStyle.ghost(),
                onPress: () async {
                  await ref
                      .read(wordAudioServiceProvider.notifier)
                      .speak(word.word);
                },
                child: const Icon(Iconsax.volume_high, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
