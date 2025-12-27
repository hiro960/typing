import 'package:freezed_annotation/freezed_annotation.dart';

import 'shadowing_models.dart';

part 'original_content.freezed.dart';
part 'original_content.g.dart';

/// オリジナル文章コンテンツ（ローカル保存）
@freezed
abstract class OriginalContent with _$OriginalContent {
  const OriginalContent._();

  const factory OriginalContent({
    required String id,
    required String title,
    required String text,
    required String audioPath,
    @Default(0) int durationSeconds,
    @Default(0) int practiceCount,
    @Default(<TextSegment>[]) List<TextSegment> segments,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastPracticed,
  }) = _OriginalContent;

  factory OriginalContent.fromJson(Map<String, dynamic> json) =>
      _$OriginalContentFromJson(json);

  /// マスター済みか（20回以上練習）
  bool get isMastered => practiceCount >= 20;

  /// 練習済みか（1回以上練習）
  bool get isPracticed => practiceCount > 0;

  /// 音声が生成済みか
  bool get hasAudio => audioPath.isNotEmpty && segments.isNotEmpty;
}

/// オリジナル文章データファイルの構造
@freezed
abstract class OriginalContentDataFile with _$OriginalContentDataFile {
  const factory OriginalContentDataFile({
    @Default('1.0.0') String version,
    @Default(<OriginalContent>[]) List<OriginalContent> contents,
  }) = _OriginalContentDataFile;

  factory OriginalContentDataFile.fromJson(Map<String, dynamic> json) =>
      _$OriginalContentDataFileFromJson(json);
}

/// オリジナル文章セッション状態
@freezed
abstract class OriginalContentSessionState with _$OriginalContentSessionState {
  const OriginalContentSessionState._();

  const factory OriginalContentSessionState({
    required OriginalContent content,
    @Default(false) bool isPlaying,
    @Default(PlaybackSpeed.x1_0) PlaybackSpeed playbackSpeed,
    @Default(Duration.zero) Duration currentPosition,
    @Default(Duration.zero) Duration totalDuration,
    @Default(-1) int currentSegmentIndex,
    @Default(true) bool showMeaning,
    /// リピートモードの対象セグメントインデックス（-1 = リピートなし）
    @Default(-1) int repeatSegmentIndex,
  }) = _OriginalContentSessionState;

  /// 現在のセグメントを取得
  TextSegment? get currentSegment {
    if (currentSegmentIndex < 0 ||
        currentSegmentIndex >= content.segments.length) {
      return null;
    }
    return content.segments[currentSegmentIndex];
  }

  /// リピートモードが有効か
  bool get isRepeatMode => repeatSegmentIndex >= 0;

  /// リピート対象のセグメントを取得
  TextSegment? get repeatSegment {
    if (repeatSegmentIndex < 0 ||
        repeatSegmentIndex >= content.segments.length) {
      return null;
    }
    return content.segments[repeatSegmentIndex];
  }

  /// 進行率（0.0〜1.0）
  double get progress {
    if (totalDuration.inMilliseconds == 0) return 0.0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }
}
