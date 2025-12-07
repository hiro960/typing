import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../ui/app_theme.dart';

part 'grammar_models.g.dart';

/// 文法カテゴリ
@JsonEnum(alwaysCreate: true)
enum GrammarCategory {
  @JsonValue('particle')
  particle,
  @JsonValue('ending')
  ending,
  @JsonValue('connective')
  connective,
  @JsonValue('honorific')
  honorific,
  @JsonValue('tense')
  tense,
  @JsonValue('expression')
  expression,
  @JsonValue('numeral')
  numeral,
  @JsonValue('interrogative')
  interrogative,
  @JsonValue('pronoun')
  pronoun,
  @JsonValue('irregular')
  irregular,
  @JsonValue('voice')
  voice,
  @JsonValue('quotation')
  quotation,
  @JsonValue('negation')
  negation,
  @JsonValue('adverb')
  adverb,
  @JsonValue('interjection')
  interjection,
}

extension GrammarCategoryX on GrammarCategory {
  String get label {
    switch (this) {
      case GrammarCategory.particle:
        return '助詞';
      case GrammarCategory.ending:
        return '語尾';
      case GrammarCategory.connective:
        return '接続表現';
      case GrammarCategory.honorific:
        return '敬語表現';
      case GrammarCategory.tense:
        return '時制・相';
      case GrammarCategory.expression:
        return '慣用表現';
      case GrammarCategory.numeral:
        return '数詞・助数詞';
      case GrammarCategory.interrogative:
        return '疑問詞';
      case GrammarCategory.pronoun:
        return '代名詞・指示詞';
      case GrammarCategory.irregular:
        return '不規則活用';
      case GrammarCategory.voice:
        return '態（受身・使役）';
      case GrammarCategory.quotation:
        return '引用表現';
      case GrammarCategory.negation:
        return '否定表現';
      case GrammarCategory.adverb:
        return '副詞';
      case GrammarCategory.interjection:
        return '感嘆詞・間投詞';
    }
  }

  String get description {
    switch (this) {
      case GrammarCategory.particle:
        return '名詞に付いて文法的な関係を示す';
      case GrammarCategory.ending:
        return '動詞・形容詞の活用語尾';
      case GrammarCategory.connective:
        return '文と文をつなぐ表現';
      case GrammarCategory.honorific:
        return '尊敬語・謙譲語の表現';
      case GrammarCategory.tense:
        return '過去・現在・未来・進行などの表現';
      case GrammarCategory.expression:
        return 'よく使われる文法的な慣用表現';
      case GrammarCategory.numeral:
        return '固有数詞・漢数詞・助数詞';
      case GrammarCategory.interrogative:
        return '疑問代名詞・疑問副詞';
      case GrammarCategory.pronoun:
        return '人称代名詞・指示代名詞';
      case GrammarCategory.irregular:
        return '不規則に変化する用言の活用パターン';
      case GrammarCategory.voice:
        return '受動態・使役態の表現';
      case GrammarCategory.quotation:
        return '直接引用・間接引用の表現';
      case GrammarCategory.negation:
        return '否定を表す文法表現';
      case GrammarCategory.adverb:
        return '動詞・形容詞を修飾する語';
      case GrammarCategory.interjection:
        return '感情や呼びかけを表す語';
    }
  }

  IconData get icon {
    switch (this) {
      case GrammarCategory.particle:
        return Icons.link;
      case GrammarCategory.ending:
        return Icons.format_quote;
      case GrammarCategory.connective:
        return Icons.swap_horiz;
      case GrammarCategory.honorific:
        return Icons.person_outline;
      case GrammarCategory.tense:
        return Icons.schedule;
      case GrammarCategory.expression:
        return Icons.chat_bubble_outline;
      case GrammarCategory.numeral:
        return Icons.pin;
      case GrammarCategory.interrogative:
        return Icons.help_outline;
      case GrammarCategory.pronoun:
        return Icons.person_pin;
      case GrammarCategory.irregular:
        return Icons.shuffle;
      case GrammarCategory.voice:
        return Icons.record_voice_over;
      case GrammarCategory.quotation:
        return Icons.format_quote_rounded;
      case GrammarCategory.negation:
        return Icons.block;
      case GrammarCategory.adverb:
        return Icons.speed;
      case GrammarCategory.interjection:
        return Icons.campaign;
    }
  }

  String get key => name;

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
