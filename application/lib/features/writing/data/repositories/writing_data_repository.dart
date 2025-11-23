import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/writing_models.dart';

/// 書き取り練習用のデータリポジトリ（JSON読み込み）
class WritingDataRepository {
  static const List<String> _patternFiles = [
    'assets/writing/graph_description.json',
    'assets/writing/opinion.json',
    'assets/writing/pro_con.json',
    'assets/writing/cause_effect.json',
    'assets/writing/problem_solution.json',
    'assets/writing/intro_body_conclusion.json',
    'assets/writing/comparison.json',
    'assets/writing/proposal.json',
    'assets/writing/example.json',
  ];

  /// 全パターンを取得
  Future<List<WritingPattern>> getAllPatterns() async {
    final patterns = <WritingPattern>[];

    for (final file in _patternFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final pattern = WritingPattern.fromJson(jsonData);
        patterns.add(pattern);
      } catch (e) {
        // エラーログを出力して続行
        print('Error loading pattern from $file: $e');
      }
    }

    return patterns;
  }
}
