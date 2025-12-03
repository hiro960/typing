import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chaletta/features/diary/data/models/diary_post.dart';

part 'ranking_game_models.freezed.dart';
part 'ranking_game_models.g.dart';

/// ランキングゲームの難易度
enum RankingGameDifficulty {
  beginner,
  intermediate,
  advanced,
}

/// ランキング期間
enum RankingPeriod {
  weekly,
  monthly,
}

/// 出題単語
@freezed
abstract class RankingGameWord with _$RankingGameWord {
  const factory RankingGameWord({
    required String word,
    required String meaning,
  }) = _RankingGameWord;

  factory RankingGameWord.fromJson(Map<String, dynamic> json) =>
      _$RankingGameWordFromJson(json);
}

/// ゲーム結果レコード
@freezed
abstract class RankingGameResult with _$RankingGameResult {
  const factory RankingGameResult({
    required String id,
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required double avgInputSpeed,
    required int characterLevel,
    required DateTime playedAt,
  }) = _RankingGameResult;

  factory RankingGameResult.fromJson(Map<String, dynamic> json) =>
      _$RankingGameResultFromJson(json);
}

/// ゲーム結果レスポンス（ランキング情報付き）
@freezed
abstract class RankingGameResultResponse with _$RankingGameResultResponse {
  const factory RankingGameResultResponse({
    required String id,
    required String difficulty,
    required int score,
    required int correctCount,
    required int maxCombo,
    required int totalBonusTime,
    required double avgInputSpeed,
    required int characterLevel,
    required DateTime playedAt,
    required RankingInfo ranking,
    @Default(<String>[]) List<String> achievements,
  }) = _RankingGameResultResponse;

  factory RankingGameResultResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingGameResultResponseFromJson(json);
}

/// ランキング情報
@freezed
abstract class RankingInfo with _$RankingInfo {
  const factory RankingInfo({
    required int position,
    int? previousPosition,
    required int totalParticipants,
    required bool isNewBest,
  }) = _RankingInfo;

  factory RankingInfo.fromJson(Map<String, dynamic> json) =>
      _$RankingInfoFromJson(json);
}

/// ランキングエントリ
@freezed
abstract class RankingEntry with _$RankingEntry {
  const factory RankingEntry({
    required int position,
    required DiaryUserSummary user,
    required int score,
    required int characterLevel,
    required int playCount,
    @Default(0) int maxCombo,
  }) = _RankingEntry;

  factory RankingEntry.fromJson(Map<String, dynamic> json) =>
      _$RankingEntryFromJson(json);
}

/// ランキング期間情報
@freezed
abstract class RankingPeriodInfo with _$RankingPeriodInfo {
  const factory RankingPeriodInfo({
    required DateTime start,
    required DateTime end,
  }) = _RankingPeriodInfo;

  factory RankingPeriodInfo.fromJson(Map<String, dynamic> json) =>
      _$RankingPeriodInfoFromJson(json);
}

/// 自分のランキング情報
@freezed
abstract class MyRankingInfo with _$MyRankingInfo {
  const factory MyRankingInfo({
    required int position,
    required int score,
    required int characterLevel,
  }) = _MyRankingInfo;

  factory MyRankingInfo.fromJson(Map<String, dynamic> json) =>
      _$MyRankingInfoFromJson(json);
}

/// ランキングデータレスポンス
@freezed
abstract class RankingDataResponse with _$RankingDataResponse {
  const factory RankingDataResponse({
    required RankingPeriodInfo period,
    @Default(<RankingEntry>[]) List<RankingEntry> rankings,
    MyRankingInfo? myRanking,
    required int totalParticipants,
  }) = _RankingDataResponse;

  factory RankingDataResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingDataResponseFromJson(json);
}

/// 難易度別ベストスコア
@freezed
abstract class BestScoreByDifficulty with _$BestScoreByDifficulty {
  const factory BestScoreByDifficulty({
    required int all,
    required int beginner,
    required int intermediate,
    required int advanced,
  }) = _BestScoreByDifficulty;

  factory BestScoreByDifficulty.fromJson(Map<String, dynamic> json) =>
      _$BestScoreByDifficultyFromJson(json);
}

/// 難易度別月間ランキング
@freezed
abstract class MonthlyRankingByDifficulty with _$MonthlyRankingByDifficulty {
  const factory MonthlyRankingByDifficulty({
    int? all,
    int? beginner,
    int? intermediate,
    int? advanced,
  }) = _MonthlyRankingByDifficulty;

  factory MonthlyRankingByDifficulty.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRankingByDifficultyFromJson(json);
}

/// 実績情報
@freezed
abstract class RankingGameAchievements with _$RankingGameAchievements {
  const factory RankingGameAchievements({
    required int maxCombo,
    required int maxCharacterLevel,
    required int totalBonusTimeEarned,
  }) = _RankingGameAchievements;

  factory RankingGameAchievements.fromJson(Map<String, dynamic> json) =>
      _$RankingGameAchievementsFromJson(json);
}

/// ユーザー統計レスポンス
@freezed
abstract class RankingGameUserStats with _$RankingGameUserStats {
  const factory RankingGameUserStats({
    required int totalPlays,
    required BestScoreByDifficulty bestScore,
    required MonthlyRankingByDifficulty monthlyRanking,
    required RankingGameAchievements achievements,
    @Default(<RankingGameResult>[]) List<RankingGameResult> recentResults,
  }) = _RankingGameUserStats;

  factory RankingGameUserStats.fromJson(Map<String, dynamic> json) =>
      _$RankingGameUserStatsFromJson(json);
}

/// ユーザー統計レスポンス（軽量版・ホーム画面用）
@freezed
abstract class RankingGameStatsSummary with _$RankingGameStatsSummary {
  const factory RankingGameStatsSummary({
    required BestScoreByDifficulty bestScore,
  }) = _RankingGameStatsSummary;

  factory RankingGameStatsSummary.fromJson(Map<String, dynamic> json) =>
      _$RankingGameStatsSummaryFromJson(json);
}

/// 入力結果の種類
enum InputResultType {
  none,
  correct,
  mistake,
}

/// コンボメーター状態
@freezed
abstract class ComboMeterState with _$ComboMeterState {
  const ComboMeterState._();

  const factory ComboMeterState({
    @Default(0) int currentKeys,
    @Default(0) int currentMilestone,
    @Default(0) int totalBonusTime,
  }) = _ComboMeterState;

  /// マイルストーンのキー数
  static const List<int> milestones = [28, 59, 93, 129];

  /// 各マイルストーンでのボーナス秒数
  static const List<int> bonusSeconds = [2, 2, 5, 10];

  /// 現在の進捗率（0.0〜1.0）
  double get progress {
    if (currentMilestone >= milestones.length) return 1.0;
    final start = currentMilestone == 0 ? 0 : milestones[currentMilestone - 1];
    final end = milestones[currentMilestone];
    return (currentKeys - start) / (end - start);
  }

  /// 次のマイルストーンまでのキー数
  int get keysToNextMilestone {
    if (currentMilestone >= milestones.length) return 0;
    return milestones[currentMilestone] - currentKeys;
  }

  /// 正解キー入力時の状態更新
  ComboMeterState onCorrectKey() {
    final newKeys = currentKeys + 1;
    var newMilestone = currentMilestone;
    var newBonusTime = totalBonusTime;

    // マイルストーン達成チェック
    if (newMilestone < milestones.length && newKeys >= milestones[newMilestone]) {
      newBonusTime += bonusSeconds[newMilestone]; // 秒単位で積算
      newMilestone++;

      // 第4段階達成後はリセット
      if (newMilestone >= milestones.length) {
        return ComboMeterState(
          currentKeys: 0,
          currentMilestone: 0,
          totalBonusTime: newBonusTime,
        );
      }
    }

    return ComboMeterState(
      currentKeys: newKeys,
      currentMilestone: newMilestone,
      totalBonusTime: newBonusTime,
    );
  }

  /// ミス時の状態更新（リセット）
  ComboMeterState onMistake() {
    return ComboMeterState(
      currentKeys: 0,
      currentMilestone: 0,
      totalBonusTime: totalBonusTime,
    );
  }
}

/// ゲームセッション状態
@freezed
abstract class RankingGameSessionState with _$RankingGameSessionState {
  const RankingGameSessionState._();

  const factory RankingGameSessionState({
    required String difficulty,
    required int remainingTimeMs,
    @Default(0) int score,
    @Default(0) int correctCount,
    @Default(0) int currentCombo,
    @Default(0) int maxCombo,
    @Default(ComboMeterState()) ComboMeterState comboMeter,
    @Default(0) int characterLevel,
    RankingGameWord? currentWord,
    @Default('') String inputBuffer,
    @Default(0) int currentPosition, // 字母レベルの現在位置
    @Default(false) bool isPlaying,
    @Default(false) bool isFinished,
    @Default(<RankingGameWord>[]) List<RankingGameWord> wordQueue,
    @Default(0) int totalBonusTime,
    @Default(0) int wordIndex,
    DateTime? startTime,
    @Default(InputResultType.none) InputResultType lastInputResult,
    DateTime? lastInputTime, // アニメーション用のタイムスタンプ
    @Default(0) int totalTypedJamos, // 正解した字母数（統計用）
    @Default(0) int totalMistakes, // ミス数（正解率計算用）
    @Default(<String, int>{}) Map<String, int> mistakeCharacters, // 苦手文字統計
  }) = _RankingGameSessionState;

  /// 初期状態を作成
  factory RankingGameSessionState.initial(String difficulty) {
    return RankingGameSessionState(
      difficulty: difficulty,
      remainingTimeMs: _getInitialTime(difficulty),
    );
  }

  static int _getInitialTime(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 60000; // 60秒
      case 'intermediate':
        return 90000; // 90秒
      case 'advanced':
        return 120000; // 120秒
      default:
        return 60000;
    }
  }

  /// 経過時間（秒）
  double get elapsedSeconds {
    if (startTime == null) return 0;
    return DateTime.now().difference(startTime!).inMilliseconds / 1000;
  }

  /// 平均入力速度（文字/分）
  double get avgInputSpeed {
    if (elapsedSeconds < 1) return 0;
    // 正解した総文字数を計算する必要があるが、ここでは概算
    return correctCount * 3 * 60 / elapsedSeconds; // 1単語あたり平均3文字と仮定
  }

  /// 正解率（0.0〜1.0）
  double get accuracy {
    final totalInput = totalTypedJamos + totalMistakes;
    if (totalInput == 0) return 0.0;
    return totalTypedJamos / totalInput;
  }

  /// 総プレイ時間（ミリ秒）
  int get totalPlayTimeMs {
    if (startTime == null) return 0;
    return DateTime.now().difference(startTime!).inMilliseconds;
  }
}

/// 単語データファイルの構造
@freezed
abstract class WordDataFile with _$WordDataFile {
  const factory WordDataFile({
    required String version,
    required String difficulty,
    @Default(<RankingGameWord>[]) List<RankingGameWord> words,
  }) = _WordDataFile;

  factory WordDataFile.fromJson(Map<String, dynamic> json) =>
      _$WordDataFileFromJson(json);
}
