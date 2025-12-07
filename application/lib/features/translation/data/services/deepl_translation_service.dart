import 'package:deepl_dart/deepl_dart.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/logger.dart';

/// DeepL翻訳サービス
class DeepLTranslationService {
  DeepLTranslationService() : _deepl = DeepL(authKey: EnvConfig.deeplApiKey);

  final DeepL _deepl;

  /// 日本語から韓国語へ翻訳
  Future<String> translateJaToKo(String text) async {
    return _translate(text, targetLang: 'KO');
  }

  /// 韓国語から日本語へ翻訳
  Future<String> translateKoToJa(String text) async {
    return _translate(text, targetLang: 'JA');
  }

  Future<String> _translate(String text, {required String targetLang}) async {
    if (text.trim().isEmpty) {
      throw ArgumentError('翻訳するテキストが空です');
    }

    try {
      final result = await _deepl.translate.translateText(text, targetLang);
      AppLogger.debug('Translation result: ${result.text}', tag: 'DeepL');
      return result.text;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Translation failed',
        tag: 'DeepL',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
