import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

enum WordbookCategory { myWords, examples, idioms }

const _categoryLabels = {
  WordbookCategory.myWords: 'マイ単語',
  WordbookCategory.examples: '例文コレクション',
  WordbookCategory.idioms: 'フレーズ/慣用句',
};

const _tagFilters = ['覚えた', '復習中', '要確認'];

class WordEntry {
  const WordEntry({
    required this.word,
    required this.reading,
    required this.meaning,
    required this.example,
    required this.status,
    required this.category,
  });

  final String word;
  final String reading;
  final String meaning;
  final String example;
  final String status;
  final WordbookCategory category;
}

const _entries = [
  WordEntry(
    word: '안녕하세요',
    reading: 'annyeong-haseyo',
    meaning: 'こんにちは',
    example: '안녕하세요? 오늘도 열공해요!',
    status: '覚えた',
    category: WordbookCategory.myWords,
  ),
  WordEntry(
    word: '설레다',
    reading: 'seolleda',
    meaning: 'ときめく',
    example: '내일 한국 여행이라 설레요.',
    status: '復習中',
    category: WordbookCategory.myWords,
  ),
  WordEntry(
    word: '비가 오다',
    reading: 'biga oda',
    meaning: '雨が降る',
    example: '오늘 비가 와서 카페에 있었어요.',
    status: '要確認',
    category: WordbookCategory.examples,
  ),
  WordEntry(
    word: '화이팅',
    reading: 'hwaiting',
    meaning: 'ファイト',
    example: '시험 잘 보고 와! 화이팅!',
    status: '覚えた',
    category: WordbookCategory.idioms,
  ),
];

class WordbookScreen extends StatefulWidget {
  const WordbookScreen({super.key});

  @override
  State<WordbookScreen> createState() => _WordbookScreenState();
}

class _WordbookScreenState extends State<WordbookScreen> {
  final TextEditingController _searchController = TextEditingController();
  WordbookCategory _category = WordbookCategory.myWords;
  final Set<String> _selectedTags = {'復習中'};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _entries.where((entry) {
      if (entry.category != _category) return false;
      if (_selectedTags.isNotEmpty && !_selectedTags.contains(entry.status)) {
        return false;
      }
      final query = _searchController.text.trim().toLowerCase();
      if (query.isEmpty) return true;
      return entry.word.contains(query) ||
          entry.meaning.contains(query) ||
          entry.example.toLowerCase().contains(query);
    }).toList();

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
                    onPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('追加フォームは近日公開予定です。')),
                      );
                    },
                    child: const Text('新規単語追加'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SegmentedButton<WordbookCategory>(
                segments: [
                  for (final category in WordbookCategory.values)
                    ButtonSegment(
                      value: category,
                      label: Text(_categoryLabels[category]!),
                    ),
                ],
                selected: {_category},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) return;
                  setState(() => _category = selection.first);
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
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
                  for (final tag in _tagFilters)
                    FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (_) => _toggleTag(tag),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final entry = filtered[index];
                  return _WordCard(entry: entry);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }
}

class _WordCard extends StatelessWidget {
  const _WordCard({required this.entry});

  final WordEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(entry.status),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.08,
                  ),
                  labelStyle: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Chip(
                  label: Text(entry.reading),
                  backgroundColor: theme.colorScheme.surfaceVariant,
                ),
              ],
            ),
            const Spacer(),
            Text(entry.word, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              entry.meaning,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.example,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FButton.icon(
                onPress: () {},
                style: FButtonStyle.ghost(),
                child: const Icon(Icons.volume_up_outlined, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
