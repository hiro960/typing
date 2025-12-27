import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../stats/domain/providers/integrated_stats_providers.dart';
import '../../data/models/original_content.dart';
import '../../data/models/shadowing_models.dart';
import '../../data/services/shadowing_audio_service.dart';
import 'original_content_providers.dart';

part 'original_content_session_provider.g.dart';

/// オリジナル文章セッションプロバイダー
@Riverpod(keepAlive: false)
class OriginalContentSession extends _$OriginalContentSession {
  ShadowingAudioService? _audioService;
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

    _audioService = ShadowingAudioService();
    await _audioService!.loadAudio(
      content.audioPath,
      sourceType: AudioSourceType.localFile,
    );

    _setupListeners();

    ref.onDispose(_disposeResources);

    return OriginalContentSessionState(
      content: content,
      totalDuration: Duration(seconds: content.durationSeconds),
    );
  }

  void _setupListeners() {
    _positionSubscription = _audioService?.positionStream.listen((position) {
      if (_audioService?.isDisposed ?? true) return;
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
      if (_audioService?.isDisposed ?? true) return;
      final current = _currentState;
      if (current == null) return;
      if (duration == Duration.zero) return;

      if (duration != current.totalDuration) {
        _setState(current.copyWith(totalDuration: duration));
      }
    });

    _playerStateSubscription =
        _audioService?.playerStateStream.listen((playerState) {
      if (_audioService?.isDisposed ?? true) return;
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
    if (_audioService?.isDisposed ?? true) return;
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

    // アクティビティを記録
    _recordActivity(current);
  }

  /// アクティビティを記録（プライベートメソッド）
  Future<void> _recordActivity(OriginalContentSessionState completedState) async {
    try {
      final statsRepo = ref.read(integratedStatsRepositoryProvider);
      await statsRepo.recordActivity(
        activityType: 'shadowing',
        timeSpent: completedState.totalDuration.inMilliseconds,
      );
    } catch (e) {
      debugPrint('Failed to record shadowing activity: $e');
    }
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
