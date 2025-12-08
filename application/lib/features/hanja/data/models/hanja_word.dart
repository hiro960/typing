import 'hanja_models.dart';

/// 漢字語（熟語）データ
class HanjaWord {
  const HanjaWord({
    required this.id,
    required this.word,
    required this.hanja,
    required this.meaning,
    required this.pronunciation,
    required this.partOfSpeech,
    required this.level,
    this.frequency,
    required this.category,
    required this.components,
    required this.examples,
    this.relatedWords = const [],
    this.antonyms = const [],
    this.synonyms = const [],
  });

  final String id;
  final String word;
  final String hanja;
  final String meaning;
  final String pronunciation;
  final String partOfSpeech;
  final HanjaLevel level;
  final HanjaFrequency? frequency;
  final HanjaWordCategory category;
  final List<HanjaComponent> components;
  final List<HanjaExample> examples;
  final List<String> relatedWords;
  final List<String> antonyms;
  final List<String> synonyms;

  factory HanjaWord.fromJson(Map<String, dynamic> json) {
    final componentsJson = json['components'] as List<dynamic>? ?? [];
    final examplesJson = json['examples'] as List<dynamic>? ?? [];

    return HanjaWord(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      hanja: json['hanja'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? json['word'] as String? ?? '',
      partOfSpeech: json['partOfSpeech'] as String? ?? '명사',
      level: _parseLevel(json['level'] as String?),
      frequency: _parseFrequency(json['frequency'] as String?),
      category: _parseCategory(json['category'] as String?),
      components: componentsJson
          .whereType<Map<String, dynamic>>()
          .map(HanjaComponent.fromJson)
          .toList(),
      examples: examplesJson
          .whereType<Map<String, dynamic>>()
          .map(HanjaExample.fromJson)
          .toList(),
      relatedWords: (json['relatedWords'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'hanja': hanja,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'partOfSpeech': partOfSpeech,
      'level': level.name,
      'frequency': frequency?.name,
      'category': category.name,
      'components': components.map((c) => c.toJson()).toList(),
      'examples': examples.map((e) => e.toJson()).toList(),
      'relatedWords': relatedWords,
      'antonyms': antonyms,
      'synonyms': synonyms,
    };
  }

  /// 検索マッチング
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    // ハングルでの検索
    if (word.contains(q)) return true;

    // 漢字での検索
    if (hanja.contains(q)) return true;

    // 意味での検索
    if (meaning.toLowerCase().contains(q)) return true;

    // 構成漢字での検索
    if (components.any((c) =>
        c.character.contains(q) ||
        c.korean.contains(q) ||
        c.meaning.toLowerCase().contains(q))) {
      return true;
    }

    return false;
  }

  static HanjaLevel _parseLevel(String? value) {
    switch (value) {
      case 'basic':
        return HanjaLevel.basic;
      case 'intermediate':
        return HanjaLevel.intermediate;
      case 'advanced':
        return HanjaLevel.advanced;
      default:
        return HanjaLevel.basic;
    }
  }

  static HanjaFrequency? _parseFrequency(String? value) {
    switch (value) {
      case 'high':
        return HanjaFrequency.high;
      case 'medium':
        return HanjaFrequency.medium;
      case 'low':
        return HanjaFrequency.low;
      default:
        return null;
    }
  }

  static HanjaWordCategory _parseCategory(String? value) {
    switch (value) {
      case 'daily':
        return HanjaWordCategory.daily;
      case 'education':
        return HanjaWordCategory.education;
      case 'society':
        return HanjaWordCategory.society;
      case 'nature':
        return HanjaWordCategory.nature;
      case 'culture':
        return HanjaWordCategory.culture;
      default:
        return HanjaWordCategory.daily;
    }
  }
}

/// 漢字語の構成要素
class HanjaComponent {
  const HanjaComponent({
    required this.character,
    required this.korean,
    required this.meaning,
  });

  final String character;
  final String korean;
  final String meaning;

  factory HanjaComponent.fromJson(Map<String, dynamic> json) {
    return HanjaComponent(
      character: json['character'] as String? ?? '',
      korean: json['korean'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'character': character,
      'korean': korean,
      'meaning': meaning,
    };
  }
}

/// 例文
class HanjaExample {
  const HanjaExample({
    required this.sentence,
    required this.meaning,
  });

  final String sentence;
  final String meaning;

  factory HanjaExample.fromJson(Map<String, dynamic> json) {
    return HanjaExample(
      sentence: json['sentence'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentence': sentence,
      'meaning': meaning,
    };
  }
}

/// 漢字語インデックス
class HanjaWordIndex {
  const HanjaWordIndex({
    required this.version,
    required this.category,
    required this.categoryName,
    required this.totalWords,
    required this.words,
  });

  final String version;
  final HanjaWordCategory category;
  final String categoryName;
  final int totalWords;
  final List<HanjaWordMeta> words;

  factory HanjaWordIndex.fromJson(Map<String, dynamic> json) {
    final wordsJson = json['words'] as List<dynamic>? ?? [];
    return HanjaWordIndex(
      version: json['version'] as String? ?? '1.0.0',
      category: HanjaWord._parseCategory(json['category'] as String?),
      categoryName: json['categoryName'] as String? ?? '',
      totalWords: json['totalWords'] as int? ?? 0,
      words: wordsJson
          .whereType<Map<String, dynamic>>()
          .map(HanjaWordMeta.fromJson)
          .toList(),
    );
  }
}

/// 漢字語メタデータ（一覧表示用）
class HanjaWordMeta {
  const HanjaWordMeta({
    required this.id,
    required this.word,
    required this.hanja,
    required this.meaning,
    required this.level,
    required this.category,
  });

  final String id;
  final String word;
  final String hanja;
  final String meaning;
  final HanjaLevel level;
  final HanjaWordCategory category;

  factory HanjaWordMeta.fromJson(Map<String, dynamic> json) {
    return HanjaWordMeta(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      hanja: json['hanja'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      level: HanjaWord._parseLevel(json['level'] as String?),
      category: HanjaWord._parseCategory(json['category'] as String?),
    );
  }

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    if (word.contains(q)) return true;
    if (hanja.contains(q)) return true;
    if (meaning.toLowerCase().contains(q)) return true;

    return false;
  }
}
