import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/utils/logger.dart';
import '../models/hanja_character.dart';
import '../models/hanja_models.dart';
import '../models/hanja_word.dart';

/// 漢字語辞典データの読み込みと検索を管理するリポジトリ
class HanjaRepository {
  HanjaRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  // キャッシュ
  List<HanjaCharacter>? _charactersCache;
  List<HanjaWord>? _wordsCache;
  final Map<String, HanjaCharacter> _characterDetailCache = {};
  final Map<String, HanjaWord> _wordDetailCache = {};

  // アセットパス
  static const _characterFiles = [
    'assets/hanja/characters/characters_a_ka.json',
    'assets/hanja/characters/characters_sa_ta.json',
    'assets/hanja/characters/characters_na_ha.json',
    'assets/hanja/characters/characters_ma_wa.json',
  ];

  static const _wordFiles = [
    'assets/hanja/words/words_daily.json',
    'assets/hanja/words/words_education.json',
    'assets/hanja/words/words_society.json',
    'assets/hanja/words/words_nature.json',
    'assets/hanja/words/words_culture.json',
  ];

  /// 全単漢字データを読み込む
  Future<List<HanjaCharacter>> loadAllCharacters() async {
    if (_charactersCache != null) {
      return _charactersCache!;
    }

    final allCharacters = <HanjaCharacter>[];

    for (final path in _characterFiles) {
      try {
        final jsonString = await _bundle.loadString(path);
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final charactersJson = jsonMap['characters'] as List<dynamic>? ?? [];

        for (final charJson in charactersJson) {
          if (charJson is Map<String, dynamic>) {
            final character = HanjaCharacter.fromJson(charJson);
            allCharacters.add(character);
            _characterDetailCache[character.id] = character;
          }
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Failed to load hanja characters from $path',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    _charactersCache = allCharacters;
    return allCharacters;
  }

  /// 全漢字語データを読み込む
  Future<List<HanjaWord>> loadAllWords() async {
    if (_wordsCache != null) {
      return _wordsCache!;
    }

    final allWords = <HanjaWord>[];

    for (final path in _wordFiles) {
      try {
        final jsonString = await _bundle.loadString(path);
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final wordsJson = jsonMap['words'] as List<dynamic>? ?? [];

        for (final wordJson in wordsJson) {
          if (wordJson is Map<String, dynamic>) {
            final word = HanjaWord.fromJson(wordJson);
            allWords.add(word);
            _wordDetailCache[word.id] = word;
          }
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Failed to load hanja words from $path',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    _wordsCache = allWords;
    return allWords;
  }

  /// 単漢字を検索
  Future<List<HanjaCharacter>> searchCharacters(String query) async {
    final characters = await loadAllCharacters();
    if (query.isEmpty) {
      return characters;
    }
    return characters.where((c) => c.matchesSearch(query)).toList();
  }

  /// 漢字語を検索
  Future<List<HanjaWord>> searchWords(String query) async {
    final words = await loadAllWords();
    if (query.isEmpty) {
      return words;
    }
    return words.where((w) => w.matchesSearch(query)).toList();
  }

  /// 統合検索（漢字と漢字語の両方を検索）
  Future<HanjaSearchResult> search(String query) async {
    final characters = await searchCharacters(query);
    final words = await searchWords(query);

    return HanjaSearchResult(
      query: query,
      characters: characters,
      words: words,
    );
  }

  /// 韓国語読みで漢字を検索
  Future<List<HanjaCharacter>> searchByKorean(String korean) async {
    final characters = await loadAllCharacters();
    return characters.where((c) {
      return c.korean == korean || c.koreanAlt.contains(korean);
    }).toList();
  }

  /// 日本語読みで漢字を検索
  Future<List<HanjaCharacter>> searchByJapanese(String japanese) async {
    final characters = await loadAllCharacters();
    final query = japanese.toUpperCase();
    return characters.where((c) {
      return c.japaneseOn.any((on) => on.toUpperCase() == query) ||
          c.japaneseKun.any((kun) => kun.contains(japanese));
    }).toList();
  }

  /// 日本語音読みの頭文字で単漢字をフィルタリング
  /// [startChars] はフィルタリングする頭文字のリスト（例: ['ア', 'イ', 'ウ', 'エ', 'オ']）
  Future<List<HanjaCharacter>> filterCharactersByJapaneseOnStart(
    List<String> startChars,
  ) async {
    final characters = await loadAllCharacters();
    return characters.where((c) {
      return c.japaneseOn.any((on) {
        if (on.isEmpty) return false;
        return startChars.contains(on[0]);
      });
    }).toList();
  }

  /// 日本語音読みの頭文字で漢字語をフィルタリング
  /// 漢字語の最初の漢字の音読みを基準にフィルタリング
  Future<List<HanjaWord>> filterWordsByJapaneseOnStart(
    List<String> startChars,
  ) async {
    final words = await loadAllWords();
    final characters = await loadAllCharacters();

    // 漢字→音読みのマップを作成（高速ルックアップ用）
    final charToOnReadings = <String, List<String>>{};
    for (final c in characters) {
      charToOnReadings[c.character] = c.japaneseOn;
    }

    return words.where((word) {
      if (word.hanja.isEmpty) return false;
      final firstHanja = word.hanja[0];
      final onReadings = charToOnReadings[firstHanja];
      if (onReadings == null || onReadings.isEmpty) return false;
      return onReadings.any((on) {
        if (on.isEmpty) return false;
        return startChars.contains(on[0]);
      });
    }).toList();
  }

  /// 韓国語読みの初声で単漢字をフィルタリング
  /// [choseongIndices] は初声インデックスのリスト（0〜18）
  Future<List<HanjaCharacter>> filterCharactersByKoreanChoseong(
    List<int> choseongIndices,
  ) async {
    final characters = await loadAllCharacters();
    return characters.where((c) {
      return _matchesKoreanChoseong(c.korean, choseongIndices);
    }).toList();
  }

  /// 韓国語読みの初声で漢字語をフィルタリング
  Future<List<HanjaWord>> filterWordsByKoreanChoseong(
    List<int> choseongIndices,
  ) async {
    final words = await loadAllWords();
    return words.where((word) {
      return _matchesKoreanChoseong(word.word, choseongIndices);
    }).toList();
  }

  /// 韓国語文字列の最初の文字が指定した初声インデックスに含まれるかチェック
  bool _matchesKoreanChoseong(String korean, List<int> choseongIndices) {
    if (korean.isEmpty) return false;
    final firstChar = korean.codeUnitAt(0);
    // ハングル音節範囲: AC00 ~ D7A3
    if (firstChar < 0xAC00 || firstChar > 0xD7A3) return false;
    final choseongIndex = (firstChar - 0xAC00) ~/ 588; // 588 = 21 * 28
    return choseongIndices.contains(choseongIndex);
  }

  /// 漢字で検索
  Future<HanjaCharacter?> searchByCharacter(String character) async {
    final characters = await loadAllCharacters();
    try {
      return characters.firstWhere((c) => c.character == character);
    } catch (_) {
      return null;
    }
  }

  /// カテゴリ別に漢字語を取得
  Future<List<HanjaWord>> getWordsByCategory(HanjaWordCategory category) async {
    final words = await loadAllWords();
    return words.where((w) => w.category == category).toList();
  }

  /// レベル別に単漢字を取得
  Future<List<HanjaCharacter>> getCharactersByLevel(HanjaLevel level) async {
    final characters = await loadAllCharacters();
    return characters.where((c) => c.level == level).toList();
  }

  /// レベル別に漢字語を取得
  Future<List<HanjaWord>> getWordsByLevel(HanjaLevel level) async {
    final words = await loadAllWords();
    return words.where((w) => w.level == level).toList();
  }

  /// 単漢字の詳細を取得
  Future<HanjaCharacter?> getCharacterById(String id) async {
    if (_characterDetailCache.containsKey(id)) {
      return _characterDetailCache[id];
    }

    await loadAllCharacters();
    return _characterDetailCache[id];
  }

  /// 漢字語の詳細を取得
  Future<HanjaWord?> getWordById(String id) async {
    if (_wordDetailCache.containsKey(id)) {
      return _wordDetailCache[id];
    }

    await loadAllWords();
    return _wordDetailCache[id];
  }

  /// 統計情報を取得
  Future<HanjaStatistics> getStatistics() async {
    final characters = await loadAllCharacters();
    final words = await loadAllWords();

    final charactersByLevel = <HanjaLevel, int>{};
    for (final level in HanjaLevel.values) {
      charactersByLevel[level] = characters.where((c) => c.level == level).length;
    }

    final wordsByLevel = <HanjaLevel, int>{};
    for (final level in HanjaLevel.values) {
      wordsByLevel[level] = words.where((w) => w.level == level).length;
    }

    final wordsByCategory = <HanjaWordCategory, int>{};
    for (final category in HanjaWordCategory.values) {
      wordsByCategory[category] = words.where((w) => w.category == category).length;
    }

    return HanjaStatistics(
      totalCharacters: characters.length,
      totalWords: words.length,
      charactersByLevel: charactersByLevel,
      wordsByLevel: wordsByLevel,
      wordsByCategory: wordsByCategory,
    );
  }

  /// キャッシュをクリア
  void clearCache() {
    _charactersCache = null;
    _wordsCache = null;
    _characterDetailCache.clear();
    _wordDetailCache.clear();
  }
}

/// 検索結果
class HanjaSearchResult {
  const HanjaSearchResult({
    required this.query,
    required this.characters,
    required this.words,
  });

  final String query;
  final List<HanjaCharacter> characters;
  final List<HanjaWord> words;

  int get totalCount => characters.length + words.length;
  bool get isEmpty => totalCount == 0;
  bool get isNotEmpty => totalCount > 0;
}

/// 統計情報
class HanjaStatistics {
  const HanjaStatistics({
    required this.totalCharacters,
    required this.totalWords,
    required this.charactersByLevel,
    required this.wordsByLevel,
    required this.wordsByCategory,
  });

  final int totalCharacters;
  final int totalWords;
  final Map<HanjaLevel, int> charactersByLevel;
  final Map<HanjaLevel, int> wordsByLevel;
  final Map<HanjaWordCategory, int> wordsByCategory;
}
