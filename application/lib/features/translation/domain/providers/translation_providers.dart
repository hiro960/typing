import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/translation_model.dart';
import '../../data/services/deepl_translation_service.dart';

part 'translation_providers.g.dart';

/// DeepL翻訳サービスプロバイダー
@riverpod
DeepLTranslationService deeplTranslationService(Ref ref) {
  return DeepLTranslationService();
}

/// 日記投稿の翻訳状態
class DiaryTranslationState {
  const DiaryTranslationState({
    this.translations = const {},
    this.loadingPostIds = const {},
  });

  final Map<String, String> translations; // postId -> translatedText
  final Set<String> loadingPostIds;

  DiaryTranslationState copyWith({
    Map<String, String>? translations,
    Set<String>? loadingPostIds,
  }) {
    return DiaryTranslationState(
      translations: translations ?? this.translations,
      loadingPostIds: loadingPostIds ?? this.loadingPostIds,
    );
  }
}

/// 日記投稿翻訳コントローラー（DeepL使用）
@Riverpod(keepAlive: true)
class DiaryTranslationController extends _$DiaryTranslationController {
  DeepLTranslationService get _service =>
      ref.read(deeplTranslationServiceProvider);

  @override
  DiaryTranslationState build() => const DiaryTranslationState();

  /// 投稿を翻訳
  Future<void> translatePost(String postId, String content) async {
    // 既に翻訳済みの場合はトグル（翻訳を非表示にする）
    if (state.translations.containsKey(postId)) {
      final newTranslations = Map<String, String>.from(state.translations);
      newTranslations.remove(postId);
      state = state.copyWith(translations: newTranslations);
      return;
    }

    // 翻訳中の場合はスキップ
    if (state.loadingPostIds.contains(postId)) return;

    // ローディング状態を設定
    final newLoadingIds = Set<String>.from(state.loadingPostIds)..add(postId);
    state = state.copyWith(loadingPostIds: newLoadingIds);

    try {
      final translatedText = await _service.translateKoToJa(content);

      final newTranslations = Map<String, String>.from(state.translations);
      newTranslations[postId] = translatedText;

      final updatedLoadingIds = Set<String>.from(state.loadingPostIds)
        ..remove(postId);
      state = state.copyWith(
        translations: newTranslations,
        loadingPostIds: updatedLoadingIds,
      );
    } catch (e) {
      final updatedLoadingIds = Set<String>.from(state.loadingPostIds)
        ..remove(postId);
      state = state.copyWith(loadingPostIds: updatedLoadingIds);
      rethrow;
    }
  }

  /// 翻訳をクリア
  void clearTranslation(String postId) {
    if (!state.translations.containsKey(postId)) return;

    final newTranslations = Map<String, String>.from(state.translations);
    newTranslations.remove(postId);
    state = state.copyWith(translations: newTranslations);
  }

  /// 全ての翻訳をクリア
  void clearAllTranslations() {
    state = state.copyWith(translations: {});
  }
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
