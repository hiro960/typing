// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lessonRepository)
const lessonRepositoryProvider = LessonRepositoryProvider._();

final class LessonRepositoryProvider
    extends
        $FunctionalProvider<
          LessonRepository,
          LessonRepository,
          LessonRepository
        >
    with $Provider<LessonRepository> {
  const LessonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonRepositoryHash();

  @$internal
  @override
  $ProviderElement<LessonRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LessonRepository create(Ref ref) {
    return lessonRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonRepository>(value),
    );
  }
}

String _$lessonRepositoryHash() => r'73fdceb6fd4ab36d1782e20f4e565893d4030e88';

@ProviderFor(lessonIndex)
const lessonIndexProvider = LessonIndexProvider._();

final class LessonIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<LessonIndex>,
          LessonIndex,
          FutureOr<LessonIndex>
        >
    with $FutureModifier<LessonIndex>, $FutureProvider<LessonIndex> {
  const LessonIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonIndexHash();

  @$internal
  @override
  $FutureProviderElement<LessonIndex> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LessonIndex> create(Ref ref) {
    return lessonIndex(ref);
  }
}

String _$lessonIndexHash() => r'3d34b0503ab3ef2c9feec5894d7cf92cddf6a83f';

@ProviderFor(lessonCatalog)
const lessonCatalogProvider = LessonCatalogProvider._();

final class LessonCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<LessonLevel, List<LessonMeta>>>,
          Map<LessonLevel, List<LessonMeta>>,
          FutureOr<Map<LessonLevel, List<LessonMeta>>>
        >
    with
        $FutureModifier<Map<LessonLevel, List<LessonMeta>>>,
        $FutureProvider<Map<LessonLevel, List<LessonMeta>>> {
  const LessonCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonCatalogHash();

  @$internal
  @override
  $FutureProviderElement<Map<LessonLevel, List<LessonMeta>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<LessonLevel, List<LessonMeta>>> create(Ref ref) {
    return lessonCatalog(ref);
  }
}

String _$lessonCatalogHash() => r'ce576ba1dd50fa9960d27ef9df5f4be10578dff8';

@ProviderFor(lessonsByLevel)
const lessonsByLevelProvider = LessonsByLevelFamily._();

final class LessonsByLevelProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LessonMeta>>,
          List<LessonMeta>,
          FutureOr<List<LessonMeta>>
        >
    with $FutureModifier<List<LessonMeta>>, $FutureProvider<List<LessonMeta>> {
  const LessonsByLevelProvider._({
    required LessonsByLevelFamily super.from,
    required LessonLevel super.argument,
  }) : super(
         retry: null,
         name: r'lessonsByLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonsByLevelHash();

  @override
  String toString() {
    return r'lessonsByLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LessonMeta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LessonMeta>> create(Ref ref) {
    final argument = this.argument as LessonLevel;
    return lessonsByLevel(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonsByLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonsByLevelHash() => r'bc6a0c738b3fb5f60abb1153c6b499dcd64471bb';

final class LessonsByLevelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LessonMeta>>, LessonLevel> {
  const LessonsByLevelFamily._()
    : super(
        retry: null,
        name: r'lessonsByLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonsByLevelProvider call(LessonLevel level) =>
      LessonsByLevelProvider._(argument: level, from: this);

  @override
  String toString() => r'lessonsByLevelProvider';
}

@ProviderFor(lessonDetail)
const lessonDetailProvider = LessonDetailFamily._();

final class LessonDetailProvider
    extends $FunctionalProvider<AsyncValue<Lesson>, Lesson, FutureOr<Lesson>>
    with $FutureModifier<Lesson>, $FutureProvider<Lesson> {
  const LessonDetailProvider._({
    required LessonDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonDetailHash();

  @override
  String toString() {
    return r'lessonDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Lesson> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Lesson> create(Ref ref) {
    final argument = this.argument as String;
    return lessonDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonDetailHash() => r'4767fd20e7e39b981ae197164436627ae2dcaa29';

final class LessonDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Lesson>, String> {
  const LessonDetailFamily._()
    : super(
        retry: null,
        name: r'lessonDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonDetailProvider call(String lessonId) =>
      LessonDetailProvider._(argument: lessonId, from: this);

  @override
  String toString() => r'lessonDetailProvider';
}
