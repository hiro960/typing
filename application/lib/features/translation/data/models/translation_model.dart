import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_model.freezed.dart';

/// 翻訳方向
enum TranslationDirection {
  jaToKo, // 日本語 → 韓国語
  koToJa, // 韓国語 → 日本語
}

/// 翻訳結果モデル
@freezed
abstract class TranslationResult with _$TranslationResult {
  const factory TranslationResult({
    required String sourceText,
    required String translatedText,
    required TranslationDirection direction,
    required DateTime createdAt,
  }) = _TranslationResult;
}

/// 翻訳状態モデル
@freezed
abstract class TranslationState with _$TranslationState {
  const factory TranslationState({
    @Default('') String inputText,
    String? translatedText,
    @Default(TranslationDirection.jaToKo) TranslationDirection direction,
    @Default(false) bool isTranslating,
    String? errorMessage,
    @Default([]) List<TranslationResult> history,
  }) = _TranslationState;
}
