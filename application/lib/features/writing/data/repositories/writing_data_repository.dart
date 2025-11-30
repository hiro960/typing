import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../models/writing_models.dart';

/// 書き取り練習用のデータリポジトリ（JSON読み込み）
class WritingDataRepository {
  static const _assetManifestPath = 'AssetManifest.json';
  static const _topikDir = 'assets/writing/topik/';
  static const _hobbyDir = 'assets/writing/hobby/';
  static const _beginnerDir = 'assets/writing/beginner/';
  static const _beginnerPatternId = 'beginner_words';
  static const _topikFilesFallback = <String>[
    '${_topikDir}cause_effect.json',
    '${_topikDir}common_connectors.json',
    '${_topikDir}comparison.json',
    '${_topikDir}example.json',
    '${_topikDir}graph_description.json',
    '${_topikDir}intro_body_conclusion.json',
    '${_topikDir}opinion.json',
    '${_topikDir}pro_con.json',
    '${_topikDir}problem_solution.json',
    '${_topikDir}proposal.json',
  ];
  static const _hobbyFilesFallback = <String>[
    '${_hobbyDir}hobby_sns.json',
    '${_hobbyDir}hobby_kdrama.json',
    '${_hobbyDir}hobby_oshi.json',
  ];

  static const _beginnerTopicMeta = <String, (String name, String description)>{
    'greeting': ('挨拶', '日常の挨拶や声かけ'),
    'daily_basics': ('日常基本語', '日常の基本名詞・代名詞'),
    'daily_phrases': ('日常フレーズ', '返答や頻出フレーズ'),
    'daily_connectives': ('つなぎ言葉', '副詞・接続表現'),
    'daily_home': ('家・暮らし', '住まいや生活用品の語彙'),
    'daily_particles': ('助詞・表現', '助詞や頻出のひとこと表現'),
    'daily_places': ('場所と方向', '位置・方向を表す表現'),
    'daily_verbs': ('基本動詞・形容詞', 'よく使う動作と性質'),
    'family': ('家族', '家族や親族の呼び方'),
    'food': ('食べ物', '食事や食材の基本語彙'),
    'health': ('健康', '体調や病院で使う表現'),
    'emotion': ('感情', '気持ちを伝える単語'),
    'education': ('学校', '学校や学習で使う語彙'),
    'shopping': ('買い物', '買い物やお会計で使う表現'),
    'color': ('色', '色を表す単語'),
    'number': ('数字', '数字や数え方の基本'),
    'time': ('時間', '時間や曜日の表現'),
    'travel': ('旅行', '旅行や移動に関する単語'),
    'transportation': ('交通', '乗り物や移動手段の表現'),
    'weather': ('天気', '気象を表す単語'),
    'nature': ('自然', '自然や環境に関する語彙'),
    'body': ('からだ', '体の部位や関連表現'),
    'personality': ('性格', '人柄や性格を表す単語'),
  };

  /// 全パターンを取得（TOPIK/初級/趣味ごとに読み込み）
  Future<List<WritingPattern>> getAllPatterns() async {
    final manifest = await _tryLoadAssetManifest();
    final patterns = <WritingPattern>[];

    patterns.addAll(
      await _loadPatternFiles(
        files: await _listAssetFiles(
          manifest: manifest,
          directory: _topikDir,
          fallback: _topikFilesFallback,
        ),
        lane: WritingLane.topik,
      ),
    );

    final beginnerPattern = await _buildBeginnerPattern(
      await _listAssetFiles(
        manifest: manifest,
        directory: _beginnerDir,
        fallback: _buildBeginnerFallbackFiles(),
      ),
    );
    if (beginnerPattern != null) {
      patterns.add(beginnerPattern);
    }

    patterns.addAll(
      await _loadPatternFiles(
        files: await _listAssetFiles(
          manifest: manifest,
          directory: _hobbyDir,
          fallback: _hobbyFilesFallback,
        ),
        lane: WritingLane.hobby,
      ),
    );

    return patterns;
  }

  Future<Map<String, dynamic>?> _tryLoadAssetManifest() async {
    try {
      final manifestJson = await rootBundle.loadString(_assetManifestPath);
      return jsonDecode(manifestJson) as Map<String, dynamic>;
    } catch (e) {
      print('AssetManifest.json load failed: $e');
    }

    try {
      final byteData = await rootBundle.load('AssetManifest.bin');
      final decoded =
          const StandardMessageCodec().decodeMessage(
                byteData.buffer.asByteData(),
              )
              as Map<Object?, Object?>?;
      return decoded?.map((key, value) => MapEntry(key as String, value));
    } catch (e) {
      // 一部環境でAssetManifestが見つからない場合があるため、フォールバックする
      print('AssetManifest.bin load failed: $e');
    }

    return null;
  }

  Future<List<String>> _listAssetFiles({
    required Map<String, dynamic>? manifest,
    required String directory,
    required List<String> fallback,
  }) async {
    if (manifest != null) {
      final direct =
          manifest.keys
              .where(
                (path) => path.startsWith(directory) && path.endsWith('.json'),
              )
              .toList()
            ..sort();

      if (direct.isNotEmpty) {
        return direct;
      }

      // ディレクトリ構成が変わってもファイル名が同じなら拾う
      final fallbackNames = fallback
          .map((path) => path.split('/').last)
          .toSet();
      final matchedByName =
          manifest.keys
              .where(
                (path) =>
                    fallbackNames.contains(path.split('/').last) &&
                    path.endsWith('.json'),
              )
              .toList()
            ..sort();

      if (matchedByName.isNotEmpty) {
        // 重複防止しつつ順序を安定化
        final deduped = <String>{};
        for (final path in matchedByName) {
          deduped.add(path);
        }
        return deduped.toList()..sort();
      }
    }

    return fallback;
  }

  List<String> _buildBeginnerFallbackFiles() {
    return _beginnerTopicMeta.keys
        .map((id) => '$_beginnerDir$id.json')
        .toList();
  }

  Future<List<WritingPattern>> _loadPatternFiles({
    required List<String> files,
    required WritingLane lane,
  }) async {
    final patterns = <WritingPattern>[];

    for (final file in files) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final pattern = WritingPattern.fromJson(jsonData).copyWith(lane: lane);
        patterns.add(pattern);
      } catch (e) {
        print('Error loading pattern from $file: $e');
      }
    }

    return patterns;
  }

  Future<WritingPattern?> _buildBeginnerPattern(List<String> files) async {
    if (files.isEmpty) return null;

    final topics = <WritingTopic>[];

    for (final file in files) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
        final topicId = jsonData['topicId'] as String?;
        final entriesJson = jsonData['entries'] as List<dynamic>? ?? [];

        if (topicId == null) continue;

        final (name, description) =
            _beginnerTopicMeta[topicId] ?? (topicId, '基本単語を練習');

        final entries = entriesJson
            .whereType<Map<String, dynamic>>()
            .map(_mapBeginnerEntry)
            .whereType<WritingEntry>()
            .toList();

        if (entries.isEmpty) continue;

        topics.add(
          WritingTopic(
            id: 'beginner_$topicId',
            name: name,
            description: description,
            patternId: _beginnerPatternId,
            entries: entries,
          ),
        );
      } catch (e) {
        print('Error loading beginner topic from $file: $e');
      }
    }

    if (topics.isEmpty) return null;

    return WritingPattern(
      id: _beginnerPatternId,
      name: '初級単語',
      description: '日常で使う基本単語をカテゴリ別に練習',
      icon: 'description',
      topics: topics,
      lane: WritingLane.beginner,
    );
  }

  WritingEntry? _mapBeginnerEntry(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final jpText = json['jpText'] as String? ?? '';
    final koText = json['koText'] as String? ?? '';

    if (id.isEmpty || jpText.isEmpty || koText.isEmpty) {
      return null;
    }

    return WritingEntry(
      id: id,
      level: _parseEntryLevel(json['level'] as String?),
      jpText: jpText,
      koText: koText,
    );
  }

  EntryLevel _parseEntryLevel(String? level) {
    switch (level) {
      case 'template':
        return EntryLevel.template;
      case 'advanced':
        return EntryLevel.advanced;
      case 'sentence':
        return EntryLevel.sentence;
      case 'basic':
      case 'beginner':
      default:
        return EntryLevel.basic;
    }
  }
}
