// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrammarFavorite _$GrammarFavoriteFromJson(Map<String, dynamic> json) =>
    _GrammarFavorite(
      grammarId: json['grammarId'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$GrammarFavoriteToJson(_GrammarFavorite instance) =>
    <String, dynamic>{
      'grammarId': instance.grammarId,
      'addedAt': instance.addedAt.toIso8601String(),
      'note': instance.note,
    };
