import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chaletta/features/diary/data/models/diary_post.dart';

part 'pronunciation_game_models.freezed.dart';
part 'pronunciation_game_models.g.dart';

/// 発音ゲームの難易度
enum PronunciationGameDifficulty {
  beginner,
  intermediate,
  advanced,
}

/// 発音ゲームセッション設定（プロバイダー引数用）
@freezed
abstract class PronunciationGameConfig with _$PronunciationGameConfig {
  const factory PronunciationGameConfig({
    required String difficulty,
    @Default(false) bool isPracticeMode,
    int? targetQuestionCount,
  }) = _PronunciationGameConfig;
}

/// 発音ゲームの出題単語
@freezed
abstract class PronunciationGameWord with _$PronunciationGameWord {
  const factory PronunciationGameWord({
    required String word,
    required String meaning,
  }) = _PronunciationGameWord;

  factory PronunciationGameWord.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameWordFromJson(json);
}

/// 発音ゲーム結果レコード
@freezed
abstract class PronunciationGameResult with _$PronunciationGameResult {
  const factory PronunciationGameResult({
    required String id,
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required int characterLevel,
    required DateTime playedAt,
  }) = _PronunciationGameResult;

  factory PronunciationGameResult.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameResultFromJson(json);
}

/// ゲーム結果レスポンス（ランキング情報付き）
@freezed
abstract class PronunciationGameResultResponse with _$PronunciationGameResultResponse {
  const factory PronunciationGameResultResponse({
    required String id,
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required int characterLevel,
    required DateTime playedAt,
    required PronunciationRankingInfo ranking,
    @Default(<String>[]) List<String> achievements,
  }) = _PronunciationGameResultResponse;

  factory PronunciationGameResultResponse.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameResultResponseFromJson(json);
}

/// ランキング情報
@freezed
abstract class PronunciationRankingInfo with _$PronunciationRankingInfo {
  const factory PronunciationRankingInfo({
    required int position,
    int? previousPosition,
    required int totalParticipants,
    required bool isNewBest,
  }) = _PronunciationRankingInfo;

  factory PronunciationRankingInfo.fromJson(Map<String, dynamic> json) =>
      _$PronunciationRankingInfoFromJson(json);
}

/// ランキングエントリ
@freezed
abstract class PronunciationRankingEntry with _$PronunciationRankingEntry {
  const factory PronunciationRankingEntry({
    required int position,
    required DiaryUserSummary user,
    required int score,
    required int characterLevel,
    required int playCount,
    @Default(0) int maxCombo,
  }) = _PronunciationRankingEntry;

  factory PronunciationRankingEntry.fromJson(Map<String, dynamic> json) =>
      _$PronunciationRankingEntryFromJson(json);
}

/// ランキング期間情報
@freezed
abstract class PronunciationRankingPeriodInfo with _$PronunciationRankingPeriodInfo {
  const factory PronunciationRankingPeriodInfo({
    required DateTime start,
    required DateTime end,
  }) = _PronunciationRankingPeriodInfo;

  factory PronunciationRankingPeriodInfo.fromJson(Map<String, dynamic> json) =>
      _$PronunciationRankingPeriodInfoFromJson(json);
}

/// 自分のランキング情報
@freezed
abstract class MyPronunciationRankingInfo with _$MyPronunciationRankingInfo {
  const factory MyPronunciationRankingInfo({
    required int position,
    required int score,
    required int characterLevel,
  }) = _MyPronunciationRankingInfo;

  factory MyPronunciationRankingInfo.fromJson(Map<String, dynamic> json) =>
      _$MyPronunciationRankingInfoFromJson(json);
}

/// ランキングデータレスポンス
@freezed
abstract class PronunciationRankingDataResponse with _$PronunciationRankingDataResponse {
  const factory PronunciationRankingDataResponse({
    required PronunciationRankingPeriodInfo period,
    @Default(<PronunciationRankingEntry>[]) List<PronunciationRankingEntry> rankings,
    MyPronunciationRankingInfo? myRanking,
    required int totalParticipants,
  }) = _PronunciationRankingDataResponse;

  factory PronunciationRankingDataResponse.fromJson(Map<String, dynamic> json) =>
      _$PronunciationRankingDataResponseFromJson(json);
}

/// 難易度別ベストスコア
@freezed
abstract class PronunciationBestScoreByDifficulty with _$PronunciationBestScoreByDifficulty {
  const factory PronunciationBestScoreByDifficulty({
    required int all,
    required int beginner,
    required int intermediate,
    required int advanced,
  }) = _PronunciationBestScoreByDifficulty;

  factory PronunciationBestScoreByDifficulty.fromJson(Map<String, dynamic> json) =>
      _$PronunciationBestScoreByDifficultyFromJson(json);
}

/// 難易度別月間ランキング
@freezed
abstract class PronunciationMonthlyRankingByDifficulty with _$PronunciationMonthlyRankingByDifficulty {
  const factory PronunciationMonthlyRankingByDifficulty({
    int? all,
    int? beginner,
    int? intermediate,
    int? advanced,
  }) = _PronunciationMonthlyRankingByDifficulty;

  factory PronunciationMonthlyRankingByDifficulty.fromJson(Map<String, dynamic> json) =>
      _$PronunciationMonthlyRankingByDifficultyFromJson(json);
}

/// 実績情報
@freezed
abstract class PronunciationGameAchievements with _$PronunciationGameAchievements {
  const factory PronunciationGameAchievements({
    required int maxCombo,
    required int maxCharacterLevel,
    required int totalBonusTimeEarned,
  }) = _PronunciationGameAchievements;

  factory PronunciationGameAchievements.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameAchievementsFromJson(json);
}

/// ユーザー統計レスポンス
@freezed
abstract class PronunciationGameUserStats with _$PronunciationGameUserStats {
  const factory PronunciationGameUserStats({
    required int totalPlays,
    required PronunciationBestScoreByDifficulty bestScore,
    required PronunciationMonthlyRankingByDifficulty monthlyRanking,
    required PronunciationGameAchievements achievements,
    @Default(<PronunciationGameResult>[]) List<PronunciationGameResult> recentResults,
  }) = _PronunciationGameUserStats;

  factory PronunciationGameUserStats.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameUserStatsFromJson(json);
}

/// ユーザー統計レスポンス（軽量版・ホーム画面用）
@freezed
abstract class PronunciationGameStatsSummary with _$PronunciationGameStatsSummary {
  const factory PronunciationGameStatsSummary({
    required PronunciationBestScoreByDifficulty bestScore,
  }) = _PronunciationGameStatsSummary;

  factory PronunciationGameStatsSummary.fromJson(Map<String, dynamic> json) =>
      _$PronunciationGameStatsSummaryFromJson(json);
}

/// 入力結果の種類
enum PronunciationInputResultType {
  none,
  correct,
  mistake,
}

/// ゲームセッション状態
@freezed
abstract class PronunciationGameSessionState with _$PronunciationGameSessionState {
  const PronunciationGameSessionState._();

  const factory PronunciationGameSessionState({
    required String difficulty,
    required int remainingTimeMs,
    @Default(0) int score,
    @Default(0) int correctCount,
    @Default(0) int currentCombo,
    @Default(0) int maxCombo,
    @Default(0) int characterLevel,
    PronunciationGameWord? currentWord,
    @Default('') String recognizedText,
    @Default(false) bool isListening,
    @Default(false) bool isPlaying,
    @Default(false) bool isFinished,
    @Default(<PronunciationGameWord>[]) List<PronunciationGameWord> wordQueue,
    @Default(<PronunciationGameWord>[]) List<PronunciationGameWord> completedWords, // 完了した単語リスト
    @Default(0) int totalBonusTime,
    @Default(0) int wordIndex,
    DateTime? startTime,
    @Default(PronunciationInputResultType.none) PronunciationInputResultType lastInputResult,
    DateTime? lastInputTime,
    @Default(0) int totalMistakes,
    // 練習モード用フィールド
    @Default(false) bool isPracticeMode,
    int? targetQuestionCount,
  }) = _PronunciationGameSessionState;

  /// 初期状態を作成
  factory PronunciationGameSessionState.initial(PronunciationGameConfig config) {
    return PronunciationGameSessionState(
      difficulty: config.difficulty,
      remainingTimeMs: config.isPracticeMode ? 999999999 : _getInitialTime(config.difficulty),
      isPracticeMode: config.isPracticeMode,
      targetQuestionCount: config.targetQuestionCount,
    );
  }

  static int _getInitialTime(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 30000; // 30秒
      case 'intermediate':
        return 45000; // 45秒
      case 'advanced':
        return 60000; // 60秒
      default:
        return 30000;
    }
  }

  /// 経過時間（秒）
  double get elapsedSeconds {
    if (startTime == null) return 0;
    return DateTime.now().difference(startTime!).inMilliseconds / 1000;
  }

  /// 正解率（0.0〜1.0）
  double get accuracy {
    final total = correctCount + totalMistakes;
    if (total == 0) return 0.0;
    return correctCount / total;
  }

  /// 総プレイ時間（ミリ秒）
  int get totalPlayTimeMs {
    if (startTime == null) return 0;
    return DateTime.now().difference(startTime!).inMilliseconds;
  }
}

/// 単語データファイルの構造
@freezed
abstract class PronunciationWordDataFile with _$PronunciationWordDataFile {
  const factory PronunciationWordDataFile({
    required String version,
    required String difficulty,
    @Default(<PronunciationGameWord>[]) List<PronunciationGameWord> words,
  }) = _PronunciationWordDataFile;

  factory PronunciationWordDataFile.fromJson(Map<String, dynamic> json) =>
      _$PronunciationWordDataFileFromJson(json);
}
