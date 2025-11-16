import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../data/models/word_model.dart';
import '../../../auth/data/services/api_client_service.dart';

class WordbookRepository {
  WordbookRepository({required ApiClientService apiClient}) : _apiClient = apiClient;

  final ApiClientService _apiClient;

  Future<List<Word>> fetchWords() async {
    try {
      final response = await _apiClient.dio.get('/api/wordbook');
      final data = response.data;
      final words = (data['data'] as List<dynamic>? ?? [])
          .map((item) => Word.fromJson(item as Map<String, dynamic>))
          .toList();
      return words;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch wordbook entries',
        tag: 'WordbookRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<Word> createWord({
    required String word,
    required String meaning,
    String? example,
    required WordCategory category,
    required WordStatus status,
    List<String> tags = const [],
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/wordbook',
        data: {
          'word': word,
          'meaning': meaning,
          if (example != null && example.isNotEmpty) 'example': example,
          'category': category.name,
          'status': status.name,
          'tags': tags,
        },
      );
      return Word.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to create wordbook entry',
        tag: 'WordbookRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<Word> updateWord({
    required String id,
    String? word,
    String? meaning,
    String? example,
    WordCategory? category,
    WordStatus? status,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/wordbook/$id',
        data: {
          if (word != null) 'word': word,
          if (meaning != null) 'meaning': meaning,
          if (example != null) 'example': example,
          if (category != null) 'category': category.name,
          if (status != null) 'status': status.name,
          if (tags != null) 'tags': tags,
        },
      );
      return Word.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to update wordbook entry',
        tag: 'WordbookRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<void> deleteWord(String id) async {
    try {
      await _apiClient.dio.delete('/api/wordbook/$id');
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Failed to delete wordbook entry',
        tag: 'WordbookRepository',
        error: error,
        stackTrace: stackTrace,
      );
      throw ApiClientService.handleDioException(error);
    }
  }
}
