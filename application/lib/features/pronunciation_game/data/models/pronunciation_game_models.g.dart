// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PronunciationGameWord _$PronunciationGameWordFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameWord(
  word: json['word'] as String,
  meaning: json['meaning'] as String,
);

Map<String, dynamic> _$PronunciationGameWordToJson(
  _PronunciationGameWord instance,
) => <String, dynamic>{'word': instance.word, 'meaning': instance.meaning};

_PronunciationGameResult _$PronunciationGameResultFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameResult(
  id: json['id'] as String,
  difficulty: json['difficulty'] as String,
  score: (json['score'] as num).toInt(),
  correctCount: (json['correctCount'] as num).toInt(),
  maxCombo: (json['maxCombo'] as num).toInt(),
  totalBonusTime: (json['totalBonusTime'] as num).toInt(),
  characterLevel: (json['characterLevel'] as num).toInt(),
  playedAt: DateTime.parse(json['playedAt'] as String),
);

Map<String, dynamic> _$PronunciationGameResultToJson(
  _PronunciationGameResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'difficulty': instance.difficulty,
  'score': instance.score,
  'correctCount': instance.correctCount,
  'maxCombo': instance.maxCombo,
  'totalBonusTime': instance.totalBonusTime,
  'characterLevel': instance.characterLevel,
  'playedAt': instance.playedAt.toIso8601String(),
};

_PronunciationGameResultResponse _$PronunciationGameResultResponseFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameResultResponse(
  id: json['id'] as String,
  difficulty: json['difficulty'] as String,
  score: (json['score'] as num).toInt(),
  correctCount: (json['correctCount'] as num).toInt(),
  maxCombo: (json['maxCombo'] as num).toInt(),
  totalBonusTime: (json['totalBonusTime'] as num).toInt(),
  characterLevel: (json['characterLevel'] as num).toInt(),
  playedAt: DateTime.parse(json['playedAt'] as String),
  ranking: PronunciationRankingInfo.fromJson(
    json['ranking'] as Map<String, dynamic>,
  ),
  achievements:
      (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$PronunciationGameResultResponseToJson(
  _PronunciationGameResultResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'difficulty': instance.difficulty,
  'score': instance.score,
  'correctCount': instance.correctCount,
  'maxCombo': instance.maxCombo,
  'totalBonusTime': instance.totalBonusTime,
  'characterLevel': instance.characterLevel,
  'playedAt': instance.playedAt.toIso8601String(),
  'ranking': instance.ranking,
  'achievements': instance.achievements,
};

_PronunciationRankingInfo _$PronunciationRankingInfoFromJson(
  Map<String, dynamic> json,
) => _PronunciationRankingInfo(
  position: (json['position'] as num).toInt(),
  previousPosition: (json['previousPosition'] as num?)?.toInt(),
  totalParticipants: (json['totalParticipants'] as num).toInt(),
  isNewBest: json['isNewBest'] as bool,
);

Map<String, dynamic> _$PronunciationRankingInfoToJson(
  _PronunciationRankingInfo instance,
) => <String, dynamic>{
  'position': instance.position,
  'previousPosition': instance.previousPosition,
  'totalParticipants': instance.totalParticipants,
  'isNewBest': instance.isNewBest,
};

_PronunciationRankingEntry _$PronunciationRankingEntryFromJson(
  Map<String, dynamic> json,
) => _PronunciationRankingEntry(
  position: (json['position'] as num).toInt(),
  user: DiaryUserSummary.fromJson(json['user'] as Map<String, dynamic>),
  score: (json['score'] as num).toInt(),
  characterLevel: (json['characterLevel'] as num).toInt(),
  playCount: (json['playCount'] as num).toInt(),
  maxCombo: (json['maxCombo'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PronunciationRankingEntryToJson(
  _PronunciationRankingEntry instance,
) => <String, dynamic>{
  'position': instance.position,
  'user': instance.user,
  'score': instance.score,
  'characterLevel': instance.characterLevel,
  'playCount': instance.playCount,
  'maxCombo': instance.maxCombo,
};

_PronunciationRankingPeriodInfo _$PronunciationRankingPeriodInfoFromJson(
  Map<String, dynamic> json,
) => _PronunciationRankingPeriodInfo(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
);

Map<String, dynamic> _$PronunciationRankingPeriodInfoToJson(
  _PronunciationRankingPeriodInfo instance,
) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
};

_MyPronunciationRankingInfo _$MyPronunciationRankingInfoFromJson(
  Map<String, dynamic> json,
) => _MyPronunciationRankingInfo(
  position: (json['position'] as num).toInt(),
  score: (json['score'] as num).toInt(),
  characterLevel: (json['characterLevel'] as num).toInt(),
);

Map<String, dynamic> _$MyPronunciationRankingInfoToJson(
  _MyPronunciationRankingInfo instance,
) => <String, dynamic>{
  'position': instance.position,
  'score': instance.score,
  'characterLevel': instance.characterLevel,
};

_PronunciationRankingDataResponse _$PronunciationRankingDataResponseFromJson(
  Map<String, dynamic> json,
) => _PronunciationRankingDataResponse(
  period: PronunciationRankingPeriodInfo.fromJson(
    json['period'] as Map<String, dynamic>,
  ),
  rankings:
      (json['rankings'] as List<dynamic>?)
          ?.map(
            (e) =>
                PronunciationRankingEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PronunciationRankingEntry>[],
  myRanking: json['myRanking'] == null
      ? null
      : MyPronunciationRankingInfo.fromJson(
          json['myRanking'] as Map<String, dynamic>,
        ),
  totalParticipants: (json['totalParticipants'] as num).toInt(),
);

Map<String, dynamic> _$PronunciationRankingDataResponseToJson(
  _PronunciationRankingDataResponse instance,
) => <String, dynamic>{
  'period': instance.period,
  'rankings': instance.rankings,
  'myRanking': instance.myRanking,
  'totalParticipants': instance.totalParticipants,
};

_PronunciationBestScoreByDifficulty
_$PronunciationBestScoreByDifficultyFromJson(Map<String, dynamic> json) =>
    _PronunciationBestScoreByDifficulty(
      all: (json['all'] as num).toInt(),
      beginner: (json['beginner'] as num).toInt(),
      intermediate: (json['intermediate'] as num).toInt(),
      advanced: (json['advanced'] as num).toInt(),
    );

Map<String, dynamic> _$PronunciationBestScoreByDifficultyToJson(
  _PronunciationBestScoreByDifficulty instance,
) => <String, dynamic>{
  'all': instance.all,
  'beginner': instance.beginner,
  'intermediate': instance.intermediate,
  'advanced': instance.advanced,
};

_PronunciationMonthlyRankingByDifficulty
_$PronunciationMonthlyRankingByDifficultyFromJson(Map<String, dynamic> json) =>
    _PronunciationMonthlyRankingByDifficulty(
      all: (json['all'] as num?)?.toInt(),
      beginner: (json['beginner'] as num?)?.toInt(),
      intermediate: (json['intermediate'] as num?)?.toInt(),
      advanced: (json['advanced'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PronunciationMonthlyRankingByDifficultyToJson(
  _PronunciationMonthlyRankingByDifficulty instance,
) => <String, dynamic>{
  'all': instance.all,
  'beginner': instance.beginner,
  'intermediate': instance.intermediate,
  'advanced': instance.advanced,
};

_PronunciationGameAchievements _$PronunciationGameAchievementsFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameAchievements(
  maxCombo: (json['maxCombo'] as num).toInt(),
  maxCharacterLevel: (json['maxCharacterLevel'] as num).toInt(),
  totalBonusTimeEarned: (json['totalBonusTimeEarned'] as num).toInt(),
);

Map<String, dynamic> _$PronunciationGameAchievementsToJson(
  _PronunciationGameAchievements instance,
) => <String, dynamic>{
  'maxCombo': instance.maxCombo,
  'maxCharacterLevel': instance.maxCharacterLevel,
  'totalBonusTimeEarned': instance.totalBonusTimeEarned,
};

_PronunciationGameUserStats _$PronunciationGameUserStatsFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameUserStats(
  totalPlays: (json['totalPlays'] as num).toInt(),
  bestScore: PronunciationBestScoreByDifficulty.fromJson(
    json['bestScore'] as Map<String, dynamic>,
  ),
  monthlyRanking: PronunciationMonthlyRankingByDifficulty.fromJson(
    json['monthlyRanking'] as Map<String, dynamic>,
  ),
  achievements: PronunciationGameAchievements.fromJson(
    json['achievements'] as Map<String, dynamic>,
  ),
  recentResults:
      (json['recentResults'] as List<dynamic>?)
          ?.map(
            (e) => PronunciationGameResult.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PronunciationGameResult>[],
);

Map<String, dynamic> _$PronunciationGameUserStatsToJson(
  _PronunciationGameUserStats instance,
) => <String, dynamic>{
  'totalPlays': instance.totalPlays,
  'bestScore': instance.bestScore,
  'monthlyRanking': instance.monthlyRanking,
  'achievements': instance.achievements,
  'recentResults': instance.recentResults,
};

_PronunciationGameStatsSummary _$PronunciationGameStatsSummaryFromJson(
  Map<String, dynamic> json,
) => _PronunciationGameStatsSummary(
  bestScore: PronunciationBestScoreByDifficulty.fromJson(
    json['bestScore'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PronunciationGameStatsSummaryToJson(
  _PronunciationGameStatsSummary instance,
) => <String, dynamic>{'bestScore': instance.bestScore};

_PronunciationWordDataFile _$PronunciationWordDataFileFromJson(
  Map<String, dynamic> json,
) => _PronunciationWordDataFile(
  version: json['version'] as String,
  difficulty: json['difficulty'] as String,
  words:
      (json['words'] as List<dynamic>?)
          ?.map(
            (e) => PronunciationGameWord.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PronunciationGameWord>[],
);

Map<String, dynamic> _$PronunciationWordDataFileToJson(
  _PronunciationWordDataFile instance,
) => <String, dynamic>{
  'version': instance.version,
  'difficulty': instance.difficulty,
  'words': instance.words,
};
