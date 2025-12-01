// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングデータプロバイダー

@ProviderFor(rankingData)
const rankingDataProvider = RankingDataFamily._();

/// ランキングデータプロバイダー

final class RankingDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<RankingDataResponse>,
          RankingDataResponse,
          FutureOr<RankingDataResponse>
        >
    with
        $FutureModifier<RankingDataResponse>,
        $FutureProvider<RankingDataResponse> {
  /// ランキングデータプロバイダー
  const RankingDataProvider._({
    required RankingDataFamily super.from,
    required ({String difficulty, String period, bool followingOnly})
    super.argument,
  }) : super(
         retry: null,
         name: r'rankingDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rankingDataHash();

  @override
  String toString() {
    return r'rankingDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<RankingDataResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RankingDataResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({String difficulty, String period, bool followingOnly});
    return rankingData(
      ref,
      difficulty: argument.difficulty,
      period: argument.period,
      followingOnly: argument.followingOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RankingDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rankingDataHash() => r'66f4829fa66abb6ff183417b24ded5383f8b75ed';

/// ランキングデータプロバイダー

final class RankingDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<RankingDataResponse>,
          ({String difficulty, String period, bool followingOnly})
        > {
  const RankingDataFamily._()
    : super(
        retry: null,
        name: r'rankingDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ランキングデータプロバイダー

  RankingDataProvider call({
    String difficulty = 'all',
    String period = 'monthly',
    bool followingOnly = false,
  }) => RankingDataProvider._(
    argument: (
      difficulty: difficulty,
      period: period,
      followingOnly: followingOnly,
    ),
    from: this,
  );

  @override
  String toString() => r'rankingDataProvider';
}

/// 自分の統計プロバイダー（詳細版・ランキング画面用）

@ProviderFor(myRankingStats)
const myRankingStatsProvider = MyRankingStatsProvider._();

/// 自分の統計プロバイダー（詳細版・ランキング画面用）

final class MyRankingStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RankingGameUserStats>,
          RankingGameUserStats,
          FutureOr<RankingGameUserStats>
        >
    with
        $FutureModifier<RankingGameUserStats>,
        $FutureProvider<RankingGameUserStats> {
  /// 自分の統計プロバイダー（詳細版・ランキング画面用）
  const MyRankingStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRankingStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRankingStatsHash();

  @$internal
  @override
  $FutureProviderElement<RankingGameUserStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RankingGameUserStats> create(Ref ref) {
    return myRankingStats(ref);
  }
}

String _$myRankingStatsHash() => r'01b96297da6cfd450c940c9bd45820833942584a';

/// 自分の統計プロバイダー（軽量版・ホーム画面用）
/// bestScoreのみを高速に取得

@ProviderFor(myRankingStatsSummary)
const myRankingStatsSummaryProvider = MyRankingStatsSummaryProvider._();

/// 自分の統計プロバイダー（軽量版・ホーム画面用）
/// bestScoreのみを高速に取得

final class MyRankingStatsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<RankingGameStatsSummary>,
          RankingGameStatsSummary,
          FutureOr<RankingGameStatsSummary>
        >
    with
        $FutureModifier<RankingGameStatsSummary>,
        $FutureProvider<RankingGameStatsSummary> {
  /// 自分の統計プロバイダー（軽量版・ホーム画面用）
  /// bestScoreのみを高速に取得
  const MyRankingStatsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRankingStatsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRankingStatsSummaryHash();

  @$internal
  @override
  $FutureProviderElement<RankingGameStatsSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RankingGameStatsSummary> create(Ref ref) {
    return myRankingStatsSummary(ref);
  }
}

String _$myRankingStatsSummaryHash() =>
    r'3cbdf473a1f58f1f015a2459bd7a51736076e4c1';

/// 難易度別ベストスコアプロバイダー

@ProviderFor(bestScores)
const bestScoresProvider = BestScoresProvider._();

/// 難易度別ベストスコアプロバイダー

final class BestScoresProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// 難易度別ベストスコアプロバイダー
  const BestScoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bestScoresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bestScoresHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return bestScores(ref);
  }
}

String _$bestScoresHash() => r'4570a36552b8394e5fb63ccbe30023211eeb79f1';
