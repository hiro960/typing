import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../auth/domain/providers/auth_providers.dart';
import '../../data/models/audio_settings.dart';
import '../../data/models/listening_settings.dart';
import '../../data/models/pending_operation.dart';
import '../../data/models/word_model.dart';
import '../../data/repositories/wordbook_repository.dart';

part 'wordbook_providers.g.dart';

const _uuid = Uuid();

/// 単語帳の表示モード
enum WordbookViewMode {
  card,
  list,
}

@riverpod
WordbookRepository wordbookRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return WordbookRepository(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
class WordbookNotifier extends _$WordbookNotifier {
  static const _cacheKey = 'wordbook_cache_v1';

  @override
  FutureOr<List<Word>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    final cachedWords = cached != null ? _parseWords(cached) : <Word>[];

    unawaited(_syncFromServer(cachedWords));

    return cachedWords;
  }

  Future<void> refresh() async {
    final current = state.value ?? [];
    await _syncFromServer(current);
  }

  Future<void> _syncFromServer(List<Word> cachedWords) async {
    try {
      final repository = ref.read(wordbookRepositoryProvider);
      final serverWords = await repository.fetchWords();
      final offlineQueue = await ref.read(wordbookOfflineQueueProvider.future);

      final merged = _mergeWithOfflineData(
        serverWords: serverWords,
        cachedWords: cachedWords,
        offlineQueue: offlineQueue,
      );

      if (!ref.mounted) return;
      state = AsyncData(merged);
      await _saveToCache(merged);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to sync wordbook entries',
        tag: 'WordbookNotifier',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  List<Word> _parseWords(String json) {
    final data = jsonDecode(json) as List<dynamic>;
    return data.map((item) => Word.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> _saveToCache(List<Word> words) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(words.map((word) => word.toJson()).toList());
    await prefs.setString(_cacheKey, encoded);
  }

  List<Word> _mergeWithOfflineData({
    required List<Word> serverWords,
    required List<Word> cachedWords,
    required List<PendingOperation> offlineQueue,
  }) {
    var merged = [...serverWords];

    final createOps = offlineQueue.where((op) => op.operationType == 'CREATE');
    final tempIds = createOps.map((op) => op.tempId).whereType<String>().toSet();
    final pendingTempWords = cachedWords
        .where((word) => tempIds.contains(word.id))
        .toList();
    merged.addAll(pendingTempWords);

    final updateOps = offlineQueue.where((op) => op.operationType == 'UPDATE');
    for (final op in updateOps) {
      final wordId = op.wordId;
      if (wordId == null) continue;
      final localWord = _findWord(cachedWords, wordId);
      if (localWord == null) continue;
      final index = merged.indexWhere((word) => word.id == wordId);
      if (index != -1) {
        merged[index] = localWord;
      }
    }

    final deleteOps = offlineQueue.where((op) => op.operationType == 'DELETE');
    final deleteIds = deleteOps.map((op) => op.wordId).whereType<String>().toSet();
    merged = merged.where((word) => !deleteIds.contains(word.id)).toList();

    return merged;
  }

  Word? _findWord(List<Word> words, String id) {
    for (final word in words) {
      if (word.id == id) {
        return word;
      }
    }
    return null;
  }

  Future<void> addWord({
    required String word,
    required String meaning,
    String? example,
    required WordCategory category,
    required WordStatus status,
    List<String> tags = const [],
  }) async {
    try {
      final repository = ref.read(wordbookRepositoryProvider);
      final created = await repository.createWord(
        word: word,
        meaning: meaning,
        example: example,
        category: category,
        status: status,
        tags: tags,
      );

      final current = state.value ?? [];
      final updated = [created, ...current];
      state = AsyncData(updated);
      await _saveToCache(updated);
    } catch (error) {
      AppLogger.info(
        'Failed to create word online, saving to offline queue',
        tag: 'WordbookNotifier',
      );
      await _saveToOfflineQueue(
        word: word,
        meaning: meaning,
        example: example,
        category: category,
        status: status,
        tags: tags,
      );
    }
  }

  Future<void> _saveToOfflineQueue({
    required String word,
    required String meaning,
    String? example,
    required WordCategory category,
    required WordStatus status,
    List<String> tags = const [],
  }) async {
    final authState = ref.read(authStateProvider);
    final userId = authState.user?.id;
    if (userId == null) {
      AppLogger.warning(
        'Cannot create word offline without authenticated user',
        tag: 'WordbookNotifier',
      );
      return;
    }

    final tempId = 'temp_${_uuid.v4()}';
    final currentWords = state.value ?? [];

    final tempWord = Word(
      id: tempId,
      userId: userId,
      word: word,
      meaning: meaning,
      example: example,
      category: category,
      status: status,
      tags: tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final optimistic = [tempWord, ...currentWords];
    state = AsyncData(optimistic);
    await _saveToCache(optimistic);

    final operation = PendingOperation(
      id: _uuid.v4(),
      operationType: 'CREATE',
      tempId: tempId,
      wordId: null,
      data: {
        'word': word,
        'meaning': meaning,
        if (example != null) 'example': example,
        'category': category.name,
        'status': status.name,
        'tags': tags,
      },
      createdAt: DateTime.now(),
    );

    await ref.read(wordbookOfflineQueueProvider.notifier).addOperation(operation);
    AppLogger.info(
      'Saved word to offline queue: $tempId',
      tag: 'WordbookNotifier',
    );
  }

  Future<void> updateWord(
    String id, {
    String? word,
    String? meaning,
    String? example,
    WordCategory? category,
    WordStatus? status,
    List<String>? tags,
  }) async {
    final currentWords = state.value ?? [];

    // Optimistic update
    final updatedWords = currentWords.map((entry) {
      if (entry.id != id) return entry;
      return entry.copyWith(
        word: word ?? entry.word,
        meaning: meaning ?? entry.meaning,
        example: example ?? entry.example,
        category: category ?? entry.category,
        status: status ?? entry.status,
        tags: tags ?? entry.tags,
        updatedAt: DateTime.now(),
      );
    }).toList();

    state = AsyncData(updatedWords);
    await _saveToCache(updatedWords);

    final changes = <String, dynamic>{};
    if (word != null) changes['word'] = word;
    if (meaning != null) changes['meaning'] = meaning;
    if (example != null) changes['example'] = example;
    if (category != null) changes['category'] = category.name;
    if (status != null) changes['status'] = status.name;
    if (tags != null) changes['tags'] = tags;

    if (changes.isEmpty) {
      return;
    }

    // Handle temp IDs (offline-created words)
    if (id.startsWith('temp_')) {
      await ref
          .read(wordbookOfflineQueueProvider.notifier)
          .mergeWithCreateOperation(id, changes);
      return;
    }

    // Try to update on server
    try {
      final repository = ref.read(wordbookRepositoryProvider);
      final updated = await repository.updateWord(
        id: id,
        word: word,
        meaning: meaning,
        example: example,
        category: category,
        status: status,
        tags: tags,
      );

      final mapped = currentWords.map((w) => w.id == id ? updated : w).toList();
      state = AsyncData(mapped);
      await _saveToCache(mapped);
    } catch (error) {
      AppLogger.info(
        'Failed to update word online, saving to offline queue',
        tag: 'WordbookNotifier',
      );
      final operation = PendingOperation(
        id: _uuid.v4(),
        operationType: 'UPDATE',
        wordId: id,
        tempId: null,
        data: changes,
        createdAt: DateTime.now(),
      );
      await ref.read(wordbookOfflineQueueProvider.notifier).addOperation(operation);
    }
  }

  Future<void> deleteWord(String id) async {
    final currentWords = state.value ?? [];

    // Optimistic delete
    final newWords = currentWords.where((word) => word.id != id).toList();
    state = AsyncData(newWords);
    await _saveToCache(newWords);

    // Handle temp IDs (offline-created words)
    if (id.startsWith('temp_')) {
      await ref
          .read(wordbookOfflineQueueProvider.notifier)
          .removeOperationsForTempId(id);
      return;
    }

    // Try to delete on server
    try {
      final repository = ref.read(wordbookRepositoryProvider);
      await repository.deleteWord(id);
    } catch (error) {
      AppLogger.info(
        'Failed to delete word online, saving to offline queue',
        tag: 'WordbookNotifier',
      );
      final operation = PendingOperation(
        id: _uuid.v4(),
        operationType: 'DELETE',
        wordId: id,
        tempId: null,
        data: const {},
        createdAt: DateTime.now(),
      );
      await ref.read(wordbookOfflineQueueProvider.notifier).addOperation(operation);
    }
  }

  Future<void> executeOperation(PendingOperation operation) async {
    switch (operation.operationType) {
      case 'CREATE':
        await _executeCreateOperation(operation);
        break;
      case 'UPDATE':
        await _executeUpdateOperation(operation);
        break;
      case 'DELETE':
        await _executeDeleteOperation(operation);
        break;
      default:
        AppLogger.warning('Unknown operation ${operation.operationType}');
    }
  }

  Future<void> _executeCreateOperation(PendingOperation operation) async {
    final repository = ref.read(wordbookRepositoryProvider);
    final response = await repository.createWord(
      word: operation.data['word'] as String,
      meaning: operation.data['meaning'] as String,
      example: operation.data['example'] as String?,
      category: WordCategory.values.firstWhere(
        (category) => category.name == operation.data['category'],
        orElse: () => WordCategory.WORDS,
      ),
      status: WordStatus.values.firstWhere(
        (status) => status.name == operation.data['status'],
        orElse: () => WordStatus.REVIEWING,
      ),
      tags: (operation.data['tags'] as List<dynamic>? ?? []).cast<String>(),
    );

    await _replaceTempIdWithRealId(
      tempId: operation.tempId!,
      realWord: response,
    );
  }

  Future<void> _executeUpdateOperation(PendingOperation operation) async {
    final repository = ref.read(wordbookRepositoryProvider);
    final response = await repository.updateWord(
      id: operation.wordId!,
      word: operation.data['word'] as String?,
      meaning: operation.data['meaning'] as String?,
      example: operation.data['example'] as String?,
      category: operation.data['category'] != null
          ? WordCategory.values.firstWhere(
              (category) => category.name == operation.data['category'],
            )
          : null,
      status: operation.data['status'] != null
          ? WordStatus.values.firstWhere(
              (status) => status.name == operation.data['status'],
            )
          : null,
      tags: (operation.data['tags'] as List<dynamic>?)?.cast<String>(),
    );

    final current = state.value ?? [];
    final index = current.indexWhere((word) => word.id == operation.wordId);

    if (index != -1) {
      final updated = [...current];
      updated[index] = response;
      state = AsyncData(updated);
      await _saveToCache(updated);
    }
  }

  Future<void> _executeDeleteOperation(PendingOperation operation) async {
    final repository = ref.read(wordbookRepositoryProvider);
    await repository.deleteWord(operation.wordId!);

    final current = state.value ?? [];
    final updated = current.where((word) => word.id != operation.wordId).toList();
    state = AsyncData(updated);
    await _saveToCache(updated);
  }

  Future<void> _replaceTempIdWithRealId({
    required String tempId,
    required Word realWord,
  }) async {
    final current = state.value ?? [];
    final updated = current
        .map((word) => word.id == tempId ? realWord : word)
        .toList();
    state = AsyncData(updated);
    await _saveToCache(updated);
  }
}

@Riverpod(keepAlive: true)
class WordbookOfflineQueue extends _$WordbookOfflineQueue {
  static const _queueKey = 'wordbook_offline_queue_v1';

  @override
  FutureOr<List<PendingOperation>> build() async {
    return _loadQueue();
  }

  Future<void> addOperation(PendingOperation operation) async {
    final currentQueue = state.value ?? [];
    final isDuplicate = currentQueue.any((op) {
      if (operation.operationType == 'CREATE') {
        return op.tempId == operation.tempId;
      }
      return op.wordId == operation.wordId &&
          op.operationType == operation.operationType;
    });

    if (isDuplicate) return;

    final updated = [...currentQueue, operation];
    state = AsyncData(updated);
    await _saveQueue(updated);
  }

  Future<void> removeOperation(String operationId) async {
    final currentQueue = state.value ?? [];
    final updated = currentQueue.where((op) => op.id != operationId).toList();
    state = AsyncData(updated);
    await _saveQueue(updated);
  }

  Future<void> updateOperation(String id, PendingOperation operation) async {
    final currentQueue = state.value ?? [];
    final index = currentQueue.indexWhere((op) => op.id == id);
    if (index == -1) return;
    final updated = [...currentQueue];
    updated[index] = operation;
    state = AsyncData(updated);
    await _saveQueue(updated);
  }

  Future<void> removeOperationsForWord(String wordId) async {
    final currentQueue = state.value ?? [];
    final updated = currentQueue.where((op) => op.wordId != wordId).toList();
    state = AsyncData(updated);
    await _saveQueue(updated);
  }

  Future<void> removeOperationsForTempId(String tempId) async {
    final currentQueue = state.value ?? [];
    final updated = currentQueue.where((op) {
      if (op.operationType == 'CREATE') {
        return op.tempId != tempId;
      }
      return op.wordId != tempId;
    }).toList();
    state = AsyncData(updated);
    await _saveQueue(updated);
  }

  Future<void> processQueue() async {
    final queue = [...(state.value ?? [])];
    for (final operation in queue) {
      if (operation.retryCount >= 3) {
        await removeOperation(operation.id);
        continue;
      }

      final backoff = Duration(seconds: pow(2, operation.retryCount).toInt());
      if (operation.lastAttemptAt != null &&
          DateTime.now().difference(operation.lastAttemptAt!) < backoff) {
        continue;
      }

      try {
        await ref.read(wordbookProvider.notifier).executeOperation(operation);
        await removeOperation(operation.id);
      } catch (error, stackTrace) {
        AppLogger.error(
          'Failed to process offline operation',
          tag: 'WordbookOfflineQueue',
          error: error,
          stackTrace: stackTrace,
        );
        final updatedOperation = operation.copyWith(
          retryCount: operation.retryCount + 1,
          lastAttemptAt: DateTime.now(),
        );
        await updateOperation(operation.id, updatedOperation);
      }
    }
  }

  Future<List<PendingOperation>> _loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_queueKey);
    if (json == null) return [];
    final data = jsonDecode(json) as List<dynamic>;
    return data
        .map((item) => PendingOperation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveQueue(List<PendingOperation> queue) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(queue.map((op) => op.toJson()).toList());
    await prefs.setString(_queueKey, json);
  }

  Future<void> mergeWithCreateOperation(
    String tempId,
    Map<String, dynamic> changes,
  ) async {
    final currentQueue = state.value ?? [];
    final index = currentQueue.indexWhere(
      (op) => op.operationType == 'CREATE' && op.tempId == tempId,
    );
    if (index == -1) {
      AppLogger.warning(
        'Create operation not found for tempId $tempId',
        tag: 'WordbookOfflineQueue',
      );
      return;
    }

    final operation = currentQueue[index];
    final updatedOperation = operation.copyWith(
      data: {
        ...operation.data,
        ...changes,
      },
    );
    await updateOperation(operation.id, updatedOperation);
  }
}

@riverpod
List<Word> filteredWords(
  Ref ref, {
  required WordCategory category,
  required Set<WordStatus> statusFilters,
  required String searchQuery,
}) {
  final allWords = ref.watch(wordbookProvider).value ?? [];
  var filtered = allWords.where((word) => word.category == category).toList();

  if (statusFilters.isNotEmpty) {
    filtered = filtered.where((word) => statusFilters.contains(word.status)).toList();
  }

  final query = searchQuery.trim().toLowerCase();
  if (query.isNotEmpty) {
    filtered = filtered.where((word) {
      final example = word.example?.toLowerCase() ?? '';
      final matchesTag = word.tags.any((tag) => tag.toLowerCase().contains(query));
      return word.word.toLowerCase().contains(query) ||
          word.meaning.toLowerCase().contains(query) ||
          example.contains(query) ||
          matchesTag;
    }).toList();
  }

  return filtered;
}

@Riverpod(keepAlive: true)
class AudioSettingsNotifier extends _$AudioSettingsNotifier {
  static const _cacheKey = 'audio_settings_v1';

  @override
  FutureOr<AudioSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cacheKey);
    if (json == null) {
      // デフォルトは1.0（標準速度）
      return const AudioSettings();
    }
    final data = jsonDecode(json) as Map<String, dynamic>;
    return AudioSettings.fromJson(data);
  }

  /// 倍速値をプラットフォームごとの実際のTTS値に変換
  /// iOS: 0.5が標準速度、Android: 1.0が標準速度
  static double toTtsRate(double normalizedRate) {
    if (Platform.isIOS) {
      // iOS: 1.0倍速 = 0.5, 0.5倍速 = 0.25, 2.0倍速 = 1.0
      return normalizedRate * 0.5;
    } else {
      // Android: 1.0倍速 = 1.0, 0.5倍速 = 0.5, 2.0倍速 = 2.0
      return normalizedRate;
    }
  }

  Future<void> setSpeechRate(double rate) async {
    final current = state.value ?? const AudioSettings();
    final updated = current.copyWith(speechRate: rate);
    state = AsyncData(updated);
    await _save(updated);
    // プラットフォームごとの実際のTTS値に変換して設定
    final ttsRate = toTtsRate(rate);
    await ref.read(wordAudioServiceProvider.notifier).setSpeechRate(ttsRate);
  }

  Future<void> setAutoPlay(bool autoPlay) async {
    final current = state.value ?? const AudioSettings();
    final updated = current.copyWith(autoPlay: autoPlay);
    state = AsyncData(updated);
    await _save(updated);
  }

  Future<void> setVoiceEngine(String? engine) async {
    final current = state.value ?? const AudioSettings();
    final updated = current.copyWith(voiceEngine: engine);
    state = AsyncData(updated);
    await _save(updated);
    await ref.read(wordAudioServiceProvider.notifier).setVoiceEngine(engine);
  }

  Future<void> _save(AudioSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toJson());
    await prefs.setString(_cacheKey, json);
  }
}

@Riverpod(keepAlive: true)
class WordAudioService extends _$WordAudioService {
  FlutterTts? _tts;
  bool _initialized = false;
  String _currentLanguage = 'ko-KR';
  Completer<void>? _speakCompleter;

  @override
  FutureOr<void> build() async {
    await _ensureInitialized();

    ref.onDispose(() {
      _tts?.stop();
      _tts = null;
      _initialized = false;
      _speakCompleter = null;
    });
  }

  /// 韓国語で再生（既存の互換性を維持）
  Future<void> speak(String text) async {
    await _ensureInitialized();
    if (text.trim().isEmpty) return;
    await _tts?.stop();
    await _tts?.speak(text);
  }

  /// 言語を指定して再生（再生完了を待機）
  Future<void> speakWithLanguage(
    String text, {
    required String language,
  }) async {
    await _ensureInitialized();
    if (text.trim().isEmpty) return;

    // 言語が異なる場合のみ切り替え
    if (_currentLanguage != language) {
      await _tts?.setLanguage(language);
      _currentLanguage = language;
    }

    await _tts?.stop();

    // 再生完了待機用のCompleterをセットアップ
    _speakCompleter = Completer<void>();
    await _tts?.speak(text);
    await _speakCompleter?.future;
  }

  /// 日本語で再生（再生完了を待機）
  Future<void> speakJapanese(String text) async {
    await speakWithLanguage(text, language: 'ja-JP');
  }

  /// 韓国語で再生（再生完了を待機）
  Future<void> speakKorean(String text) async {
    await speakWithLanguage(text, language: 'ko-KR');
  }

  Future<void> stop() async {
    _speakCompleter?.complete();
    _speakCompleter = null;
    await _tts?.stop();
  }

  Future<void> setSpeechRate(double rate) async {
    await _ensureInitialized();
    await _tts?.setSpeechRate(rate);
  }

  Future<void> setVoiceEngine(String? engine) async {
    await _ensureInitialized();
    if (engine == null) return;
    await _tts?.setVoice({'name': engine});
  }

  Future<void> _ensureInitialized() async {
    if (_initialized && _tts != null) {
      return;
    }
    final tts = FlutterTts();
    _tts = tts;

    // 再生完了コールバックを設定
    tts.setCompletionHandler(() {
      _speakCompleter?.complete();
      _speakCompleter = null;
    });

    if (Platform.isIOS) {
      await tts.setSharedInstance(true);
      await tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );
    } else {
      await tts.awaitSpeakCompletion(true);
    }

    await tts.setLanguage('ko-KR');
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);

    final settings = await ref.read(audioSettingsProvider.future);
    // 倍速値をプラットフォームごとの実際のTTS値に変換
    final ttsRate = AudioSettingsNotifier.toTtsRate(settings.speechRate);
    await tts.setSpeechRate(ttsRate);
    final engine = settings.voiceEngine;
    if (engine != null) {
      await tts.setVoice({'name': engine});
    }

    _initialized = true;
  }
}

@Riverpod(keepAlive: true)
class WordbookViewModeNotifier extends _$WordbookViewModeNotifier {
  static const _cacheKey = 'wordbook_view_mode_v1';

  @override
  FutureOr<WordbookViewMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_cacheKey);
    if (value == null) return WordbookViewMode.card;
    return WordbookViewMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => WordbookViewMode.card,
    );
  }

  Future<void> toggle() async {
    final current = state.value ?? WordbookViewMode.card;
    final next = current == WordbookViewMode.card
        ? WordbookViewMode.list
        : WordbookViewMode.card;
    state = AsyncData(next);
    await _save(next);
  }

  Future<void> setMode(WordbookViewMode mode) async {
    state = AsyncData(mode);
    await _save(mode);
  }

  Future<void> _save(WordbookViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, mode.name);
  }
}

/// 聞き流し設定の管理
@Riverpod(keepAlive: true)
class ListeningSettingsNotifier extends _$ListeningSettingsNotifier {
  static const _cacheKey = 'listening_settings_v1';

  @override
  FutureOr<ListeningSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cacheKey);
    if (json == null) {
      return const ListeningSettings();
    }
    final data = jsonDecode(json) as Map<String, dynamic>;
    return ListeningSettings.fromJson(data);
  }

  Future<void> setSpeechRate(double rate) async {
    final current = state.value ?? const ListeningSettings();
    final updated = current.copyWith(speechRate: rate);
    state = AsyncData(updated);
    await _save(updated);
  }

  Future<void> setJapaneseToKoreanMs(int ms) async {
    final current = state.value ?? const ListeningSettings();
    final updated = current.copyWith(japaneseToKoreanMs: ms);
    state = AsyncData(updated);
    await _save(updated);
  }

  Future<void> setWordToWordMs(int ms) async {
    final current = state.value ?? const ListeningSettings();
    final updated = current.copyWith(wordToWordMs: ms);
    state = AsyncData(updated);
    await _save(updated);
  }

  Future<void> _save(ListeningSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toJson());
    await prefs.setString(_cacheKey, json);
  }
}
