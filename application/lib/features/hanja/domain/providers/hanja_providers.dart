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

/// 韓国語初声インデックス（ㄱ〜ㅎ）
enum KoreanChoseongIndex {
  giyeok('ㄱ', 0x1100), // ᄀ
  nieun('ㄴ', 0x1102), // ᄂ
  digeut('ㄷ', 0x1103), // ᄃ
  rieul('ㄹ', 0x1105), // ᄅ
  mieum('ㅁ', 0x1106), // ᄆ
  bieup('ㅂ', 0x1107), // ᄇ
  siot('ㅅ', 0x1109), // ᄉ
  ieung('ㅇ', 0x110B), // ᄋ
  jieut('ㅈ', 0x110C), // ᄌ
  chieut('ㅊ', 0x110E), // ᄎ
  kieuk('ㅋ', 0x110F), // ᄏ
  tieut('ㅌ', 0x1110), // ᄐ
  pieup('ㅍ', 0x1111), // ᄑ
  hieut('ㅎ', 0x1112); // ᄒ

  const KoreanChoseongIndex(this.label, this.choseongCode);

  final String label;
  final int choseongCode;

  /// この初声インデックスに含まれる初声インデックスのリスト
  /// 韓国語の初声インデックス（0〜18）:
  /// ㄱ=0, ㄲ=1, ㄴ=2, ㄷ=3, ㄸ=4, ㄹ=5, ㅁ=6, ㅂ=7, ㅃ=8, ㅅ=9, ㅆ=10, ㅇ=11, ㅈ=12, ㅉ=13, ㅊ=14, ㅋ=15, ㅌ=16, ㅍ=17, ㅎ=18
  List<int> get choseongIndices {
    switch (this) {
      case KoreanChoseongIndex.giyeok:
        return [0, 1]; // ㄱ, ㄲ
      case KoreanChoseongIndex.nieun:
        return [2]; // ㄴ
      case KoreanChoseongIndex.digeut:
        return [3, 4]; // ㄷ, ㄸ
      case KoreanChoseongIndex.rieul:
        return [5]; // ㄹ
      case KoreanChoseongIndex.mieum:
        return [6]; // ㅁ
      case KoreanChoseongIndex.bieup:
        return [7, 8]; // ㅂ, ㅃ
      case KoreanChoseongIndex.siot:
        return [9, 10]; // ㅅ, ㅆ
      case KoreanChoseongIndex.ieung:
        return [11]; // ㅇ
      case KoreanChoseongIndex.jieut:
        return [12, 13]; // ㅈ, ㅉ
      case KoreanChoseongIndex.chieut:
        return [14]; // ㅊ
      case KoreanChoseongIndex.kieuk:
        return [15]; // ㅋ
      case KoreanChoseongIndex.tieut:
        return [16]; // ㅌ
      case KoreanChoseongIndex.pieup:
        return [17]; // ㅍ
      case KoreanChoseongIndex.hieut:
        return [18]; // ㅎ
    }
  }

  /// 韓国語の読みがこの初声に属するかどうか
  bool matches(String korean) {
    if (korean.isEmpty) return false;
    final firstChar = korean.codeUnitAt(0);
    // ハングル音節範囲: AC00 ~ D7A3
    if (firstChar < 0xAC00 || firstChar > 0xD7A3) return false;
    final choseongIndex = (firstChar - 0xAC00) ~/ 588; // 588 = 21 * 28
    return choseongIndices.contains(choseongIndex);
  }
}

class HanjaFilterState {
  const HanjaFilterState({
    this.searchQuery = '',
    this.selectedLevel,
    this.selectedCategory,
    this.searchType = HanjaSearchType.all,
    this.japaneseOnIndex,
    this.koreanChoseongIndex,
  });

  final String searchQuery;
  final HanjaLevel? selectedLevel;
  final HanjaWordCategory? selectedCategory;
  final HanjaSearchType searchType;
  final JapaneseOnIndex? japaneseOnIndex;
  final KoreanChoseongIndex? koreanChoseongIndex;

  HanjaFilterState copyWith({
    String? searchQuery,
    HanjaLevel? selectedLevel,
    HanjaWordCategory? selectedCategory,
    HanjaSearchType? searchType,
    JapaneseOnIndex? japaneseOnIndex,
    KoreanChoseongIndex? koreanChoseongIndex,
    bool clearLevel = false,
    bool clearCategory = false,
    bool clearJapaneseOnIndex = false,
    bool clearKoreanChoseongIndex = false,
  }) {
    return HanjaFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLevel: clearLevel ? null : (selectedLevel ?? this.selectedLevel),
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchType: searchType ?? this.searchType,
      japaneseOnIndex: clearJapaneseOnIndex ? null : (japaneseOnIndex ?? this.japaneseOnIndex),
      koreanChoseongIndex: clearKoreanChoseongIndex ? null : (koreanChoseongIndex ?? this.koreanChoseongIndex),
    );
  }

  bool get hasFilters =>
      searchQuery.isNotEmpty ||
      selectedLevel != null ||
      selectedCategory != null ||
      japaneseOnIndex != null ||
      koreanChoseongIndex != null;
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
      koreanChoseongIndex: null, // 日本語インデックス選択時は韓国語をクリア
    );
  }

  void setKoreanChoseongIndex(KoreanChoseongIndex? index) {
    state = HanjaFilterState(
      searchQuery: state.searchQuery,
      selectedLevel: state.selectedLevel,
      selectedCategory: state.selectedCategory,
      searchType: state.searchType,
      japaneseOnIndex: null, // 韓国語インデックス選択時は日本語をクリア
      koreanChoseongIndex: index,
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
  } else if (filter.koreanChoseongIndex != null) {
    // 韓国語初声インデックスフィルターがある場合
    final choseongIndices = filter.koreanChoseongIndex!.choseongIndices;

    if (showCharacters) {
      characters = await repository.filterCharactersByKoreanChoseong(choseongIndices);
      // 追加のフィルター適用
      if (filter.searchQuery.isNotEmpty) {
        characters = characters.where((c) => c.matchesSearch(filter.searchQuery)).toList();
      }
      if (filter.selectedLevel != null) {
        characters = characters.where((c) => c.level == filter.selectedLevel).toList();
      }
    }

    if (showWords) {
      words = await repository.filterWordsByKoreanChoseong(choseongIndices);
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
    // インデックスフィルターがない場合（従来の検索）
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
