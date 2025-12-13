import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/logger.dart';
import '../../../quick_translation/data/services/csv_word_loader_service.dart';
import '../../data/models/word_model.dart';
import 'wordbook_providers.dart';

part 'bulk_add_words_provider.freezed.dart';
part 'bulk_add_words_provider.g.dart';

/// バルク追加の状態
@freezed
class BulkAddState with _$BulkAddState {
  const factory BulkAddState.initial() = BulkAddInitial;
  const factory BulkAddState.loading({
    required int total,
    required int processed,
    required int added,
    required int skipped,
    required int failed,
  }) = BulkAddLoading;
  const factory BulkAddState.success({
    required int added,
    required int skipped,
    required int failed,
  }) = BulkAddSuccess;
  const factory BulkAddState.error(String message) = BulkAddError;
}

/// 瞬間作文の単語を一括追加するProvider
@Riverpod(keepAlive: true)
class BulkAddWordsNotifier extends _$BulkAddWordsNotifier {
  bool _isCancelled = false;

  @override
  BulkAddState build() {
    ref.onDispose(() {
      _isCancelled = true;
    });
    return const BulkAddState.initial();
  }

  /// バルク追加処理をキャンセル
  void cancel() {
    _isCancelled = true;
  }

  /// 瞬間作文の全単語を単語帳に追加
  Future<void> addAllQuickTranslationWords() async {
    _isCancelled = false;

    try {
      // 1. CSVから全単語を読み込み
      final csvLoader = CsvWordLoaderService();
      final csvWords = await csvLoader.loadAllWords();
      final total = csvWords.length;

      state = BulkAddState.loading(
        total: total,
        processed: 0,
        added: 0,
        skipped: 0,
        failed: 0,
      );

      // 2. 現在の単語帳を取得
      final existingWords = ref.read(wordbookProvider).value ?? [];
      final existingWordSet = existingWords
          .where((w) => w.category == WordCategory.WORDS)
          .map((w) => w.word.toLowerCase())
          .toSet();

      // 3. 重複を除外したリストを作成
      final wordsToAdd = csvWords
          .where((w) => !existingWordSet.contains(w.koreanWord.toLowerCase()))
          .toList();

      final skippedCount = total - wordsToAdd.length;
      var addedCount = 0;
      var failedCount = 0;
      var processedCount = skippedCount;

      state = BulkAddState.loading(
        total: total,
        processed: processedCount,
        added: addedCount,
        skipped: skippedCount,
        failed: failedCount,
      );

      // 4. 5件ずつ並列で追加
      const batchSize = 5;
      final wordbookNotifier = ref.read(wordbookProvider.notifier);

      for (var i = 0; i < wordsToAdd.length; i += batchSize) {
        if (_isCancelled) break;

        final batch = wordsToAdd.skip(i).take(batchSize).toList();
        final results = await Future.wait(
          batch.map((csvWord) => _addSingleWord(wordbookNotifier, csvWord)),
        );

        for (final success in results) {
          if (success) {
            addedCount++;
          } else {
            failedCount++;
          }
          processedCount++;
        }

        state = BulkAddState.loading(
          total: total,
          processed: processedCount,
          added: addedCount,
          skipped: skippedCount,
          failed: failedCount,
        );
      }

      // 5. 完了
      state = BulkAddState.success(
        added: addedCount,
        skipped: skippedCount,
        failed: failedCount,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to bulk add words',
        tag: 'BulkAddWordsNotifier',
        error: error,
        stackTrace: stackTrace,
      );
      state = BulkAddState.error('単語の追加中にエラーが発生しました: $error');
    }
  }

  Future<bool> _addSingleWord(
    WordbookNotifier notifier,
    QuickTranslationCsvWord csvWord,
  ) async {
    try {
      await notifier.addWord(
        word: csvWord.koreanWord,
        meaning: csvWord.japaneseMeaning,
        category: WordCategory.WORDS,
        status: WordStatus.REVIEWING,
        tags: ['瞬間作文', csvWord.pos],
      );
      return true;
    } catch (error) {
      AppLogger.warning(
        'Failed to add word: ${csvWord.koreanWord}',
        tag: 'BulkAddWordsNotifier',
      );
      return false;
    }
  }

  /// 状態をリセット
  void reset() {
    _isCancelled = false;
    state = const BulkAddState.initial();
  }
}

/// CSVの総単語数を取得するProvider
@riverpod
Future<int> quickTranslationWordCount(Ref ref) async {
  final csvLoader = CsvWordLoaderService();
  return csvLoader.getWordCount();
}
