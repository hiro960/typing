import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../ui/app_theme.dart';

part 'grammar_models.g.dart';

/// 文法カテゴリ（11カテゴリ）
@JsonEnum(alwaysCreate: true)
enum GrammarCategory {
  @JsonValue('orthography')
  orthography, // 表記・発音
  @JsonValue('substantive')
  substantive, // 体言
  @JsonValue('particle')
  particle, // 助詞
  @JsonValue('conjugation')
  conjugation, // 用言と活用
  @JsonValue('sentence_ending')
  sentenceEnding, // 終止形と待遇法
  @JsonValue('connective')
  connective, // 接続形
  @JsonValue('adnominal')
  adnominal, // 連体形
  @JsonValue('tense_aspect')
  tenseAspect, // 時制
  @JsonValue('expression')
  expression, // さまざまな表現
  @JsonValue('quotation')
  quotation, // 直接話法と間接話法
  @JsonValue('word_formation')
  wordFormation, // 単語の作り
}

extension GrammarCategoryX on GrammarCategory {
  String get label {
    switch (this) {
      case GrammarCategory.orthography:
        return '表記・発音';
      case GrammarCategory.substantive:
        return '体言';
      case GrammarCategory.particle:
        return '助詞';
      case GrammarCategory.conjugation:
        return '用言と活用';
      case GrammarCategory.sentenceEnding:
        return '終止形と待遇法';
      case GrammarCategory.connective:
        return '接続形';
      case GrammarCategory.adnominal:
        return '連体形';
      case GrammarCategory.tenseAspect:
        return '時制';
      case GrammarCategory.expression:
        return 'さまざまな表現';
      case GrammarCategory.quotation:
        return '直接話法と間接話法';
      case GrammarCategory.wordFormation:
        return '単語の作り';
    }
  }

  String get description {
    switch (this) {
      case GrammarCategory.orthography:
        return 'ハングルの構造と発音の変化';
      case GrammarCategory.substantive:
        return '代名詞・数詞・疑問詞・依存名詞など';
      case GrammarCategory.particle:
        return '名詞に付いて文法的な関係を示す';
      case GrammarCategory.conjugation:
        return '用言の品詞と活用パターン';
      case GrammarCategory.sentenceEnding:
        return '文末の終止形と待遇法';
      case GrammarCategory.connective:
        return '文と文をつなぐ接続表現';
      case GrammarCategory.adnominal:
        return '名詞を修飾する連体形';
      case GrammarCategory.tenseAspect:
        return '時制・否定・受身・使役など';
      case GrammarCategory.expression:
        return 'よく使われる文法的な慣用表現';
      case GrammarCategory.quotation:
        return '直接引用・間接引用の表現';
      case GrammarCategory.wordFormation:
        return '副詞形・体言形・接辞による語形成';
    }
  }

  IconData get icon {
    switch (this) {
      case GrammarCategory.orthography:
        return Icons.text_fields; // 表記・発音
      case GrammarCategory.substantive:
        return Icons.category; // 体言
      case GrammarCategory.particle:
        return Icons.link; // 助詞
      case GrammarCategory.conjugation:
        return Icons.shuffle; // 用言と活用
      case GrammarCategory.sentenceEnding:
        return Icons.format_quote; // 終止形と待遇法
      case GrammarCategory.connective:
        return Icons.swap_horiz; // 接続形
      case GrammarCategory.adnominal:
        return Icons.short_text; // 連体形
      case GrammarCategory.tenseAspect:
        return Icons.schedule; // 時制
      case GrammarCategory.expression:
        return Icons.chat_bubble_outline; // さまざまな表現
      case GrammarCategory.quotation:
        return Icons.format_quote_rounded; // 直接話法と間接話法
      case GrammarCategory.wordFormation:
        return Icons.build; // 単語の作り
    }
  }

  String get key => name;

  /// JSONファイルで使用されるキー（スネークケース）
  String get jsonKey {
    switch (this) {
      case GrammarCategory.orthography:
        return 'orthography';
      case GrammarCategory.substantive:
        return 'substantive';
      case GrammarCategory.particle:
        return 'particle';
      case GrammarCategory.conjugation:
        return 'conjugation';
      case GrammarCategory.sentenceEnding:
        return 'sentence_ending';
      case GrammarCategory.connective:
        return 'connective';
      case GrammarCategory.adnominal:
        return 'adnominal';
      case GrammarCategory.tenseAspect:
        return 'tense_aspect';
      case GrammarCategory.expression:
        return 'expression';
      case GrammarCategory.quotation:
        return 'quotation';
      case GrammarCategory.wordFormation:
        return 'word_formation';
    }
  }

  static GrammarCategory? fromKey(String value) {
    for (final category in GrammarCategory.values) {
      if (category.name == value) {
        return category;
      }
    }
    return null;
  }
}

/// 文法レベル
@JsonEnum(alwaysCreate: true)
enum GrammarLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
}

extension GrammarLevelX on GrammarLevel {
  String get label {
    switch (this) {
      case GrammarLevel.beginner:
        return '初級';
      case GrammarLevel.intermediate:
        return '中級';
      case GrammarLevel.advanced:
        return '上級';
    }
  }

  Color get color {
    switch (this) {
      case GrammarLevel.beginner:
        return AppColors.secondary;
      case GrammarLevel.intermediate:
        return AppColors.primaryBright;
      case GrammarLevel.advanced:
        return AppColors.accentEnd;
    }
  }

  String get key => name;

  static GrammarLevel? fromKey(String value) {
    for (final level in GrammarLevel.values) {
      if (level.name == value) {
        return level;
      }
    }
    return null;
  }
}

/// 練習問題の種類
@JsonEnum(alwaysCreate: true)
enum ExerciseType {
  @JsonValue('fill_blank')
  fillBlank,
  @JsonValue('choice')
  choice,
  @JsonValue('typing')
  typing,
  @JsonValue('translation')
  translation,
  @JsonValue('matching')
  matching,
}

extension ExerciseTypeX on ExerciseType {
  String get label {
    switch (this) {
      case ExerciseType.fillBlank:
        return '空欄補充';
      case ExerciseType.choice:
        return '選択問題';
      case ExerciseType.typing:
        return 'タイピング';
      case ExerciseType.translation:
        return '翻訳問題';
      case ExerciseType.matching:
        return 'マッチング';
    }
  }

  IconData get icon {
    switch (this) {
      case ExerciseType.fillBlank:
        return Icons.edit_note;
      case ExerciseType.choice:
        return Icons.check_circle_outline;
      case ExerciseType.typing:
        return Icons.keyboard;
      case ExerciseType.translation:
        return Icons.translate;
      case ExerciseType.matching:
        return Icons.compare_arrows;
    }
  }

  static ExerciseType? fromKey(String value) {
    switch (value) {
      case 'fill_blank':
        return ExerciseType.fillBlank;
      case 'choice':
        return ExerciseType.choice;
      case 'typing':
        return ExerciseType.typing;
      case 'translation':
        return ExerciseType.translation;
      case 'matching':
        return ExerciseType.matching;
      default:
        return null;
    }
  }
}
