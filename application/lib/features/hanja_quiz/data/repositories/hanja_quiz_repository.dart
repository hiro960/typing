import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/hanja_quiz_models.dart';

/// 漢字語クイズの永続化データを管理するリポジトリ
class HanjaQuizRepository {
  HanjaQuizRepository();

  static const _masteredWordsKey = 'hanja_quiz_mastered_words';

  /// 覚えた漢字語のリストを取得
  Future<List<MasteredHanjaWord>> getMasteredWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_masteredWordsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .whereType<Map<String, dynamic>>()
          .map(MasteredHanjaWord.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// 覚えた漢字語のIDセットを取得
  Future<Set<String>> getMasteredWordIds() async {
    final words = await getMasteredWords();
    return words.map((w) => w.wordId).toSet();
  }

  /// 漢字語を覚えたとして記録
  Future<void> markAsMastered(String wordId) async {
    final words = await getMasteredWords();

    // 既に存在する場合は何もしない
    if (words.any((w) => w.wordId == wordId)) {
      return;
    }

    final newWord = MasteredHanjaWord(
      wordId: wordId,
      masteredAt: DateTime.now(),
    );

    words.add(newWord);
    await _saveWords(words);
  }

  /// 覚えた記録を解除
  Future<void> unmarkAsMastered(String wordId) async {
    final words = await getMasteredWords();
    words.removeWhere((w) => w.wordId == wordId);
    await _saveWords(words);
  }

  /// 複数の漢字語を覚えたとして記録
  Future<void> markMultipleAsMastered(List<String> wordIds) async {
    final words = await getMasteredWords();
    final existingIds = words.map((w) => w.wordId).toSet();

    for (final wordId in wordIds) {
      if (!existingIds.contains(wordId)) {
        words.add(MasteredHanjaWord(
          wordId: wordId,
          masteredAt: DateTime.now(),
        ));
      }
    }

    await _saveWords(words);
  }

  /// 全ての覚えた記録をクリア
  Future<void> clearAllMastered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_masteredWordsKey);
  }

  /// 覚えた漢字語の数を取得
  Future<int> getMasteredCount() async {
    final words = await getMasteredWords();
    return words.length;
  }

  /// 指定したwordIdが覚えた済みかどうか
  Future<bool> isMastered(String wordId) async {
    final ids = await getMasteredWordIds();
    return ids.contains(wordId);
  }

  Future<void> _saveWords(List<MasteredHanjaWord> words) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = words.map((w) => w.toJson()).toList();
    await prefs.setString(_masteredWordsKey, jsonEncode(jsonList));
  }
}
