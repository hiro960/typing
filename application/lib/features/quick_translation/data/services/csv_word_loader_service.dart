import 'package:flutter/services.dart' show rootBundle;

/// CSVから読み込んだ単語データ
class QuickTranslationCsvWord {
  const QuickTranslationCsvWord({
    required this.koreanWord,
    required this.pos,
    required this.japaneseMeaning,
  });

  final String koreanWord;
  final String pos;
  final String japaneseMeaning;
}

/// 瞬間作文用の単語CSVを読み込むサービス
class CsvWordLoaderService {
  static const String _csvPath = 'assets/words/quick_translation_words.csv';

  /// CSVから全ての単語を読み込む
  Future<List<QuickTranslationCsvWord>> loadAllWords() async {
    final csvString = await rootBundle.loadString(_csvPath);
    final lines = csvString.split('\n');

    final words = <QuickTranslationCsvWord>[];

    // ヘッダー行をスキップして1行目から処理
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length >= 3) {
        words.add(
          QuickTranslationCsvWord(
            koreanWord: parts[0].trim(),
            pos: parts[1].trim(),
            japaneseMeaning: parts[2].trim(),
          ),
        );
      }
    }

    return words;
  }

  /// CSVの総単語数を取得
  Future<int> getWordCount() async {
    final words = await loadAllWords();
    return words.length;
  }
}
