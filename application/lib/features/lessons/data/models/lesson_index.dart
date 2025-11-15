import 'dart:collection';

import 'lesson_models.dart';

class LessonIndex {
  const LessonIndex({
    required this.version,
    required this.lastUpdated,
    required this.levels,
  });

  final String version;
  final DateTime lastUpdated;
  final Map<LessonLevel, LessonLevelCatalog> levels;

  factory LessonIndex.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as String? ?? '1.0.0';
    final lastUpdatedStr = json['lastUpdated'] as String?;
    final lastUpdated =
        DateTime.tryParse(lastUpdatedStr ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final levelsJson = json['levels'] as Map<String, dynamic>? ?? {};
    final levelMap = <LessonLevel, LessonLevelCatalog>{};

    for (final level in LessonLevel.values) {
      final levelJson = levelsJson[level.name];
      if (levelJson is Map<String, dynamic>) {
        levelMap[level] = LessonLevelCatalog.fromJson(level, levelJson);
      } else {
        levelMap[level] = LessonLevelCatalog.empty(level);
      }
    }

    return LessonIndex(
      version: version,
      lastUpdated: lastUpdated,
      levels: UnmodifiableMapView(levelMap),
    );
  }

  List<LessonMeta> lessonsByLevel(LessonLevel level) {
    return levels[level]?.lessons ?? const [];
  }

  LessonMeta? findLessonMeta(String lessonId) {
    for (final catalog in levels.values) {
      for (final meta in catalog.lessons) {
        if (meta.id == lessonId) {
          return meta;
        }
      }
    }
    return null;
  }
}

class LessonLevelCatalog {
  const LessonLevelCatalog({
    required this.level,
    required this.totalLessons,
    required this.lessons,
  });

  final LessonLevel level;
  final int totalLessons;
  final List<LessonMeta> lessons;

  factory LessonLevelCatalog.fromJson(
    LessonLevel level,
    Map<String, dynamic> json,
  ) {
    final lessonsJson = json['lessons'] as List<dynamic>? ?? const [];
    final lessons =
        lessonsJson
            .whereType<Map<String, dynamic>>()
            .map((raw) => LessonMeta.fromMap(level, raw))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final total = json['totalLessons'] as int? ?? lessons.length;

    return LessonLevelCatalog(
      level: level,
      totalLessons: total,
      lessons: List.unmodifiable(lessons),
    );
  }

  factory LessonLevelCatalog.empty(LessonLevel level) {
    return LessonLevelCatalog(level: level, totalLessons: 0, lessons: const []);
  }
}

class LessonMeta {
  const LessonMeta({
    required this.id,
    required this.level,
    required this.order,
    required this.title,
    required this.file,
    this.isLocked = false,
  });

  final String id;
  final LessonLevel level;
  final int order;
  final String title;
  final String file;
  final bool isLocked;

  factory LessonMeta.fromMap(LessonLevel level, Map<String, dynamic> json) {
    return LessonMeta(
      id: json['id'] as String? ?? '',
      level: level,
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      file: json['file'] as String? ?? '',
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }
}
