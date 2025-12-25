import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chaletta/core/utils/logger.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';

/// Google Cloud TTS音声再生の結果
enum TtsResult {
  /// 再生成功
  success,
  /// 有料会員限定機能エラー
  premiumRequired,
  /// ネットワークエラー
  networkError,
  /// その他のエラー
  error,
}

/// Google Cloud Text-to-Speech サービス
///
/// バックエンドのTTS APIを呼び出して高品質な韓国語音声を再生する。
/// 有料会員（PREMIUM/OFFICIAL）限定機能。
class GoogleTtsService {
  GoogleTtsService({required Dio dio}) : _dio = dio;

  final Dio _dio;
  AudioPlayer? _player;
  bool _isPlaying = false;

  // 音声キャッシュ（同じテキストの再リクエストを防ぐ）
  final Map<String, Uint8List> _audioCache = {};
  static const int _maxCacheSize = 50;

  /// 現在再生中かどうか
  bool get isPlaying => _isPlaying;

  /// テキストを音声で読み上げる
  ///
  /// [text] 読み上げるテキスト（韓国語）
  /// Returns [TtsResult] 再生結果
  Future<TtsResult> speak(String text) async {
    if (text.trim().isEmpty) {
      return TtsResult.error;
    }

    try {
      _isPlaying = true;

      // キャッシュをチェック
      Uint8List? audioBytes = _audioCache[text];

      if (audioBytes == null) {
        // APIを呼び出して音声データを取得
        final response = await _dio.post<Map<String, dynamic>>(
          '/api/tts',
          data: {'text': text},
        );

        final audioContent = response.data?['audioContent'] as String?;
        if (audioContent == null || audioContent.isEmpty) {
          AppLogger.error('TTS API returned empty audio content', tag: 'GoogleTts');
          return TtsResult.error;
        }

        // Base64デコード
        audioBytes = base64Decode(audioContent);

        // キャッシュに保存（サイズ制限あり）
        if (_audioCache.length >= _maxCacheSize) {
          // 最初のエントリを削除
          _audioCache.remove(_audioCache.keys.first);
        }
        _audioCache[text] = audioBytes;
      }

      // AudioPlayerで再生
      _player ??= AudioPlayer();

      // 再生中の場合は停止
      if (_player!.state == PlayerState.playing) {
        await _player!.stop();
      }

      await _player!.play(BytesSource(audioBytes));

      AppLogger.info('TTS playback started: $text', tag: 'GoogleTts');
      return TtsResult.success;
    } on DioException catch (e) {
      AppLogger.error('TTS API error', tag: 'GoogleTts', error: e);

      // 403エラー = 有料会員限定
      if (e.response?.statusCode == 403) {
        return TtsResult.premiumRequired;
      }

      // ネットワークエラー
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return TtsResult.networkError;
      }

      return TtsResult.error;
    } catch (e) {
      AppLogger.error('TTS playback error', tag: 'GoogleTts', error: e);
      return TtsResult.error;
    } finally {
      _isPlaying = false;
    }
  }

  /// 再生を停止する
  Future<void> stop() async {
    if (_player != null && _player!.state == PlayerState.playing) {
      await _player!.stop();
    }
    _isPlaying = false;
  }

  /// キャッシュをクリアする
  void clearCache() {
    _audioCache.clear();
  }

  /// リソースを解放する
  void dispose() {
    _player?.dispose();
    _player = null;
    _audioCache.clear();
    _isPlaying = false;
  }
}

/// GoogleTtsServiceのProvider
final googleTtsServiceProvider = Provider<GoogleTtsService>((ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  final service = GoogleTtsService(dio: apiClient.dio);
  ref.onDispose(() => service.dispose());
  return service;
});
