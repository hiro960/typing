import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hanja_models.g.dart';

/// 漢字のレベル
@JsonEnum(alwaysCreate: true)
enum HanjaLevel {
  @JsonValue('basic')
  basic,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
}

extension HanjaLevelX on HanjaLevel {
  String get label {
    switch (this) {
      case HanjaLevel.basic:
        return '基礎';
      case HanjaLevel.intermediate:
        return '中級';
      case HanjaLevel.advanced:
        return '上級';
    }
  }

  Color get color {
    switch (this) {
      case HanjaLevel.basic:
        return Colors.green;
      case HanjaLevel.intermediate:
        return Colors.orange;
      case HanjaLevel.advanced:
        return Colors.red;
    }
  }
}

/// 頻度
@JsonEnum(alwaysCreate: true)
enum HanjaFrequency {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low,
}

extension HanjaFrequencyX on HanjaFrequency {
  String get label {
    switch (this) {
      case HanjaFrequency.high:
        return '高頻度';
      case HanjaFrequency.medium:
        return '中頻度';
      case HanjaFrequency.low:
        return '低頻度';
    }
  }
}

/// 漢字語のカテゴリ
@JsonEnum(alwaysCreate: true)
enum HanjaWordCategory {
  @JsonValue('daily')
  daily,
  @JsonValue('education')
  education,
  @JsonValue('society')
  society,
  @JsonValue('nature')
  nature,
  @JsonValue('culture')
  culture,
}

extension HanjaWordCategoryX on HanjaWordCategory {
  String get label {
    switch (this) {
      case HanjaWordCategory.daily:
        return '日常生活';
      case HanjaWordCategory.education:
        return '教育・学問';
      case HanjaWordCategory.society:
        return '社会・政治・経済';
      case HanjaWordCategory.nature:
        return '自然・科学・医療';
      case HanjaWordCategory.culture:
        return '文化・芸術';
    }
  }

  IconData get icon {
    switch (this) {
      case HanjaWordCategory.daily:
        return Icons.home;
      case HanjaWordCategory.education:
        return Icons.school;
      case HanjaWordCategory.society:
        return Icons.account_balance;
      case HanjaWordCategory.nature:
        return Icons.eco;
      case HanjaWordCategory.culture:
        return Icons.palette;
    }
  }
}
