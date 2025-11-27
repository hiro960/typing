import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';

/// ランキングゲーム用の単語ローダーサービス
class WordLoaderService {
  WordLoaderService();

  final Map<String, List<RankingGameWord>> _cache = {};
  final Random _random = Random();

  /// 指定した難易度の単語リストをロード
  Future<List<RankingGameWord>> loadWords(RankingGameDifficulty difficulty) async {
    final difficultyStr = difficulty.name;

    // キャッシュがあればそれを返す
    if (_cache.containsKey(difficultyStr)) {
      return _cache[difficultyStr]!;
    }

    // JSONファイルをロード
    final jsonString = await rootBundle.loadString(
      'assets/ranking_game/words/$difficultyStr.json',
    );
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final wordDataFile = WordDataFile.fromJson(json);

    // キャッシュに保存
    _cache[difficultyStr] = wordDataFile.words;

    return wordDataFile.words;
  }

  /// 単語リストをシャッフルして返す
  Future<List<RankingGameWord>> loadAndShuffleWords(RankingGameDifficulty difficulty) async {
    final words = await loadWords(difficulty);
    final shuffled = List<RankingGameWord>.from(words);
    shuffled.shuffle(_random);
    return shuffled;
  }

  /// キャッシュをクリア
  void clearCache() {
    _cache.clear();
  }
}
