import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/env_config.dart';
import '../models/shadowing_models.dart';

/// Google Cloud TTS を使用して音声を生成するサービス
class TtsGeneratorService {
  static const _baseUrl =
      'https://texttospeech.googleapis.com/v1beta1/text:synthesize';

  /// TTS API のスコープ
  static const _scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  /// TTS音声設定
  static const _voiceConfig = {
    'languageCode': 'ko-KR',
    'name': 'ko-KR-Neural2-A',
    'ssmlGender': 'FEMALE',
  };

  static const _audioConfig = {
    'audioEncoding': 'MP3',
    'speakingRate': 0.95,
    'pitch': 0.0,
    'sampleRateHertz': 44100,
  };

  /// キャッシュされたアクセストークン
  AccessCredentials? _cachedCredentials;

  /// サービスアカウント認証でアクセストークンを取得
  Future<String> _getAccessToken() async {
    // キャッシュされたトークンがまだ有効な場合は再利用
    if (_cachedCredentials != null) {
      final expiry = _cachedCredentials!.accessToken.expiry;
      // 有効期限の5分前までは再利用
      if (expiry.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
        return _cachedCredentials!.accessToken.data;
      }
    }

    final serviceAccountJson = EnvConfig.googleServiceAccountJson;
    if (serviceAccountJson.isEmpty) {
      throw Exception('Google Service Account JSON が設定されていません');
    }

    // JSONをパースしてServiceAccountCredentialsを作成
    final accountCredentials =
        ServiceAccountCredentials.fromJson(jsonDecode(serviceAccountJson));

    // アクセストークンを取得
    final httpClient = http.Client();
    try {
      _cachedCredentials = await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        _scopes,
        httpClient,
      );
      return _cachedCredentials!.accessToken.data;
    } finally {
      httpClient.close();
    }
  }

  /// 韓国語テキストから音声を生成してファイルに保存
  /// 戻り値: 音声の長さ（秒）
  Future<int> generateAudio({
    required String text,
    required String outputPath,
  }) async {
    final accessToken = await _getAccessToken();

    // SSMLを生成（自然な読み上げのため）
    final ssml = _generateSSML(text);

    final requestBody = {
      'input': {'ssml': ssml},
      'voice': _voiceConfig,
      'audioConfig': _audioConfig,
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'TTS API エラー: ${response.statusCode} - ${response.body}',
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final audioContent = responseData['audioContent'] as String;

    // Base64デコードしてファイルに保存
    final audioBytes = base64Decode(audioContent);
    final outputFile = File(outputPath);

    // ディレクトリが存在しない場合は作成
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsBytes(audioBytes);

    // 音声の長さを概算（MP3 128kbpsとして）
    final durationSeconds = _estimateDuration(audioBytes.length);

    return durationSeconds;
  }

  /// セグメント付きで音声を生成（タイムスタンプ取得）
  Future<TtsGenerationResult> generateAudioWithSegments({
    required String text,
    required List<TextSegment> segments,
    required String outputPath,
  }) async {
    final accessToken = await _getAccessToken();

    // セグメントごとにmarkタグを挿入したSSMLを生成
    final ssml = _generateSSMLWithMarks(segments);

    final requestBody = {
      'input': {'ssml': ssml},
      'voice': _voiceConfig,
      'audioConfig': _audioConfig,
      'enableTimePointing': ['SSML_MARK'],
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'TTS API エラー: ${response.statusCode} - ${response.body}',
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final audioContent = responseData['audioContent'] as String;
    final timepoints = responseData['timepoints'] as List<dynamic>? ?? [];

    // Base64デコードしてファイルに保存
    final audioBytes = base64Decode(audioContent);
    final outputFile = File(outputPath);

    // ディレクトリが存在しない場合は作成
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsBytes(audioBytes);

    // 音声の長さを概算
    final totalDuration = _estimateDuration(audioBytes.length);

    // タイムポイントからセグメントの時間を計算
    final updatedSegments = _calculateSegmentTimes(
      timepoints,
      segments,
      totalDuration.toDouble(),
    );

    return TtsGenerationResult(
      audioPath: outputPath,
      durationSeconds: totalDuration,
      segments: updatedSegments,
    );
  }

  /// シンプルなSSMLを生成
  String _generateSSML(String text) {
    var ssml = text
        // 文末の「。」の後に短い間を追加
        .replaceAll('. ', '.<break time="500ms"/> ')
        .replaceAll('。', '。<break time="500ms"/>')
        // 「,」の後に短い間を追加
        .replaceAll(', ', ',<break time="300ms"/> ')
        .replaceAll('、', '、<break time="300ms"/>');

    return '<speak>$ssml</speak>';
  }

  /// セグメントごとにmarkタグを挿入したSSMLを生成
  String _generateSSMLWithMarks(List<TextSegment> segments) {
    final buffer = StringBuffer('<speak>');

    for (var i = 0; i < segments.length; i++) {
      // セグメント開始マーク
      buffer.write('<mark name="seg_${i}_start"/>');

      // セグメントのテキスト（breakタグ付き）
      var segmentText = segments[i].text
          .replaceAll('. ', '.<break time="500ms"/> ')
          .replaceAll('。', '。<break time="500ms"/>')
          .replaceAll(', ', ',<break time="300ms"/> ')
          .replaceAll('、', '、<break time="300ms"/>');

      buffer.write(segmentText);

      // セグメント終了マーク
      buffer.write('<mark name="seg_${i}_end"/>');
    }

    buffer.write('</speak>');
    return buffer.toString();
  }

  /// タイムポイントからセグメントのstartTime/endTimeを計算
  List<TextSegment> _calculateSegmentTimes(
    List<dynamic> timepoints,
    List<TextSegment> segments,
    double totalDuration,
  ) {
    final updatedSegments = <TextSegment>[];

    for (var i = 0; i < segments.length; i++) {
      final startMark = timepoints.cast<Map<String, dynamic>>().firstWhere(
            (tp) => tp['markName'] == 'seg_${i}_start',
            orElse: () => <String, dynamic>{},
          );
      final endMark = timepoints.cast<Map<String, dynamic>>().firstWhere(
            (tp) => tp['markName'] == 'seg_${i}_end',
            orElse: () => <String, dynamic>{},
          );

      // timeSecondsはStringで返される場合がある（"1.234s"形式）
      final startTime = _parseTimeSeconds(startMark['timeSeconds']);
      double endTime;

      if (endMark.isNotEmpty) {
        endTime = _parseTimeSeconds(endMark['timeSeconds']);
      } else if (i < segments.length - 1) {
        // 次のセグメントの開始時間
        final nextStartMark =
            timepoints.cast<Map<String, dynamic>>().firstWhere(
                  (tp) => tp['markName'] == 'seg_${i + 1}_start',
                  orElse: () => <String, dynamic>{},
                );
        endTime = nextStartMark.isNotEmpty
            ? _parseTimeSeconds(nextStartMark['timeSeconds'])
            : totalDuration;
      } else {
        endTime = totalDuration;
      }

      updatedSegments.add(
        segments[i].copyWith(
          startTime: _roundToTwoDecimals(startTime),
          endTime: _roundToTwoDecimals(endTime),
        ),
      );
    }

    return updatedSegments;
  }

  /// timeSecondsをパース（"1.234s"形式または数値）
  double _parseTimeSeconds(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      // "1.234s" 形式の場合
      final cleaned = value.replaceAll('s', '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  /// 小数点2桁に丸める
  double _roundToTwoDecimals(double value) {
    return (value * 100).round() / 100;
  }

  /// MP3ファイルサイズから再生時間を概算（128kbps想定）
  int _estimateDuration(int fileSizeBytes) {
    const bitrate = 128000; // 128kbps
    final durationSeconds = (fileSizeBytes * 8) / bitrate;
    return durationSeconds.round();
  }
}

/// TTS生成結果
class TtsGenerationResult {
  const TtsGenerationResult({
    required this.audioPath,
    required this.durationSeconds,
    required this.segments,
  });

  final String audioPath;
  final int durationSeconds;
  final List<TextSegment> segments;
}
