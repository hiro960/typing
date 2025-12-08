import 'hanja_models.dart';

/// 単漢字データ
class HanjaCharacter {
  const HanjaCharacter({
    required this.id,
    required this.character,
    required this.unicode,
    required this.korean,
    this.koreanAlt = const [],
    required this.japaneseOn,
    this.japaneseKun = const [],
    required this.meaning,
    this.strokeCount,
    this.radical,
    this.radicalKorean,
    required this.level,
    this.frequency,
    this.relatedWords = const [],
  });

  final String id;
  final String character;
  final String unicode;
  final String korean;
  final List<String> koreanAlt;
  final List<String> japaneseOn;
  final List<String> japaneseKun;
  final String meaning;
  final int? strokeCount;
  final String? radical;
  final String? radicalKorean;
  final HanjaLevel level;
  final HanjaFrequency? frequency;
  final List<String> relatedWords;

  factory HanjaCharacter.fromJson(Map<String, dynamic> json) {
    return HanjaCharacter(
      id: json['id'] as String? ?? '',
      character: json['character'] as String? ?? '',
      unicode: json['unicode'] as String? ?? '',
      korean: json['korean'] as String? ?? '',
      koreanAlt: (json['koreanAlt'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      japaneseOn: (json['japaneseOn'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      japaneseKun: (json['japaneseKun'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      meaning: json['meaning'] as String? ?? '',
      strokeCount: json['strokeCount'] as int?,
      radical: json['radical'] as String?,
      radicalKorean: json['radicalKorean'] as String?,
      level: _parseLevel(json['level'] as String?),
      frequency: _parseFrequency(json['frequency'] as String?),
      relatedWords: (json['relatedWords'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character': character,
      'unicode': unicode,
      'korean': korean,
      'koreanAlt': koreanAlt,
      'japaneseOn': japaneseOn,
      'japaneseKun': japaneseKun,
      'meaning': meaning,
      'strokeCount': strokeCount,
      'radical': radical,
      'radicalKorean': radicalKorean,
      'level': level.name,
      'frequency': frequency?.name,
      'relatedWords': relatedWords,
    };
  }

  /// 全ての韓国語読みを取得
  List<String> get allKoreanReadings {
    return [korean, ...koreanAlt];
  }

  /// 検索マッチング
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    // 漢字での検索
    if (character.contains(q)) return true;

    // 韓国語読みでの検索
    if (korean.contains(q)) return true;
    if (koreanAlt.any((alt) => alt.contains(q))) return true;

    // 日本語読みでの検索
    if (japaneseOn.any((on) => on.toLowerCase().contains(q))) return true;
    if (japaneseKun.any((kun) => kun.toLowerCase().contains(q))) return true;

    // 意味での検索
    if (meaning.toLowerCase().contains(q)) return true;

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
}

/// 単漢字インデックス
class HanjaCharacterIndex {
  const HanjaCharacterIndex({
    required this.version,
    required this.totalCharacters,
    required this.characters,
  });

  final String version;
  final int totalCharacters;
  final List<HanjaCharacterMeta> characters;

  factory HanjaCharacterIndex.fromJson(Map<String, dynamic> json) {
    final charactersJson = json['characters'] as List<dynamic>? ?? [];
    return HanjaCharacterIndex(
      version: json['version'] as String? ?? '1.0.0',
      totalCharacters: json['totalCharacters'] as int? ?? 0,
      characters: charactersJson
          .whereType<Map<String, dynamic>>()
          .map(HanjaCharacterMeta.fromJson)
          .toList(),
    );
  }
}

/// 単漢字メタデータ（一覧表示用）
class HanjaCharacterMeta {
  const HanjaCharacterMeta({
    required this.id,
    required this.character,
    required this.korean,
    required this.japaneseOn,
    required this.meaning,
    required this.level,
  });

  final String id;
  final String character;
  final String korean;
  final List<String> japaneseOn;
  final String meaning;
  final HanjaLevel level;

  factory HanjaCharacterMeta.fromJson(Map<String, dynamic> json) {
    return HanjaCharacterMeta(
      id: json['id'] as String? ?? '',
      character: json['character'] as String? ?? '',
      korean: json['korean'] as String? ?? '',
      japaneseOn: (json['japaneseOn'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
      meaning: json['meaning'] as String? ?? '',
      level: HanjaCharacter._parseLevel(json['level'] as String?),
    );
  }

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    if (character.contains(q)) return true;
    if (korean.contains(q)) return true;
    if (japaneseOn.any((on) => on.toLowerCase().contains(q))) return true;
    if (meaning.toLowerCase().contains(q)) return true;

    return false;
  }
}
