import 'grammar_exercise.dart';
import 'grammar_models.dart';

/// 文法詳細（個別ファイルから読み込み）
class GrammarDetail {
  const GrammarDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.level,
    required this.tags,
    required this.content,
    required this.exercises,
    this.metadata,
  });

  final String id;
  final String title;
  final String subtitle;
  final GrammarCategory category;
  final GrammarLevel level;
  final List<String> tags;
  final GrammarContent content;
  final List<GrammarExercise> exercises;
  final GrammarMetadata? metadata;

  factory GrammarDetail.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ?? 'particle';
    final levelStr = json['level'] as String? ?? 'beginner';
    final tagsJson = json['tags'] as List<dynamic>? ?? const [];
    final contentJson = json['content'] as Map<String, dynamic>? ?? const {};
    final exercisesJson = json['exercises'] as List<dynamic>? ?? const [];
    final metadataJson = json['metadata'] as Map<String, dynamic>?;

    return GrammarDetail(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      category:
          GrammarCategoryX.fromKey(categoryStr) ?? GrammarCategory.particle,
      level: GrammarLevelX.fromKey(levelStr) ?? GrammarLevel.beginner,
      tags: tagsJson.whereType<String>().toList(),
      content: GrammarContent.fromJson(contentJson),
      exercises: exercisesJson
          .whereType<Map<String, dynamic>>()
          .map(GrammarExercise.fromJson)
          .toList(),
      metadata: metadataJson != null
          ? GrammarMetadata.fromJson(metadataJson)
          : null,
    );
  }
}

/// 文法コンテンツ
class GrammarContent {
  const GrammarContent({
    required this.summary,
    this.formationRules = const [],
    this.usageCases = const [],
    this.comparison,
    this.tips = const [],
    this.relatedGrammar = const [],
    this.audioOverview,
  });

  final String summary;
  final List<FormationRule> formationRules;
  final List<UsageCase> usageCases;
  final GrammarComparison? comparison;
  final List<String> tips;
  final List<String> relatedGrammar;
  final String? audioOverview;

  factory GrammarContent.fromJson(Map<String, dynamic> json) {
    final rulesJson = json['formationRules'] as List<dynamic>? ?? const [];
    final casesJson = json['usageCases'] as List<dynamic>? ?? const [];
    final comparisonJson = json['comparison'] as Map<String, dynamic>?;
    final tipsJson = json['tips'] as List<dynamic>? ?? const [];
    final relatedJson = json['relatedGrammar'] as List<dynamic>? ?? const [];

    return GrammarContent(
      summary: json['summary'] as String? ?? '',
      formationRules: rulesJson
          .whereType<Map<String, dynamic>>()
          .map(FormationRule.fromJson)
          .toList(),
      usageCases: casesJson
          .whereType<Map<String, dynamic>>()
          .map(UsageCase.fromJson)
          .toList(),
      comparison: comparisonJson != null
          ? GrammarComparison.fromJson(comparisonJson)
          : null,
      tips: tipsJson.whereType<String>().toList(),
      relatedGrammar: relatedJson.whereType<String>().toList(),
      audioOverview: json['audioOverview'] as String?,
    );
  }
}

/// 活用規則
class FormationRule {
  const FormationRule({
    required this.condition,
    required this.form,
    required this.example,
  });

  final String condition;
  final String form;
  final String example;

  factory FormationRule.fromJson(Map<String, dynamic> json) {
    return FormationRule(
      condition: json['condition'] as String? ?? '',
      form: json['form'] as String? ?? '',
      example: json['example'] as String? ?? '',
    );
  }
}

/// 用法・用例
class UsageCase {
  const UsageCase({
    required this.title,
    required this.description,
    this.examples = const [],
  });

  final String title;
  final String description;
  final List<GrammarExample> examples;

  factory UsageCase.fromJson(Map<String, dynamic> json) {
    final examplesJson = json['examples'] as List<dynamic>? ?? const [];
    return UsageCase(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      examples: examplesJson
          .whereType<Map<String, dynamic>>()
          .map(GrammarExample.fromJson)
          .toList(),
    );
  }
}

/// 例文
class GrammarExample {
  const GrammarExample({
    required this.korean,
    required this.japanese,
  });

  final String korean;
  final String japanese;

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      korean: json['korean'] as String? ?? '',
      japanese: json['japanese'] as String? ?? '',
    );
  }
}

/// 文法比較
class GrammarComparison {
  const GrammarComparison({
    required this.title,
    required this.description,
    this.examples = const [],
  });

  final String title;
  final String description;
  final List<ComparisonExample> examples;

  factory GrammarComparison.fromJson(Map<String, dynamic> json) {
    final examplesJson = json['examples'] as List<dynamic>? ?? const [];
    return GrammarComparison(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      examples: examplesJson
          .whereType<Map<String, dynamic>>()
          .map(ComparisonExample.fromJson)
          .toList(),
    );
  }
}

/// 比較例
class ComparisonExample {
  const ComparisonExample({
    required this.grammarA,
    required this.sentenceA,
    required this.meaningA,
    required this.grammarB,
    required this.sentenceB,
    required this.meaningB,
  });

  final String grammarA;
  final String sentenceA;
  final String meaningA;
  final String grammarB;
  final String sentenceB;
  final String meaningB;

  factory ComparisonExample.fromJson(Map<String, dynamic> json) {
    return ComparisonExample(
      grammarA: json['grammarA'] as String? ?? '',
      sentenceA: json['sentenceA'] as String? ?? '',
      meaningA: json['meaningA'] as String? ?? '',
      grammarB: json['grammarB'] as String? ?? '',
      sentenceB: json['sentenceB'] as String? ?? '',
      meaningB: json['meaningB'] as String? ?? '',
    );
  }
}

/// 文法メタデータ
class GrammarMetadata {
  const GrammarMetadata({
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final String version;

  factory GrammarMetadata.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json['createdAt'] as String?;
    final updatedAtStr = json['updatedAt'] as String?;

    return GrammarMetadata(
      createdAt:
          DateTime.tryParse(createdAtStr ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(updatedAtStr ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      version: json['version'] as String? ?? '1.0.0',
    );
  }
}
