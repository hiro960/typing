// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Word _$WordFromJson(Map<String, dynamic> json) => _Word(
  id: json['id'] as String,
  userId: json['userId'] as String,
  word: json['word'] as String,
  meaning: json['meaning'] as String,
  example: json['example'] as String?,
  status: $enumDecode(
    _$WordStatusEnumMap,
    json['status'],
    unknownValue: WordStatus.REVIEWING,
  ),
  category: $enumDecode(
    _$WordCategoryEnumMap,
    json['category'],
    unknownValue: WordCategory.WORDS,
  ),
  lastReviewedAt: json['lastReviewedAt'] == null
      ? null
      : DateTime.parse(json['lastReviewedAt'] as String),
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$WordToJson(_Word instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'word': instance.word,
  'meaning': instance.meaning,
  'example': instance.example,
  'status': _$WordStatusEnumMap[instance.status]!,
  'category': _$WordCategoryEnumMap[instance.category]!,
  'lastReviewedAt': instance.lastReviewedAt?.toIso8601String(),
  'reviewCount': instance.reviewCount,
  'successRate': instance.successRate,
  'tags': instance.tags,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$WordStatusEnumMap = {
  WordStatus.MASTERED: 'MASTERED',
  WordStatus.REVIEWING: 'REVIEWING',
  WordStatus.NEEDS_REVIEW: 'NEEDS_REVIEW',
};

const _$WordCategoryEnumMap = {
  WordCategory.WORDS: 'WORDS',
  WordCategory.SENTENCES: 'SENTENCES',
};
