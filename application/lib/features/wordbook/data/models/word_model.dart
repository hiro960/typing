// ignore_for_file: invalid_annotation_target, non_abstract_class_inherits_abstract_member

import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
abstract class Word with _$Word {
  const factory Word({
    required String id,
    required String userId,
    required String word,
    required String meaning,
    String? example,
    @JsonKey(unknownEnumValue: WordStatus.REVIEWING)
    required WordStatus status,
    @JsonKey(unknownEnumValue: WordCategory.WORDS)
    required WordCategory category,
    DateTime? lastReviewedAt,
    @Default(0) int reviewCount,
    @Default(0.0) double successRate,
    @Default(<String>[]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}

enum WordStatus {
  MASTERED,
  REVIEWING,
  NEEDS_REVIEW,
}

enum WordCategory {
  WORDS,
  SENTENCES,
}

extension WordStatusLabel on WordStatus {
  String get label {
    switch (this) {
      case WordStatus.MASTERED:
        return '覚えた';
      case WordStatus.REVIEWING:
        return '復習中';
      case WordStatus.NEEDS_REVIEW:
        return '要確認';
    }
  }
}

extension WordCategoryLabel on WordCategory {
  String get label {
    switch (this) {
      case WordCategory.WORDS:
        return '単語';
      case WordCategory.SENTENCES:
        return '文章';
    }
  }
}
