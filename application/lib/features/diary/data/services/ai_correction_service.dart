import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/utils/logger.dart';

class AiCorrectionService {
  final Dio _dio;

  AiCorrectionService(this._dio);

  Future<String> correctText(String text) async {
    try {
      final response = await _dio.post(
        'https://api.openai.com/v1/responses',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${EnvConfig.openAiApiKey}',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'prompt': {
            'id': EnvConfig.openAiPromptId,
            'version': EnvConfig.openAiPromptVersion,
          },
          'input': text,
        },
      );

      AppLogger.debug('AI Response: ${response.data}');

      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('output')) {
        final outputs = response.data['output'] as List;
        final messageOutput = outputs.firstWhere(
          (element) => element['type'] == 'message',
          orElse: () => null,
        );

        if (messageOutput != null && messageOutput['content'] is List) {
          final contentList = messageOutput['content'] as List;
          final textContent = contentList.firstWhere(
            (element) => element['type'] == 'output_text',
            orElse: () => null,
          );
          if (textContent != null) {
            return textContent['text'] as String;
          }
        }
      }
      
      // フォールバック: 構造が想定と異なる場合
      return response.data.toString();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to correct text',
        tag: 'AiCorrectionService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
