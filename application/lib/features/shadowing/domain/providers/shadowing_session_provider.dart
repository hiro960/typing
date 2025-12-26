import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/shadowing_models.dart';
import '../../data/services/shadowing_audio_service.dart';
import 'shadowing_providers.dart';

part 'shadowing_session_provider.g.dart';

/// シャドーイングセッションプロバイダー
@Riverpod(keepAlive: false)
class ShadowingSession extends _$ShadowingSession {
  ShadowingAudioService? _audioService;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  FutureOr<ShadowingSessionState> build(String contentId, ShadowingLevel level) async {
    final contents = await ref.watch(shadowingContentsProvider(level).future);
    final content = contents.firstWhere((c) => c.id == contentId);

    _audioService = ShadowingAudioService();
    await _audioService!.loadAudio(content.audioPath);

    _setupListeners();

    ref.onDispose(_disposeResources);

    return ShadowingSessionState(
      content: content,
      totalDuration: Duration(seconds: content.durationSeconds),
    );
  }

  void _setupListeners() {
    _positionSubscription = _audioService?.positionStream.listen((position) {
      final current = _currentState;
      if (current == null) return;

      final segmentIndex = _audioService!.getCurrentSegmentIndex(current.content.segments);

      // リピートモード時にセグメント終了を検出してループ
      if (current.isRepeatMode && current.isPlaying) {
        final repeatSegment = current.repeatSegment;
        if (repeatSegment != null) {
          final currentSeconds = position.inMilliseconds / 1000;
          // セグメント終了位置を超えたらループ
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

    _playerStateSubscription = _audioService?.playerStateStream.listen((playerState) {
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

  /// リピートセグメントをループ再生
  Future<void> _loopRepeatSegment(TextSegment segment) async {
    final startPosition = Duration(
      milliseconds: (segment.startTime * 1000).round(),
    );
    await _audioService?.seek(startPosition);
    await _audioService?.play();
  }

  /// 再生/一時停止をトグル
  Future<void> togglePlayPause() async {
    final current = _currentState;
    if (current == null) return;

    if (current.isPlaying) {
      await _audioService?.pause();
    } else {
      await _audioService?.play();
    }
  }

  /// 再生
  Future<void> play() async {
    await _audioService?.play();
  }

  /// 一時停止
  Future<void> pause() async {
    await _audioService?.pause();
  }

  /// 停止
  Future<void> stop() async {
    await _audioService?.stop();
  }

  /// シーク
  Future<void> seek(Duration position) async {
    await _audioService?.seek(position);
  }

  /// 再生速度を変更
  Future<void> setPlaybackSpeed(PlaybackSpeed speed) async {
    final current = _currentState;
    if (current == null) return;

    await _audioService?.setPlaybackSpeed(speed);
    _setState(current.copyWith(playbackSpeed: speed));
  }

  /// 特定のセグメントを再生
  Future<void> playSegment(int segmentIndex) async {
    final current = _currentState;
    if (current == null) return;

    if (segmentIndex < 0 || segmentIndex >= current.content.segments.length) {
      return;
    }

    final segment = current.content.segments[segmentIndex];
    await _audioService?.playSegment(segment);
  }

  /// セグメントリピートモードを設定
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

    // リピートモードを設定してそのセグメントから再生開始
    _setState(current.copyWith(repeatSegmentIndex: segmentIndex));
    final segment = current.content.segments[segmentIndex];
    await _audioService?.playSegment(segment);
  }

  /// リピートモードを解除
  void clearRepeatMode() {
    final current = _currentState;
    if (current == null) return;
    _setState(current.copyWith(repeatSegmentIndex: -1));
  }

  /// 日本語訳の表示/非表示を切り替え
  void toggleMeaning() {
    final current = _currentState;
    if (current == null) return;
    _setState(current.copyWith(showMeaning: !current.showMeaning));
  }

  /// 前のコンテンツへ移動（同一レベル内）
  Future<void> goToPrevious() async {
    final current = _currentState;
    if (current == null) return;

    final level = _getLevelFromContentId(current.content.id);
    final contents = await ref.read(shadowingContentsProvider(level).future);
    final currentIndex = contents.indexWhere((c) => c.id == current.content.id);

    if (currentIndex > 0) {
      final prevContent = contents[currentIndex - 1];
      await _loadNewContent(prevContent);
    }
  }

  /// 次のコンテンツへ移動（同一レベル内）
  Future<void> goToNext() async {
    final current = _currentState;
    if (current == null) return;

    final level = _getLevelFromContentId(current.content.id);
    final contents = await ref.read(shadowingContentsProvider(level).future);
    final currentIndex = contents.indexWhere((c) => c.id == current.content.id);

    if (currentIndex < contents.length - 1) {
      final nextContent = contents[currentIndex + 1];
      await _loadNewContent(nextContent);
    }
  }

  Future<void> _loadNewContent(ShadowingContent content) async {
    await _audioService?.stop();
    await _audioService?.loadAudio(content.audioPath);
    _setState(ShadowingSessionState(
      content: content,
      totalDuration: Duration(seconds: content.durationSeconds),
    ));
  }

  void _onPlaybackCompleted() {
    final current = _currentState;
    if (current == null) return;

    // 練習回数をインクリメント
    final repository = ref.read(shadowingRepositoryProvider);
    repository.incrementPracticeCount(current.content.id);

    // 進捗データを再読み込み
    ref.invalidate(shadowingAllProgressProvider);
  }

  ShadowingLevel _getLevelFromContentId(String contentId) {
    if (contentId.startsWith('beginner')) {
      return ShadowingLevel.beginner;
    } else if (contentId.startsWith('intermediate')) {
      return ShadowingLevel.intermediate;
    } else {
      return ShadowingLevel.advanced;
    }
  }

  void _disposeResources() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioService?.dispose();
  }

  ShadowingSessionState? get _currentState => state.asData?.value;

  void _setState(ShadowingSessionState newState) {
    state = AsyncData(newState);
  }
}
