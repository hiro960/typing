import 'dart:collection';

import 'grammar_models.dart';

/// 文法インデックス（全体管理）
class GrammarIndex {
  const GrammarIndex({
    required this.version,
    required this.lastUpdated,
    required this.categories,
  });

  final String version;
  final DateTime lastUpdated;
  final Map<GrammarCategory, GrammarCategoryCatalog> categories;

  factory GrammarIndex.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as String? ?? '1.0.0';
    final lastUpdatedStr = json['lastUpdated'] as String?;
    final lastUpdated =
        DateTime.tryParse(lastUpdatedStr ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final categoriesJson = json['categories'] as Map<String, dynamic>? ?? {};
    final categoryMap = <GrammarCategory, GrammarCategoryCatalog>{};

    for (final category in GrammarCategory.values) {
      final categoryJson = categoriesJson[category.jsonKey];
      if (categoryJson is Map<String, dynamic>) {
        categoryMap[category] = GrammarCategoryCatalog.fromJson(
          category,
          categoryJson,
        );
      } else {
        categoryMap[category] = GrammarCategoryCatalog.empty(category);
      }
    }

    return GrammarIndex(
      version: version,
      lastUpdated: lastUpdated,
      categories: UnmodifiableMapView(categoryMap),
    );
  }

  /// カテゴリ別の文法一覧を取得
  List<GrammarMeta> itemsByCategory(GrammarCategory category) {
    return categories[category]?.items ?? const [];
  }

  /// 文法IDからメタデータを検索
  GrammarMeta? findGrammarMeta(String grammarId) {
    for (final catalog in categories.values) {
      for (final meta in catalog.items) {
        if (meta.id == grammarId) {
          return meta;
        }
      }
    }
    return null;
  }

  /// 全文法項目を取得（検索用）
  List<GrammarMeta> get allItems {
    return categories.values.expand((c) => c.items).toList();
  }

  /// 全文法項目数
  int get totalItems {
    return categories.values.fold(0, (sum, c) => sum + c.totalItems);
  }
}

/// カテゴリ別カタログ
class GrammarCategoryCatalog {
  const GrammarCategoryCatalog({
    required this.category,
    required this.name,
    required this.description,
    required this.order,
    required this.totalItems,
    required this.items,
  });

  final GrammarCategory category;
  final String name;
  final String description;
  final int order;
  final int totalItems;
  final List<GrammarMeta> items;

  factory GrammarCategoryCatalog.fromJson(
    GrammarCategory category,
    Map<String, dynamic> json,
  ) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    final items =
        itemsJson
            .whereType<Map<String, dynamic>>()
            .map((raw) => GrammarMeta.fromJson(category, raw))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    final total = json['totalItems'] as int? ?? items.length;

    return GrammarCategoryCatalog(
      category: category,
      name: json['name'] as String? ?? category.label,
      description: json['description'] as String? ?? category.description,
      order: json['order'] as int? ?? 0,
      totalItems: total,
      items: List.unmodifiable(items),
    );
  }

  factory GrammarCategoryCatalog.empty(GrammarCategory category) {
    return GrammarCategoryCatalog(
      category: category,
      name: category.label,
      description: category.description,
      order: 0,
      totalItems: 0,
      items: const [],
    );
  }
}

/// 文法項目のメタデータ（一覧表示用）
class GrammarMeta {
  const GrammarMeta({
    required this.id,
    required this.order,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.level,
    required this.file,
    this.tags = const [],
  });

  final String id;
  final int order;
  final String title;
  final String subtitle;
  final GrammarCategory category;
  final GrammarLevel level;
  final String file;
  final List<String> tags;

  factory GrammarMeta.fromJson(
    GrammarCategory category,
    Map<String, dynamic> json,
  ) {
    final levelStr = json['level'] as String? ?? 'beginner';
    final tagsJson = json['tags'] as List<dynamic>? ?? const [];

    return GrammarMeta(
      id: json['id'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      category: category,
      level: GrammarLevelX.fromKey(levelStr) ?? GrammarLevel.beginner,
      file: json['file'] as String? ?? '',
      tags: tagsJson.whereType<String>().toList(),
    );
  }

  /// 検索用のマッチング
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }
}
