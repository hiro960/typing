import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/data/services/api_client_service.dart';
import '../models/typing_models.dart';

class TypingRepository {
  TypingRepository({
    required ApiClientService apiClient,
    SharedPreferences? preferences,
  }) : _apiClient = apiClient,
       _prefs = preferences;

  static const _queueKey = 'pending_lesson_completions';

  final ApiClientService _apiClient;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> submitCompletion({
    required String lessonId,
    required int wpm,
    required double accuracy,
    required int timeSpentMs,
    String device = 'ios',
    String mode = 'standard',
    Map<String, int> mistakeCharacters = const <String, int>{},
  }) async {
    try {
      await _apiClient.dio.post(
        ApiConstants.lessonComplete,
        data: {
          'lessonId': lessonId,
          'wpm': wpm,
          'accuracy': accuracy,
          'timeSpent': timeSpentMs,
          'device': device,
          'mode': mode,
          if (mistakeCharacters.isNotEmpty) 'mistakeCharacters': mistakeCharacters,
        },
      );
    } on DioException catch (error) {
      throw ApiClientService.handleDioException(error);
    }
  }

  Future<List<PendingCompletion>> loadPendingCompletions() async {
    final prefs = await _preferences;
    final raw = prefs.getString(_queueKey);
    if (raw == null) {
      return [];
    }
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(PendingCompletion.fromJson)
          .toList();
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to parse pending completions',
        tag: 'TypingRepository',
        error: error,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  Future<void> savePendingCompletions(
    List<PendingCompletion> completions,
  ) async {
    final prefs = await _preferences;
    final payload = completions.map((c) => c.toJson()).toList();
    await prefs.setString(_queueKey, jsonEncode(payload));
  }

  Future<void> enqueueCompletion(PendingCompletion completion) async {
    final queue = await loadPendingCompletions();
    queue.add(completion);
    await savePendingCompletions(queue);
  }

  Future<void> processQueue() async {
    final queue = await loadPendingCompletions();
    if (queue.isEmpty) {
      return;
    }
    final remaining = <PendingCompletion>[];
    for (final completion in queue) {
      try {
        await submitCompletion(
          lessonId: completion.lessonId,
          wpm: completion.wpm,
          accuracy: completion.accuracy,
          timeSpentMs: completion.timeSpentMs,
          device: completion.device,
          mode: completion.mode,
          mistakeCharacters: completion.mistakeCharacters,
        );
      } catch (error, stackTrace) {
        AppLogger.error(
          'Failed to submit queued completion',
          tag: 'TypingRepository',
          error: error,
          stackTrace: stackTrace,
        );
        remaining.add(completion);
      }
    }
    await savePendingCompletions(remaining);
  }

  PendingCompletion buildPendingCompletion({
    required String lessonId,
    required int wpm,
    required double accuracy,
    required int timeSpentMs,
    String device = 'ios',
    String mode = 'standard',
    Map<String, int> mistakeCharacters = const <String, int>{},
  }) {
    final id = '${DateTime.now().microsecondsSinceEpoch}_$lessonId';
    return PendingCompletion(
      id: id,
      lessonId: lessonId,
      wpm: wpm,
      accuracy: accuracy,
      timeSpentMs: timeSpentMs,
      device: device,
      mode: mode,
      createdAt: DateTime.now(),
      mistakeCharacters: mistakeCharacters,
    );
  }
}
