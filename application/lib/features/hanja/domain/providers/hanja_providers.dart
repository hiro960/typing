import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/hanja_character.dart';
import '../../data/models/hanja_models.dart';
import '../../data/models/hanja_word.dart';
import '../../data/repositories/hanja_repository.dart';

part 'hanja_providers.g.dart';

// ===== リポジトリプロバイダー =====

@Riverpod(keepAlive: true)
HanjaRepository hanjaRepository(Ref ref) {
  return HanjaRepository();
}

// ===== 単漢字プロバイダー =====

@riverpod
Future<List<HanjaCharacter>> allHanjaCharacters(Ref ref) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.loadAllCharacters();
}

@riverpod
Future<List<HanjaCharacter>> hanjaCharactersByLevel(
  Ref ref,
  HanjaLevel level,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getCharactersByLevel(level);
}

@riverpod
Future<HanjaCharacter?> hanjaCharacterDetail(
  Ref ref,
  String characterId,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getCharacterById(characterId);
}

@riverpod
Future<HanjaCharacter?> hanjaCharacterByChar(
  Ref ref,
  String character,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.searchByCharacter(character);
}

// ===== 漢字語プロバイダー =====

@riverpod
Future<List<HanjaWord>> allHanjaWords(Ref ref) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.loadAllWords();
}

@riverpod
Future<List<HanjaWord>> hanjaWordsByCategory(
  Ref ref,
  HanjaWordCategory category,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getWordsByCategory(category);
}

@riverpod
Future<List<HanjaWord>> hanjaWordsByLevel(
  Ref ref,
  HanjaLevel level,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getWordsByLevel(level);
}

@riverpod
Future<HanjaWord?> hanjaWordDetail(
  Ref ref,
  String wordId,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getWordById(wordId);
}

// ===== 検索プロバイダー =====

@riverpod
Future<HanjaSearchResult> hanjaSearch(
  Ref ref,
  String query,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.search(query);
}

@riverpod
Future<List<HanjaCharacter>> hanjaCharacterSearch(
  Ref ref,
  String query,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.searchCharacters(query);
}

@riverpod
Future<List<HanjaWord>> hanjaWordSearch(
  Ref ref,
  String query,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.searchWords(query);
}

@riverpod
Future<List<HanjaCharacter>> hanjaByKorean(
  Ref ref,
  String korean,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.searchByKorean(korean);
}

@riverpod
Future<List<HanjaCharacter>> hanjaByJapanese(
  Ref ref,
  String japanese,
) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.searchByJapanese(japanese);
}

// ===== 統計プロバイダー =====

@riverpod
Future<HanjaStatistics> hanjaStatistics(Ref ref) async {
  final repository = ref.watch(hanjaRepositoryProvider);
  return repository.getStatistics();
}

// ===== フィルター状態管理 =====

/// 五十音インデックス（ア行〜ワ行）
enum JapaneseOnIndex {
  a('ア', ['ア', 'イ', 'ウ', 'エ', 'オ']),
  ka('カ', ['カ', 'キ', 'ク', 'ケ', 'コ', 'ガ', 'ギ', 'グ', 'ゲ', 'ゴ']),
  sa('サ', ['サ', 'シ', 'ス', 'セ', 'ソ', 'ザ', 'ジ', 'ズ', 'ゼ', 'ゾ']),
  ta('タ', ['タ', 'チ', 'ツ', 'テ', 'ト', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド']),
  na('ナ', ['ナ', 'ニ', 'ヌ', 'ネ', 'ノ']),
  ha('ハ', ['ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'バ', 'ビ', 'ブ', 'ベ', 'ボ', 'パ', 'ピ', 'プ', 'ペ', 'ポ']),
  ma('マ', ['マ', 'ミ', 'ム', 'メ', 'モ']),
  ya('ヤ', ['ヤ', 'ユ', 'ヨ']),
  ra('ラ', ['ラ', 'リ', 'ル', 'レ', 'ロ']),
  wa('ワ', ['ワ', 'ヲ', 'ン']);

  const JapaneseOnIndex(this.label, this.characters);

  final String label;
  final List<String> characters;

  /// 音読みがこの行に属するかどうか
  bool matches(String reading) {
    if (reading.isEmpty) return false;
    final firstChar = reading[0];
    return characters.contains(firstChar);
  }
}

class HanjaFilterState {
  const HanjaFilterState({
    this.searchQuery = '',
    this.selectedLevel,
    this.selectedCategory,
    this.searchType = HanjaSearchType.all,
    this.japaneseOnIndex,
  });

  final String searchQuery;
  final HanjaLevel? selectedLevel;
  final HanjaWordCategory? selectedCategory;
  final HanjaSearchType searchType;
  final JapaneseOnIndex? japaneseOnIndex;

  HanjaFilterState copyWith({
    String? searchQuery,
    HanjaLevel? selectedLevel,
    HanjaWordCategory? selectedCategory,
    HanjaSearchType? searchType,
    JapaneseOnIndex? japaneseOnIndex,
    bool clearLevel = false,
    bool clearCategory = false,
    bool clearJapaneseOnIndex = false,
  }) {
    return HanjaFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLevel: clearLevel ? null : (selectedLevel ?? this.selectedLevel),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchType: searchType ?? this.searchType,
      japaneseOnIndex: clearJapaneseOnIndex ? null : (japaneseOnIndex ?? this.japaneseOnIndex),
    );
  }

  bool get hasFilters =>
      searchQuery.isNotEmpty ||
      selectedLevel != null ||
      selectedCategory != null ||
      japaneseOnIndex != null;
}

enum HanjaSearchType {
  all,
  characters,
  words,
}

@riverpod
class HanjaFilterNotifier extends _$HanjaFilterNotifier {
  @override
  HanjaFilterState build() => const HanjaFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setLevel(HanjaLevel? level) {
    if (level == state.selectedLevel) {
      state = state.copyWith(clearLevel: true);
    } else {
      state = state.copyWith(selectedLevel: level);
    }
  }

  void setCategory(HanjaWordCategory? category) {
    if (category == state.selectedCategory) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
  }

  void setSearchType(HanjaSearchType type) {
    state = state.copyWith(searchType: type);
  }

  void setJapaneseOnIndex(JapaneseOnIndex? index) {
    state = HanjaFilterState(
      searchQuery: state.searchQuery,
      selectedLevel: state.selectedLevel,
      selectedCategory: state.selectedCategory,
      searchType: state.searchType,
      japaneseOnIndex: index,
    );
  }

  void clearFilters() {
    state = const HanjaFilterState();
  }
}

@riverpod
Future<HanjaSearchResult> filteredHanjaSearch(Ref ref) async {
  final filter = ref.watch(hanjaFilterProvider);
  final repository = ref.watch(hanjaRepositoryProvider);

  if (!filter.hasFilters) {
    // フィルターなしの場合は全データを返す
    final characters = await repository.loadAllCharacters();
    final words = await repository.loadAllWords();
    return HanjaSearchResult(
      query: '',
      characters: characters,
      words: words,
    );
  }

  // 検索実行
  var characters = <HanjaCharacter>[];
  var words = <HanjaWord>[];

  final showCharacters = filter.searchType == HanjaSearchType.all ||
      filter.searchType == HanjaSearchType.characters;
  final showWords = filter.searchType == HanjaSearchType.all ||
      filter.searchType == HanjaSearchType.words;

  // 五十音インデックスフィルターがある場合
  if (filter.japaneseOnIndex != null) {
    final startChars = filter.japaneseOnIndex!.characters;

    if (showCharacters) {
      characters = await repository.filterCharactersByJapaneseOnStart(startChars);
      // 追加のフィルター適用
      if (filter.searchQuery.isNotEmpty) {
        characters = characters.where((c) => c.matchesSearch(filter.searchQuery)).toList();
      }
      if (filter.selectedLevel != null) {
        characters = characters.where((c) => c.level == filter.selectedLevel).toList();
      }
    }

    if (showWords) {
      words = await repository.filterWordsByJapaneseOnStart(startChars);
      // 追加のフィルター適用
      if (filter.searchQuery.isNotEmpty) {
        words = words.where((w) => w.matchesSearch(filter.searchQuery)).toList();
      }
      if (filter.selectedLevel != null) {
        words = words.where((w) => w.level == filter.selectedLevel).toList();
      }
      if (filter.selectedCategory != null) {
        words = words.where((w) => w.category == filter.selectedCategory).toList();
      }
    }
  } else {
    // 五十音インデックスフィルターがない場合（従来の検索）
    if (showCharacters) {
      characters = await repository.searchCharacters(filter.searchQuery);
      if (filter.selectedLevel != null) {
        characters = characters.where((c) => c.level == filter.selectedLevel).toList();
      }
    }

    if (showWords) {
      words = await repository.searchWords(filter.searchQuery);
      if (filter.selectedLevel != null) {
        words = words.where((w) => w.level == filter.selectedLevel).toList();
      }
      if (filter.selectedCategory != null) {
        words = words.where((w) => w.category == filter.selectedCategory).toList();
      }
    }
  }

  return HanjaSearchResult(
    query: filter.searchQuery,
    characters: characters,
    words: words,
  );
}
