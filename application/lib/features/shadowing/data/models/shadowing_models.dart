import 'package:freezed_annotation/freezed_annotation.dart';

part 'shadowing_models.freezed.dart';
part 'shadowing_models.g.dart';

/// シャドーイングレベル
enum ShadowingLevel {
  beginner,     // 初級 (TOPIK 1-2) - 20コンテンツ
  intermediate, // 中級 (TOPIK 3-4) - 30コンテンツ
  advanced,     // 高級 (TOPIK 5-6) - 40コンテンツ
}

/// テキストセグメント（文/句単位）
@freezed
abstract class TextSegment with _$TextSegment {
  const factory TextSegment({
    required int index,
    required String text,
    required String meaning,
    required double startTime,
    required double endTime,
  }) = _TextSegment;

  factory TextSegment.fromJson(Map<String, dynamic> json) =>
      _$TextSegmentFromJson(json);
}

/// シャドーイングコンテンツ
@freezed
abstract class ShadowingContent with _$ShadowingContent {
  const factory ShadowingContent({
    required String id,
    required String title,
    required String text,
    required String meaning,
    required String audioPath,
    required int durationSeconds,
    String? tip,
    @Default(<TextSegment>[]) List<TextSegment> segments,
  }) = _ShadowingContent;

  factory ShadowingContent.fromJson(Map<String, dynamic> json) =>
      _$ShadowingContentFromJson(json);
}

/// コンテンツデータファイルの構造
@freezed
abstract class ShadowingDataFile with _$ShadowingDataFile {
  const factory ShadowingDataFile({
    required String version,
    required String level,
    @Default(<ShadowingContent>[]) List<ShadowingContent> contents,
  }) = _ShadowingDataFile;

  factory ShadowingDataFile.fromJson(Map<String, dynamic> json) =>
      _$ShadowingDataFileFromJson(json);
}

/// 学習進捗
@freezed
abstract class ShadowingProgress with _$ShadowingProgress {
  const ShadowingProgress._();

  const factory ShadowingProgress({
    required String contentId,
    @Default(0) int practiceCount,
    DateTime? lastPracticed,
  }) = _ShadowingProgress;

  factory ShadowingProgress.fromJson(Map<String, dynamic> json) =>
      _$ShadowingProgressFromJson(json);

  /// マスター済みか（20回以上練習）
  bool get isMastered => practiceCount >= 20;

  /// 練習済みか（1回以上練習）
  bool get isPracticed => practiceCount > 0;
}

/// レベル別統計
@freezed
abstract class ShadowingLevelStats with _$ShadowingLevelStats {
  const factory ShadowingLevelStats({
    required ShadowingLevel level,
    required int totalCount,
    @Default(0) int masteredCount,
    @Default(0) int practicedCount,
  }) = _ShadowingLevelStats;
}

/// 再生速度
enum PlaybackSpeed {
  x0_5(0.5, '0.5x'),
  x0_75(0.75, '0.75x'),
  x1_0(1.0, '1.0x'),
  x1_25(1.25, '1.25x');

  const PlaybackSpeed(this.value, this.label);
  final double value;
  final String label;
}

/// シャドーイングセッション状態
@freezed
abstract class ShadowingSessionState with _$ShadowingSessionState {
  const ShadowingSessionState._();

  const factory ShadowingSessionState({
    required ShadowingContent content,
    @Default(false) bool isPlaying,
    @Default(PlaybackSpeed.x1_0) PlaybackSpeed playbackSpeed,
    @Default(Duration.zero) Duration currentPosition,
    @Default(Duration.zero) Duration totalDuration,
    @Default(-1) int currentSegmentIndex,
    @Default(true) bool showMeaning,
    /// リピートモードの対象セグメントインデックス（-1 = リピートなし）
    @Default(-1) int repeatSegmentIndex,
  }) = _ShadowingSessionState;

  /// 現在のセグメントを取得
  TextSegment? get currentSegment {
    if (currentSegmentIndex < 0 || currentSegmentIndex >= content.segments.length) {
      return null;
    }
    return content.segments[currentSegmentIndex];
  }

  /// リピートモードが有効か
  bool get isRepeatMode => repeatSegmentIndex >= 0;

  /// リピート対象のセグメントを取得
  TextSegment? get repeatSegment {
    if (repeatSegmentIndex < 0 || repeatSegmentIndex >= content.segments.length) {
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
