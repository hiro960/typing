import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/translation_model.dart';
import '../../data/services/deepl_translation_service.dart';

part 'translation_providers.g.dart';

/// DeepL翻訳サービスプロバイダー
@riverpod
DeepLTranslationService deeplTranslationService(Ref ref) {
  return DeepLTranslationService();
}

/// 翻訳機能のNotifierプロバイダー
@Riverpod(keepAlive: true)
class TranslationController extends _$TranslationController {
  static const int _maxHistoryCount = 5;

  DeepLTranslationService get _service =>
      ref.read(deeplTranslationServiceProvider);

  @override
  TranslationState build() => const TranslationState();

  /// 入力テキストを更新
  void updateInputText(String text) {
    state = state.copyWith(
      inputText: text,
      errorMessage: null,
    );
  }

  /// 翻訳方向を切り替え
  void toggleDirection() {
    final newDirection = state.direction == TranslationDirection.jaToKo
        ? TranslationDirection.koToJa
        : TranslationDirection.jaToKo;

    state = state.copyWith(
      direction: newDirection,
      translatedText: null,
      errorMessage: null,
    );
  }

  /// 翻訳を実行
  Future<void> translate() async {
    final text = state.inputText.trim();
    if (text.isEmpty) {
      state = state.copyWith(errorMessage: 'テキストを入力してください');
      return;
    }

    state = state.copyWith(
      isTranslating: true,
      errorMessage: null,
    );

    try {
      final translatedText = state.direction == TranslationDirection.jaToKo
          ? await _service.translateJaToKo(text)
          : await _service.translateKoToJa(text);

      // 翻訳履歴に追加
      final result = TranslationResult(
        sourceText: text,
        translatedText: translatedText,
        direction: state.direction,
        createdAt: DateTime.now(),
      );

      final updatedHistory = [result, ...state.history];
      // 直近5件のみ保持
      final trimmedHistory = updatedHistory.length > _maxHistoryCount
          ? updatedHistory.sublist(0, _maxHistoryCount)
          : updatedHistory;

      state = state.copyWith(
        translatedText: translatedText,
        isTranslating: false,
        history: trimmedHistory,
      );
    } catch (e) {
      state = state.copyWith(
        isTranslating: false,
        errorMessage: '翻訳に失敗しました。もう一度お試しください。',
      );
    }
  }

  /// 入力をクリア
  void clearInput() {
    state = state.copyWith(
      inputText: '',
      translatedText: null,
      errorMessage: null,
    );
  }

  /// 履歴から復元
  void restoreFromHistory(TranslationResult result) {
    state = state.copyWith(
      inputText: result.sourceText,
      translatedText: result.translatedText,
      direction: result.direction,
      errorMessage: null,
    );
  }
}
