import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_favorite.freezed.dart';
part 'grammar_favorite.g.dart';

@freezed
abstract class GrammarFavorite with _$GrammarFavorite {
  const factory GrammarFavorite({
    required String grammarId,
    required DateTime addedAt,
    String? note,
  }) = _GrammarFavorite;

  factory GrammarFavorite.fromJson(Map<String, dynamic> json) =>
      _$GrammarFavoriteFromJson(json);
}
