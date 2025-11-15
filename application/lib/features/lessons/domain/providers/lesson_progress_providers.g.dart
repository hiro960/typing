// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lessonProgressRepository)
const lessonProgressRepositoryProvider = LessonProgressRepositoryProvider._();

final class LessonProgressRepositoryProvider
    extends
        $FunctionalProvider<
          LessonProgressRepository,
          LessonProgressRepository,
          LessonProgressRepository
        >
    with $Provider<LessonProgressRepository> {
  const LessonProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonProgressRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<LessonProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LessonProgressRepository create(Ref ref) {
    return lessonProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonProgressRepository>(value),
    );
  }
}

String _$lessonProgressRepositoryHash() =>
    r'62ec4adbf0040ba2439d54e9ab461a853b3322a9';

@ProviderFor(lessonStats)
const lessonStatsProvider = LessonStatsFamily._();

final class LessonStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<LessonStatsSummary>,
          LessonStatsSummary,
          FutureOr<LessonStatsSummary>
        >
    with
        $FutureModifier<LessonStatsSummary>,
        $FutureProvider<LessonStatsSummary> {
  const LessonStatsProvider._({
    required LessonStatsFamily super.from,
    required LessonLevel? super.argument,
  }) : super(
         retry: null,
         name: r'lessonStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonStatsHash();

  @override
  String toString() {
    return r'lessonStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LessonStatsSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LessonStatsSummary> create(Ref ref) {
    final argument = this.argument as LessonLevel?;
    return lessonStats(ref, level: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonStatsHash() => r'a5169428375ed21e50e8e235e2bb77cb2d9789bc';

final class LessonStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LessonStatsSummary>, LessonLevel?> {
  const LessonStatsFamily._()
    : super(
        retry: null,
        name: r'lessonStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonStatsProvider call({LessonLevel? level}) =>
      LessonStatsProvider._(argument: level, from: this);

  @override
  String toString() => r'lessonStatsProvider';
}

@ProviderFor(LessonProgressController)
const lessonProgressControllerProvider = LessonProgressControllerProvider._();

final class LessonProgressControllerProvider
    extends
        $AsyncNotifierProvider<
          LessonProgressController,
          Map<String, LessonProgress>
        > {
  const LessonProgressControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonProgressControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonProgressControllerHash();

  @$internal
  @override
  LessonProgressController create() => LessonProgressController();
}

String _$lessonProgressControllerHash() =>
    r'92580f578bf1944f0011f9fbcc6262d3169707f7';

abstract class _$LessonProgressController
    extends $AsyncNotifier<Map<String, LessonProgress>> {
  FutureOr<Map<String, LessonProgress>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, LessonProgress>>,
              Map<String, LessonProgress>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, LessonProgress>>,
                Map<String, LessonProgress>
              >,
              AsyncValue<Map<String, LessonProgress>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
