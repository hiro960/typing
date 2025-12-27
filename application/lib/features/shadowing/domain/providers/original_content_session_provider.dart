import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/original_content.dart';
import '../../data/models/shadowing_models.dart';
import '../../data/services/shadowing_audio_service.dart';
import 'original_content_providers.dart';

part 'original_content_session_provider.g.dart';

/// オリジナル文章用の音声再生サービス（ローカルファイル対応）
class OriginalAudioService {
  OriginalAudioService() {
    _player = AudioPlayer();
    _initListeners();
  }

  late final AudioPlayer _player;
  Source? _currentSource;
  double _playbackRate = 1.0;

  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playerStateController = StreamController<PlayerState>.broadcast();

  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  PlayerState get currentState => _player.state;
  Duration get currentPosition => _currentPosition;
  Duration _currentPosition = Duration.zero;

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

  /// ローカル音声ファイルを読み込む
  Future<void> loadAudio(String audioPath) async {
    final file = File(audioPath);
    if (!await file.exists()) {
      throw Exception('音声ファイルが見つかりません: $audioPath');
    }
    _currentSource = DeviceFileSource(audioPath);
    await _player.setSource(_currentSource!);
  }

  Future<void> play() async {
    if (_currentSource == null) return;
    if (_player.state == PlayerState.completed) {
      await _playFromSource(Duration.zero);
      return;
    }
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    _playbackRate = speed.value;
    await _player.setPlaybackRate(speed.value);
  }

  Future<void> playSegment(TextSegment segment) async {
    final startPosition = Duration(
      milliseconds: (segment.startTime * 1000).round(),
    );
    await _playFrom(startPosition);
  }

  Future<void> playFrom(Duration position) async {
    await _playFrom(position);
  }

  Future<void> _playFrom(Duration position) async {
    if (_currentSource == null) return;

    if (_player.state == PlayerState.completed) {
      await _playFromSource(position);
      return;
    }

    await seek(position);
    await play();
  }

  Future<void> _playFromSource(Duration position) async {
    if (_currentSource == null) return;
    await _player.play(_currentSource!, position: position);
    if (_playbackRate != 1.0) {
      await _player.setPlaybackRate(_playbackRate);
    }
  }

  int getCurrentSegmentIndex(List<TextSegment> segments) {
    if (segments.isEmpty) return -1;

    final currentSeconds = _currentPosition.inMilliseconds / 1000;
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (currentSeconds >= segment.startTime &&
          currentSeconds < segment.endTime) {
        return i;
      }
    }

    if (currentSeconds >= segments.last.endTime) {
      return segments.length - 1;
    }

    return -1;
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _positionController.close();
    await _durationController.close();
    await _playerStateController.close();
  }
}

/// オリジナル文章セッションプロバイダー
@Riverpod(keepAlive: false)
class OriginalContentSession extends _$OriginalContentSession {
  OriginalAudioService? _audioService;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  FutureOr<OriginalContentSessionState> build(String contentId) async {
    final content = await ref.watch(originalContentProvider(contentId).future);
    if (content == null) {
      throw Exception('コンテンツが見つかりません: $contentId');
    }

    if (!content.hasAudio) {
      throw Exception('音声が生成されていません');
    }

    _audioService = OriginalAudioService();
    await _audioService!.loadAudio(content.audioPath);

    _setupListeners();

    ref.onDispose(_disposeResources);

    return OriginalContentSessionState(
      content: content,
      totalDuration: Duration(seconds: content.durationSeconds),
    );
  }

  void _setupListeners() {
    _positionSubscription = _audioService?.positionStream.listen((position) {
      final current = _currentState;
      if (current == null) return;

      final segmentIndex =
          _audioService!.getCurrentSegmentIndex(current.content.segments);

      // リピートモード時にセグメント終了を検出してループ
      if (current.isRepeatMode && current.isPlaying) {
        final repeatSegment = current.repeatSegment;
        if (repeatSegment != null) {
          final currentSeconds = position.inMilliseconds / 1000;
          if (currentSeconds >= repeatSegment.endTime) {
            _loopRepeatSegment(repeatSegment);
            return;
          }
        }
      }

      _setState(current.copyWith(
        currentPosition: position,
        currentSegmentIndex: segmentIndex,
      ));
    });

    _durationSubscription = _audioService?.durationStream.listen((duration) {
      final current = _currentState;
      if (current == null) return;
      if (duration == Duration.zero) return;

      if (duration != current.totalDuration) {
        _setState(current.copyWith(totalDuration: duration));
      }
    });

    _playerStateSubscription =
        _audioService?.playerStateStream.listen((playerState) {
      final current = _currentState;
      if (current == null) return;

      final isPlaying = playerState == PlayerState.playing;
      _setState(current.copyWith(isPlaying: isPlaying));

      // 再生完了時に練習回数をインクリメント（リピートモードでない場合のみ）
      if (playerState == PlayerState.completed && !current.isRepeatMode) {
        _onPlaybackCompleted();
      }
    });
  }

  Future<void> _loopRepeatSegment(TextSegment segment) async {
    final startPosition = Duration(
      milliseconds: (segment.startTime * 1000).round(),
    );
    await _audioService?.seek(startPosition);
    await _audioService?.play();
  }

  Future<void> togglePlayPause() async {
    final current = _currentState;
    if (current == null) return;

    if (current.isPlaying) {
      await _audioService?.pause();
    } else {
      await _audioService?.play();
    }
  }

  Future<void> play() async {
    await _audioService?.play();
  }

  Future<void> pause() async {
    await _audioService?.pause();
  }

  Future<void> stop() async {
    await _audioService?.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioService?.seek(position);
  }

  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    final current = _currentState;
    if (current == null) return;

    await _audioService?.setPlaybackSpeed(speed);
    _setState(current.copyWith(playbackSpeed: speed));
  }

  Future<void> playSegment(int segmentIndex) async {
    final current = _currentState;
    if (current == null) return;

    if (segmentIndex < 0 || segmentIndex >= current.content.segments.length) {
      return;
    }

    final segment = current.content.segments[segmentIndex];
    await _audioService?.playSegment(segment);
  }

  Future<void> setRepeatSegment(int segmentIndex) async {
    final current = _currentState;
    if (current == null) return;

    if (segmentIndex < 0 || segmentIndex >= current.content.segments.length) {
      return;
    }

    // 同じセグメントを再度長押しした場合はリピート解除
    if (current.repeatSegmentIndex == segmentIndex) {
      _setState(current.copyWith(repeatSegmentIndex: -1));
      return;
    }

    _setState(current.copyWith(repeatSegmentIndex: segmentIndex));
    final segment = current.content.segments[segmentIndex];
    await _audioService?.playSegment(segment);
  }

  void clearRepeatMode() {
    final current = _currentState;
    if (current == null) return;
    _setState(current.copyWith(repeatSegmentIndex: -1));
  }

  void toggleMeaning() {
    final current = _currentState;
    if (current == null) return;
    _setState(current.copyWith(showMeaning: !current.showMeaning));
  }

  void _onPlaybackCompleted() {
    final current = _currentState;
    if (current == null) return;

    // 練習回数をインクリメント
    ref
        .read(originalContentPracticeProvider.notifier)
        .incrementPracticeCount(current.content.id);
  }

  void _disposeResources() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioService?.dispose();
  }

  OriginalContentSessionState? get _currentState => state.asData?.value;

  void _setState(OriginalContentSessionState newState) {
    state = AsyncData(newState);
  }
}
