// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pronunciation_ranking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ランキングデータプロバイダー

@ProviderFor(pronunciationRankingData)
const pronunciationRankingDataProvider = PronunciationRankingDataFamily._();

/// ランキングデータプロバイダー

final class PronunciationRankingDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<PronunciationRankingDataResponse>,
          PronunciationRankingDataResponse,
          FutureOr<PronunciationRankingDataResponse>
        >
    with
        $FutureModifier<PronunciationRankingDataResponse>,
        $FutureProvider<PronunciationRankingDataResponse> {
  /// ランキングデータプロバイダー
  const PronunciationRankingDataProvider._({
    required PronunciationRankingDataFamily super.from,
    required ({String difficulty, String period, bool followingOnly})
    super.argument,
  }) : super(
         retry: null,
         name: r'pronunciationRankingDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pronunciationRankingDataHash();

  @override
  String toString() {
    return r'pronunciationRankingDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PronunciationRankingDataResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PronunciationRankingDataResponse> create(Ref ref) {
    final argument =
        this.argument
            as ({String difficulty, String period, bool followingOnly});
    return pronunciationRankingData(
      ref,
      difficulty: argument.difficulty,
      period: argument.period,
      followingOnly: argument.followingOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PronunciationRankingDataProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pronunciationRankingDataHash() =>
    r'53f17e82829dfb2bd3c35e1e133e1e9dc0fa6d48';

/// ランキングデータプロバイダー

final class PronunciationRankingDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PronunciationRankingDataResponse>,
          ({String difficulty, String period, bool followingOnly})
        > {
  const PronunciationRankingDataFamily._()
    : super(
        retry: null,
        name: r'pronunciationRankingDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ランキングデータプロバイダー

  PronunciationRankingDataProvider call({
    String difficulty = 'all',
    String period = 'monthly',
    bool followingOnly = false,
  }) => PronunciationRankingDataProvider._(
    argument: (
      difficulty: difficulty,
      period: period,
      followingOnly: followingOnly,
    ),
    from: this,
  );

  @override
  String toString() => r'pronunciationRankingDataProvider';
}

/// 自分の統計プロバイダー（詳細版・ランキング画面用）

@ProviderFor(myPronunciationStats)
const myPronunciationStatsProvider = MyPronunciationStatsProvider._();

/// 自分の統計プロバイダー（詳細版・ランキング画面用）

final class MyPronunciationStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PronunciationGameUserStats>,
          PronunciationGameUserStats,
          FutureOr<PronunciationGameUserStats>
        >
    with
        $FutureModifier<PronunciationGameUserStats>,
        $FutureProvider<PronunciationGameUserStats> {
  /// 自分の統計プロバイダー（詳細版・ランキング画面用）
  const MyPronunciationStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPronunciationStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPronunciationStatsHash();

  @$internal
  @override
  $FutureProviderElement<PronunciationGameUserStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PronunciationGameUserStats> create(Ref ref) {
    return myPronunciationStats(ref);
  }
}

String _$myPronunciationStatsHash() =>
    r'89578c4ee4c0bd612376f6f5f48b6b072d7c7b82';

/// 自分の統計プロバイダー（軽量版・ホーム画面用）

@ProviderFor(myPronunciationStatsSummary)
const myPronunciationStatsSummaryProvider =
    MyPronunciationStatsSummaryProvider._();

/// 自分の統計プロバイダー（軽量版・ホーム画面用）

final class MyPronunciationStatsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<PronunciationGameStatsSummary>,
          PronunciationGameStatsSummary,
          FutureOr<PronunciationGameStatsSummary>
        >
    with
        $FutureModifier<PronunciationGameStatsSummary>,
        $FutureProvider<PronunciationGameStatsSummary> {
  /// 自分の統計プロバイダー（軽量版・ホーム画面用）
  const MyPronunciationStatsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPronunciationStatsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPronunciationStatsSummaryHash();

  @$internal
  @override
  $FutureProviderElement<PronunciationGameStatsSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PronunciationGameStatsSummary> create(Ref ref) {
    return myPronunciationStatsSummary(ref);
  }
}

String _$myPronunciationStatsSummaryHash() =>
    r'422d3b317eafe503ca4796f0a8ab7a014995e8fb';

/// 難易度別ベストスコアプロバイダー

@ProviderFor(pronunciationBestScores)
const pronunciationBestScoresProvider = PronunciationBestScoresProvider._();

/// 難易度別ベストスコアプロバイダー

final class PronunciationBestScoresProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// 難易度別ベストスコアプロバイダー
  const PronunciationBestScoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pronunciationBestScoresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pronunciationBestScoresHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return pronunciationBestScores(ref);
  }
}

String _$pronunciationBestScoresHash() =>
    r'92eff9a474d287f678144d49ac5dc4368165dfed';
