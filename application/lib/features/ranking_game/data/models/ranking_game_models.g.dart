// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankingGameWord _$RankingGameWordFromJson(Map<String, dynamic> json) =>
    _RankingGameWord(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
    );

Map<String, dynamic> _$RankingGameWordToJson(_RankingGameWord instance) =>
    <String, dynamic>{'word': instance.word, 'meaning': instance.meaning};

_RankingGameResult _$RankingGameResultFromJson(Map<String, dynamic> json) =>
    _RankingGameResult(
      id: json['id'] as String,
      difficulty: json['difficulty'] as String,
      score: (json['score'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      maxCombo: (json['maxCombo'] as num).toInt(),
      totalBonusTime: (json['totalBonusTime'] as num).toInt(),
      avgInputSpeed: (json['avgInputSpeed'] as num).toDouble(),
      characterLevel: (json['characterLevel'] as num).toInt(),
      playedAt: DateTime.parse(json['playedAt'] as String),
    );

Map<String, dynamic> _$RankingGameResultToJson(_RankingGameResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'difficulty': instance.difficulty,
      'score': instance.score,
      'correctCount': instance.correctCount,
      'maxCombo': instance.maxCombo,
      'totalBonusTime': instance.totalBonusTime,
      'avgInputSpeed': instance.avgInputSpeed,
      'characterLevel': instance.characterLevel,
      'playedAt': instance.playedAt.toIso8601String(),
    };

_RankingGameResultResponse _$RankingGameResultResponseFromJson(
  Map<String, dynamic> json,
) => _RankingGameResultResponse(
  id: json['id'] as String,
  difficulty: json['difficulty'] as String,
  score: (json['score'] as num).toInt(),
  correctCount: (json['correctCount'] as num).toInt(),
  maxCombo: (json['maxCombo'] as num).toInt(),
  totalBonusTime: (json['totalBonusTime'] as num).toInt(),
  avgInputSpeed: (json['avgInputSpeed'] as num).toDouble(),
  characterLevel: (json['characterLevel'] as num).toInt(),
  playedAt: DateTime.parse(json['playedAt'] as String),
  ranking: RankingInfo.fromJson(json['ranking'] as Map<String, dynamic>),
  achievements:
      (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$RankingGameResultResponseToJson(
  _RankingGameResultResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'difficulty': instance.difficulty,
  'score': instance.score,
  'correctCount': instance.correctCount,
  'maxCombo': instance.maxCombo,
  'totalBonusTime': instance.totalBonusTime,
  'avgInputSpeed': instance.avgInputSpeed,
  'characterLevel': instance.characterLevel,
  'playedAt': instance.playedAt.toIso8601String(),
  'ranking': instance.ranking,
  'achievements': instance.achievements,
};

_RankingInfo _$RankingInfoFromJson(Map<String, dynamic> json) => _RankingInfo(
  position: (json['position'] as num).toInt(),
  previousPosition: (json['previousPosition'] as num?)?.toInt(),
  totalParticipants: (json['totalParticipants'] as num).toInt(),
  isNewBest: json['isNewBest'] as bool,
);

Map<String, dynamic> _$RankingInfoToJson(_RankingInfo instance) =>
    <String, dynamic>{
      'position': instance.position,
      'previousPosition': instance.previousPosition,
      'totalParticipants': instance.totalParticipants,
      'isNewBest': instance.isNewBest,
    };

_RankingEntry _$RankingEntryFromJson(Map<String, dynamic> json) =>
    _RankingEntry(
      position: (json['position'] as num).toInt(),
      user: DiaryUserSummary.fromJson(json['user'] as Map<String, dynamic>),
      score: (json['score'] as num).toInt(),
      characterLevel: (json['characterLevel'] as num).toInt(),
      playCount: (json['playCount'] as num).toInt(),
      maxCombo: (json['maxCombo'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RankingEntryToJson(_RankingEntry instance) =>
    <String, dynamic>{
      'position': instance.position,
      'user': instance.user,
      'score': instance.score,
      'characterLevel': instance.characterLevel,
      'playCount': instance.playCount,
      'maxCombo': instance.maxCombo,
    };

_RankingPeriodInfo _$RankingPeriodInfoFromJson(Map<String, dynamic> json) =>
    _RankingPeriodInfo(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$RankingPeriodInfoToJson(_RankingPeriodInfo instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

_MyRankingInfo _$MyRankingInfoFromJson(Map<String, dynamic> json) =>
    _MyRankingInfo(
      position: (json['position'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      characterLevel: (json['characterLevel'] as num).toInt(),
    );

Map<String, dynamic> _$MyRankingInfoToJson(_MyRankingInfo instance) =>
    <String, dynamic>{
      'position': instance.position,
      'score': instance.score,
      'characterLevel': instance.characterLevel,
    };

_RankingDataResponse _$RankingDataResponseFromJson(Map<String, dynamic> json) =>
    _RankingDataResponse(
      period: RankingPeriodInfo.fromJson(
        json['period'] as Map<String, dynamic>,
      ),
      rankings:
          (json['rankings'] as List<dynamic>?)
              ?.map((e) => RankingEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RankingEntry>[],
      myRanking: json['myRanking'] == null
          ? null
          : MyRankingInfo.fromJson(json['myRanking'] as Map<String, dynamic>),
      totalParticipants: (json['totalParticipants'] as num).toInt(),
    );

Map<String, dynamic> _$RankingDataResponseToJson(
  _RankingDataResponse instance,
) => <String, dynamic>{
  'period': instance.period,
  'rankings': instance.rankings,
  'myRanking': instance.myRanking,
  'totalParticipants': instance.totalParticipants,
};

_BestScoreByDifficulty _$BestScoreByDifficultyFromJson(
  Map<String, dynamic> json,
) => _BestScoreByDifficulty(
  all: (json['all'] as num).toInt(),
  beginner: (json['beginner'] as num).toInt(),
  intermediate: (json['intermediate'] as num).toInt(),
  advanced: (json['advanced'] as num).toInt(),
);

Map<String, dynamic> _$BestScoreByDifficultyToJson(
  _BestScoreByDifficulty instance,
) => <String, dynamic>{
  'all': instance.all,
  'beginner': instance.beginner,
  'intermediate': instance.intermediate,
  'advanced': instance.advanced,
};

_MonthlyRankingByDifficulty _$MonthlyRankingByDifficultyFromJson(
  Map<String, dynamic> json,
) => _MonthlyRankingByDifficulty(
  all: (json['all'] as num?)?.toInt(),
  beginner: (json['beginner'] as num?)?.toInt(),
  intermediate: (json['intermediate'] as num?)?.toInt(),
  advanced: (json['advanced'] as num?)?.toInt(),
);

Map<String, dynamic> _$MonthlyRankingByDifficultyToJson(
  _MonthlyRankingByDifficulty instance,
) => <String, dynamic>{
  'all': instance.all,
  'beginner': instance.beginner,
  'intermediate': instance.intermediate,
  'advanced': instance.advanced,
};

_RankingGameAchievements _$RankingGameAchievementsFromJson(
  Map<String, dynamic> json,
) => _RankingGameAchievements(
  maxCombo: (json['maxCombo'] as num).toInt(),
  maxCharacterLevel: (json['maxCharacterLevel'] as num).toInt(),
  totalBonusTimeEarned: (json['totalBonusTimeEarned'] as num).toInt(),
);

Map<String, dynamic> _$RankingGameAchievementsToJson(
  _RankingGameAchievements instance,
) => <String, dynamic>{
  'maxCombo': instance.maxCombo,
  'maxCharacterLevel': instance.maxCharacterLevel,
  'totalBonusTimeEarned': instance.totalBonusTimeEarned,
};

_RankingGameUserStats _$RankingGameUserStatsFromJson(
  Map<String, dynamic> json,
) => _RankingGameUserStats(
  totalPlays: (json['totalPlays'] as num).toInt(),
  bestScore: BestScoreByDifficulty.fromJson(
    json['bestScore'] as Map<String, dynamic>,
  ),
  monthlyRanking: MonthlyRankingByDifficulty.fromJson(
    json['monthlyRanking'] as Map<String, dynamic>,
  ),
  achievements: RankingGameAchievements.fromJson(
    json['achievements'] as Map<String, dynamic>,
  ),
  recentResults:
      (json['recentResults'] as List<dynamic>?)
          ?.map((e) => RankingGameResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RankingGameResult>[],
);

Map<String, dynamic> _$RankingGameUserStatsToJson(
  _RankingGameUserStats instance,
) => <String, dynamic>{
  'totalPlays': instance.totalPlays,
  'bestScore': instance.bestScore,
  'monthlyRanking': instance.monthlyRanking,
  'achievements': instance.achievements,
  'recentResults': instance.recentResults,
};

_RankingGameStatsSummary _$RankingGameStatsSummaryFromJson(
  Map<String, dynamic> json,
) => _RankingGameStatsSummary(
  bestScore: BestScoreByDifficulty.fromJson(
    json['bestScore'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RankingGameStatsSummaryToJson(
  _RankingGameStatsSummary instance,
) => <String, dynamic>{'bestScore': instance.bestScore};

_WordDataFile _$WordDataFileFromJson(Map<String, dynamic> json) =>
    _WordDataFile(
      version: json['version'] as String,
      difficulty: json['difficulty'] as String,
      words:
          (json['words'] as List<dynamic>?)
              ?.map((e) => RankingGameWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RankingGameWord>[],
    );

Map<String, dynamic> _$WordDataFileToJson(_WordDataFile instance) =>
    <String, dynamic>{
      'version': instance.version,
      'difficulty': instance.difficulty,
      'words': instance.words,
    };
