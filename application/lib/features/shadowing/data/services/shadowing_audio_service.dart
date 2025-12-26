import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../models/shadowing_models.dart';

/// シャドーイング音声再生サービス
class ShadowingAudioService {
  ShadowingAudioService() {
    _player = AudioPlayer();
    _initListeners();
  }

  late final AudioPlayer _player;

  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playerStateController = StreamController<PlayerState>.broadcast();

  /// 現在位置のStream
  Stream<Duration> get positionStream => _positionController.stream;

  /// 総再生時間のStream
  Stream<Duration> get durationStream => _durationController.stream;

  /// プレイヤー状態のStream
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  /// 現在の再生状態
  PlayerState get currentState => _player.state;

  /// 現在の再生位置
  Duration get currentPosition => _currentPosition;
  Duration _currentPosition = Duration.zero;

  /// 総再生時間
  Duration get totalDuration => _totalDuration;
  Duration _totalDuration = Duration.zero;

  void _initListeners() {
    _player.onPositionChanged.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    _player.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      _durationController.add(duration);
    });

    _player.onPlayerStateChanged.listen((state) {
      _playerStateController.add(state);
    });
  }

  /// 音声ファイルを読み込む
  Future<void> loadAudio(String audioPath) async {
    // assets/ プレフィックスを除去（audioPath が 'assets/...' 形式の場合）
    final path = audioPath.startsWith('assets/')
        ? audioPath.substring(7) // 'assets/' を除去
        : audioPath;
    await _player.setSource(AssetSource(path));
  }

  /// 再生
  Future<void> play() async {
    await _player.resume();
  }

  /// 一時停止
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止
  Future<void> stop() async {
    await _player.stop();
  }

  /// シーク
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 再生速度を設定
  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    await _player.setPlaybackRate(speed.value);
  }

  /// 特定のセグメントを再生
  Future<void> playSegment(TextSegment segment) async {
    final startPosition = Duration(
      milliseconds: (segment.startTime * 1000).round(),
    );
    await seek(startPosition);
    await play();
  }

  /// 指定位置から再生
  Future<void> playFrom(Duration position) async {
    await seek(position);
    await play();
  }

  /// 現在位置に対応するセグメントインデックスを取得
  int getCurrentSegmentIndex(List<TextSegment> segments) {
    if (segments.isEmpty) return -1;

    final currentSeconds = _currentPosition.inMilliseconds / 1000;
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (currentSeconds >= segment.startTime && currentSeconds < segment.endTime) {
        return i;
      }
    }

    // 再生位置が最後のセグメントを超えている場合
    if (currentSeconds >= segments.last.endTime) {
      return segments.length - 1;
    }

    return -1;
  }

  /// リソースを解放
  Future<void> dispose() async {
    await _player.dispose();
    await _positionController.close();
    await _durationController.close();
    await _playerStateController.close();
  }
}
