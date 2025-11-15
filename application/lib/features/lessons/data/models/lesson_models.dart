import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum LessonLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
}

extension LessonLevelX on LessonLevel {
  String get label {
    switch (this) {
      case LessonLevel.beginner:
        return '初級';
      case LessonLevel.intermediate:
        return '中級';
      case LessonLevel.advanced:
        return '上級';
    }
  }

  String get key => name;

  static LessonLevel? fromKey(String value) {
    for (final level in LessonLevel.values) {
      if (level.name == value) {
        return level;
      }
    }
    return null;
  }
}

@JsonEnum(alwaysCreate: true)
enum LessonSectionType {
  @JsonValue('character_drill')
  characterDrill,
  @JsonValue('word_practice')
  wordPractice,
  @JsonValue('sentence_practice')
  sentencePractice,
  @JsonValue('challenge')
  challenge,
  @JsonValue('review')
  review,
  @JsonValue('custom')
  custom,
}

extension LessonSectionTypeX on LessonSectionType {
  String get label {
    switch (this) {
      case LessonSectionType.characterDrill:
        return '文字ドリル';
      case LessonSectionType.wordPractice:
        return '単語練習';
      case LessonSectionType.sentencePractice:
        return '短文練習';
      case LessonSectionType.challenge:
        return 'チャレンジ';
      case LessonSectionType.review:
        return '復習';
      case LessonSectionType.custom:
        return 'レッスン';
    }
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.level,
    required this.order,
    this.description,
    required this.content,
  });

  final String id;
  final String title;
  final LessonLevel level;
  final int order;
  final String? description;
  final LessonContent content;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      level:
          LessonLevelX.fromKey(json['level'] as String? ?? 'beginner') ??
          LessonLevel.beginner,
      order: json['order'] as int? ?? 0,
      description: json['description'] as String?,
      content: LessonContent.fromJson(
        json['content'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class LessonContent {
  const LessonContent({this.sections = const []});

  final List<LessonSection> sections;

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List<dynamic>? ?? const [];
    return LessonContent(
      sections: sectionsJson
          .whereType<Map<String, dynamic>>()
          .map(LessonSection.fromJson)
          .toList(),
    );
  }
}

class LessonSection {
  const LessonSection({
    required this.type,
    required this.title,
    this.items = const [],
  });

  final LessonSectionType type;
  final String title;
  final List<LessonItem> items;

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] as String? ?? 'custom';
    final parsedType = LessonSectionType.values.firstWhere(
      (value) => value.name == typeValue,
      orElse: () => LessonSectionType.custom,
    );
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    return LessonSection(
      type: parsedType,
      title: json['title'] as String? ?? '',
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(LessonItem.fromJson)
          .toList(),
    );
  }
}

class LessonItem {
  const LessonItem({
    required this.text,
    this.meaning,
    this.pronunciation,
    this.hint,
  });

  final String text;
  final String? meaning;
  final String? pronunciation;
  final String? hint;

  factory LessonItem.fromJson(Map<String, dynamic> json) {
    return LessonItem(
      text: json['text'] as String? ?? '',
      meaning: json['meaning'] as String?,
      pronunciation: json['pronunciation'] as String?,
      hint: json['hint'] as String?,
    );
  }
}
