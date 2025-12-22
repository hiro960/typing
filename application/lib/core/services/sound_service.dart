import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaletta/core/utils/logger.dart';

/// 効果音の種類
enum SoundEffect {
  correct,
  incorrect,
}

/// 効果音再生サービス
///
/// Androidでの音声遅延を解消するため、以下の最適化を実装:
/// 1. プリロード: 音声ファイルを事前にロードして保持
/// 2. AudioContext設定: 音声認識との競合を回避
/// 3. 専用AudioPlayer: 正解/不正解音それぞれに専用インスタンスを使用
class SoundService {
  SoundService();

  AudioPlayer? _correctPlayer;
  AudioPlayer? _incorrectPlayer;
  bool _isInitialized = false;
  bool _isInitializing = false;

  /// 初期化済みかどうか
  bool get isInitialized => _isInitialized;

  /// AudioContextを事前に設定（オプション、ゲーム開始前に呼び出すと初回再生が速くなる）
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      // AudioContextを設定（低遅延・音声認識との共存）
      await _configureAudioContext();

      // AudioPlayerインスタンスを事前に作成
      _correctPlayer = AudioPlayer();
      _incorrectPlayer = AudioPlayer();

      _isInitialized = true;
    } catch (e) {
      // エラーは無視（音が鳴らないだけ）
    } finally {
      _isInitializing = false;
    }
  }

  /// AudioContextを設定
  Future<void> _configureAudioContext() async {
    try {
      final audioContext = AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {
            AVAudioSessionOptions.mixWithOthers,
            AVAudioSessionOptions.duckOthers,
          },
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
          // AudioFocusを取得しない（音声認識との競合を回避）
          audioFocus: AndroidAudioFocus.none,
        ),
      );
      await AudioPlayer.global.setAudioContext(audioContext);
      AppLogger.info(
        'AudioContext configured for ${Platform.isAndroid ? "Android" : "iOS"}',
        tag: 'SoundService',
      );
    } catch (e) {
      AppLogger.warning(
        'Failed to configure AudioContext: $e',
        tag: 'SoundService',
      );
    }
  }

  /// 効果音を再生
  ///
  /// AndroidではPlayerState.completed状態でseek()がハングする問題があるため、
  /// 常にplay(AssetSource)を使用する。初回ロード後は約80-100msで再生される。
  Future<void> play(SoundEffect effect) async {
    // AudioContextが設定されていない場合は設定
    if (!_isInitialized) {
      await _configureAudioContext();
      _isInitialized = true;
    }

    final player = switch (effect) {
      SoundEffect.correct => _correctPlayer ??= AudioPlayer(),
      SoundEffect.incorrect => _incorrectPlayer ??= AudioPlayer(),
    };

    final soundFile = switch (effect) {
      SoundEffect.correct => 'se/correct.mp3',
      SoundEffect.incorrect => 'se/incorrect.mp3',
    };

    try {
      // 再生中の場合は停止（次の音をすぐに再生するため）
      if (player.state == PlayerState.playing) {
        await player.stop();
      }

      // 常にplay()を使用（seek+resumeはAndroidでハングする問題がある）
      await player.play(AssetSource(soundFile));
    } catch (e) {
      // エラーは無視（音が鳴らないだけ）
    }
  }

  /// 正解音を再生
  Future<void> playCorrect() => play(SoundEffect.correct);

  /// 不正解音を再生
  Future<void> playIncorrect() => play(SoundEffect.incorrect);

  /// リソースを解放
  void dispose() {
    _correctPlayer?.dispose();
    _incorrectPlayer?.dispose();
    _correctPlayer = null;
    _incorrectPlayer = null;
    _isInitialized = false;
  }
}

/// SoundServiceのProvider
final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService();
  ref.onDispose(() => service.dispose());
  return service;
});
