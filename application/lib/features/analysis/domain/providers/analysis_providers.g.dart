// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analysisRepository)
const analysisRepositoryProvider = AnalysisRepositoryProvider._();

final class AnalysisRepositoryProvider
    extends
        $FunctionalProvider<
          AnalysisRepository,
          AnalysisRepository,
          AnalysisRepository
        >
    with $Provider<AnalysisRepository> {
  const AnalysisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analysisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analysisRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalysisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalysisRepository create(Ref ref) {
    return analysisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalysisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalysisRepository>(value),
    );
  }
}

String _$analysisRepositoryHash() =>
    r'3ecb83e9c2719492b23da9a6c195c1cd3cb48653';

@ProviderFor(analysisDashboard)
const analysisDashboardProvider = AnalysisDashboardFamily._();

final class AnalysisDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalysisDashboard>,
          AnalysisDashboard,
          FutureOr<AnalysisDashboard>
        >
    with
        $FutureModifier<AnalysisDashboard>,
        $FutureProvider<AnalysisDashboard> {
  const AnalysisDashboardProvider._({
    required AnalysisDashboardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'analysisDashboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analysisDashboardHash();

  @override
  String toString() {
    return r'analysisDashboardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AnalysisDashboard> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalysisDashboard> create(Ref ref) {
    final argument = this.argument as String;
    return analysisDashboard(ref, period: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalysisDashboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analysisDashboardHash() => r'a250a3cfbfe314525c43c94944358b574d124954';

final class AnalysisDashboardFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AnalysisDashboard>, String> {
  const AnalysisDashboardFamily._()
    : super(
        retry: null,
        name: r'analysisDashboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalysisDashboardProvider call({String period = 'month'}) =>
      AnalysisDashboardProvider._(argument: period, from: this);

  @override
  String toString() => r'analysisDashboardProvider';
}
