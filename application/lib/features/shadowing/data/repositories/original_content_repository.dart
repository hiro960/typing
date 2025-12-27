import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/original_content.dart';
import '../models/shadowing_models.dart';

/// オリジナル文章のリポジトリ
class OriginalContentRepository {
  static const _contentsFileName = 'contents.json';
  static const _audioDirectoryName = 'audio';
  static const _baseDirectoryName = 'shadowing/original';

  final _uuid = const Uuid();

  /// アプリのドキュメントディレクトリを取得
  Future<Directory> _getBaseDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final baseDir = Directory('${documentsDir.path}/$_baseDirectoryName');
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }
    return baseDir;
  }

  /// 音声ファイルディレクトリを取得
  Future<Directory> _getAudioDirectory() async {
    final baseDir = await _getBaseDirectory();
    final audioDir = Directory('${baseDir.path}/$_audioDirectoryName');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  /// コンテンツJSONファイルのパスを取得
  Future<File> _getContentsFile() async {
    final baseDir = await _getBaseDirectory();
    return File('${baseDir.path}/$_contentsFileName');
  }

  /// 全てのオリジナル文章を取得
  Future<List<OriginalContent>> getAllContents() async {
    try {
      final file = await _getContentsFile();
      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final dataFile = OriginalContentDataFile.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
      // freezedの不変リストを変更可能なリストにコピー
      return List<OriginalContent>.from(dataFile.contents);
    } catch (e) {
      return [];
    }
  }

  /// オリジナル文章を保存（新規作成・更新）
  Future<OriginalContent> saveContent({
    String? id,
    required String title,
    required String text,
    List<TextSegment>? segments,
    String? audioPath,
    int durationSeconds = 0,
  }) async {
    final contents = await getAllContents();
    final now = DateTime.now();

    OriginalContent content;
    if (id != null) {
      // 更新
      final index = contents.indexWhere((c) => c.id == id);
      if (index >= 0) {
        final existing = contents[index];
        content = existing.copyWith(
          title: title,
          text: text,
          segments: segments ?? existing.segments,
          audioPath: audioPath ?? existing.audioPath,
          durationSeconds: durationSeconds > 0 ? durationSeconds : existing.durationSeconds,
          updatedAt: now,
        );
        contents[index] = content;
      } else {
        throw Exception('Content not found: $id');
      }
    } else {
      // 新規作成
      final newId = _uuid.v4();

      // 一時IDで作成された音声ファイルを正式なIDにリネーム
      String? finalAudioPath = audioPath;
      if (audioPath != null && audioPath.isNotEmpty) {
        finalAudioPath = await _renameAudioFileIfNeeded(audioPath, newId);
      }

      content = OriginalContent(
        id: newId,
        title: title,
        text: text,
        segments: segments ?? [],
        audioPath: finalAudioPath ?? '',
        durationSeconds: durationSeconds,
        practiceCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      contents.add(content);
    }

    await _saveContents(contents);
    return content;
  }

  /// 一時IDの音声ファイルを正式なIDにリネーム
  Future<String> _renameAudioFileIfNeeded(String currentPath, String newId) async {
    final currentFile = File(currentPath);
    if (!await currentFile.exists()) {
      // ファイルが存在しない場合はそのまま返す
      return currentPath;
    }

    // ファイル名がtemp_で始まる場合のみリネーム
    final fileName = currentPath.split('/').last;
    if (!fileName.startsWith('temp_')) {
      return currentPath;
    }

    // 新しいパスを生成
    final newPath = await generateAudioFilePath(newId);

    // ファイルをリネーム（コピー＆削除）
    try {
      await currentFile.copy(newPath);
      await currentFile.delete();
      return newPath;
    } catch (e) {
      // リネームに失敗した場合は元のパスを返す
      return currentPath;
    }
  }

  /// 練習回数を更新
  Future<OriginalContent> updatePracticeCount(String id) async {
    final contents = await getAllContents();
    final index = contents.indexWhere((c) => c.id == id);
    if (index < 0) {
      throw Exception('Content not found: $id');
    }

    final now = DateTime.now();
    final updated = contents[index].copyWith(
      practiceCount: contents[index].practiceCount + 1,
      lastPracticed: now,
      updatedAt: now,
    );
    contents[index] = updated;

    await _saveContents(contents);
    return updated;
  }

  /// 音声ファイルのパスとセグメント（タイムスタンプ付き）を更新
  Future<OriginalContent> updateAudioWithSegments(
    String id,
    String audioPath,
    int durationSeconds,
    List<TextSegment> segments,
  ) async {
    final contents = await getAllContents();
    final index = contents.indexWhere((c) => c.id == id);
    if (index < 0) {
      throw Exception('Content not found: $id');
    }

    final now = DateTime.now();
    final updated = contents[index].copyWith(
      audioPath: audioPath,
      durationSeconds: durationSeconds,
      segments: segments,
      updatedAt: now,
    );
    contents[index] = updated;

    await _saveContents(contents);
    return updated;
  }

  /// オリジナル文章を削除
  Future<void> deleteContent(String id) async {
    final contents = await getAllContents();
    final index = contents.indexWhere((c) => c.id == id);
    if (index < 0) {
      return;
    }

    // 音声ファイルも削除
    final content = contents[index];
    if (content.audioPath.isNotEmpty) {
      final audioFile = File(content.audioPath);
      if (await audioFile.exists()) {
        await audioFile.delete();
      }
    }

    contents.removeAt(index);
    await _saveContents(contents);
  }

  /// 単一のオリジナル文章を取得
  Future<OriginalContent?> getContent(String id) async {
    final contents = await getAllContents();
    try {
      return contents.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 音声ファイルの保存先パスを生成
  Future<String> generateAudioFilePath(String contentId) async {
    final audioDir = await _getAudioDirectory();
    return '${audioDir.path}/$contentId.mp3';
  }

  /// コンテンツをJSONファイルに保存
  Future<void> _saveContents(List<OriginalContent> contents) async {
    final dataFile = OriginalContentDataFile(
      version: '1.0.0',
      contents: contents,
    );

    final file = await _getContentsFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(dataFile.toJson()),
    );
  }

  /// オリジナル文章の統計を取得
  Future<OriginalContentStats> getStats() async {
    final contents = await getAllContents();
    return OriginalContentStats(
      totalCount: contents.length,
      masteredCount: contents.where((c) => c.isMastered).length,
      practicedCount: contents.where((c) => c.isPracticed).length,
    );
  }
}

/// オリジナル文章の統計
class OriginalContentStats {
  const OriginalContentStats({
    required this.totalCount,
    required this.masteredCount,
    required this.practicedCount,
  });

  final int totalCount;
  final int masteredCount;
  final int practicedCount;
}
