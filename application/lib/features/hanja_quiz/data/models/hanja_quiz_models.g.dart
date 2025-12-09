// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hanja_quiz_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasteredHanjaWord _$MasteredHanjaWordFromJson(Map<String, dynamic> json) =>
    MasteredHanjaWord(
      wordId: json['wordId'] as String,
      masteredAt: DateTime.parse(json['masteredAt'] as String),
    );

Map<String, dynamic> _$MasteredHanjaWordToJson(MasteredHanjaWord instance) =>
    <String, dynamic>{
      'wordId': instance.wordId,
      'masteredAt': instance.masteredAt.toIso8601String(),
    };
