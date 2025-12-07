// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(grammarRepository)
const grammarRepositoryProvider = GrammarRepositoryProvider._();

final class GrammarRepositoryProvider
    extends
        $FunctionalProvider<
          GrammarRepository,
          GrammarRepository,
          GrammarRepository
        >
    with $Provider<GrammarRepository> {
  const GrammarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarRepositoryHash();

  @$internal
  @override
  $ProviderElement<GrammarRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GrammarRepository create(Ref ref) {
    return grammarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrammarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrammarRepository>(value),
    );
  }
}

String _$grammarRepositoryHash() => r'cbacd552938360f94f6a61e396bcf15f956c734b';

@ProviderFor(grammarFavoriteRepository)
const grammarFavoriteRepositoryProvider = GrammarFavoriteRepositoryProvider._();

final class GrammarFavoriteRepositoryProvider
    extends
        $FunctionalProvider<
          GrammarFavoriteRepository,
          GrammarFavoriteRepository,
          GrammarFavoriteRepository
        >
    with $Provider<GrammarFavoriteRepository> {
  const GrammarFavoriteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarFavoriteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarFavoriteRepositoryHash();

  @$internal
  @override
  $ProviderElement<GrammarFavoriteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GrammarFavoriteRepository create(Ref ref) {
    return grammarFavoriteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrammarFavoriteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrammarFavoriteRepository>(value),
    );
  }
}

String _$grammarFavoriteRepositoryHash() =>
    r'668e1b93fb484879ef788f88a9eef89ec10f6f7e';

@ProviderFor(grammarIndex)
const grammarIndexProvider = GrammarIndexProvider._();

final class GrammarIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<GrammarIndex>,
          GrammarIndex,
          FutureOr<GrammarIndex>
        >
    with $FutureModifier<GrammarIndex>, $FutureProvider<GrammarIndex> {
  const GrammarIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarIndexHash();

  @$internal
  @override
  $FutureProviderElement<GrammarIndex> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GrammarIndex> create(Ref ref) {
    return grammarIndex(ref);
  }
}

String _$grammarIndexHash() => r'cb1d3ef0fbbd2f489202ca7c0d37d0b58764f97d';

@ProviderFor(grammarsByCategory)
const grammarsByCategoryProvider = GrammarsByCategoryFamily._();

final class GrammarsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GrammarMeta>>,
          List<GrammarMeta>,
          FutureOr<List<GrammarMeta>>
        >
    with
        $FutureModifier<List<GrammarMeta>>,
        $FutureProvider<List<GrammarMeta>> {
  const GrammarsByCategoryProvider._({
    required GrammarsByCategoryFamily super.from,
    required GrammarCategory super.argument,
  }) : super(
         retry: null,
         name: r'grammarsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$grammarsByCategoryHash();

  @override
  String toString() {
    return r'grammarsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GrammarMeta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GrammarMeta>> create(Ref ref) {
    final argument = this.argument as GrammarCategory;
    return grammarsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GrammarsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$grammarsByCategoryHash() =>
    r'76146b7dfb90e349c6f8ff19dfe14874edb7f693';

final class GrammarsByCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GrammarMeta>>,
          GrammarCategory
        > {
  const GrammarsByCategoryFamily._()
    : super(
        retry: null,
        name: r'grammarsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GrammarsByCategoryProvider call(GrammarCategory category) =>
      GrammarsByCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'grammarsByCategoryProvider';
}

@ProviderFor(grammarDetail)
const grammarDetailProvider = GrammarDetailFamily._();

final class GrammarDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<GrammarDetail>,
          GrammarDetail,
          FutureOr<GrammarDetail>
        >
    with $FutureModifier<GrammarDetail>, $FutureProvider<GrammarDetail> {
  const GrammarDetailProvider._({
    required GrammarDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'grammarDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$grammarDetailHash();

  @override
  String toString() {
    return r'grammarDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GrammarDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GrammarDetail> create(Ref ref) {
    final argument = this.argument as String;
    return grammarDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GrammarDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$grammarDetailHash() => r'62378a2a4adeee3645584b42f35d00cfec951cbb';

final class GrammarDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GrammarDetail>, String> {
  const GrammarDetailFamily._()
    : super(
        retry: null,
        name: r'grammarDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GrammarDetailProvider call(String grammarId) =>
      GrammarDetailProvider._(argument: grammarId, from: this);

  @override
  String toString() => r'grammarDetailProvider';
}

@ProviderFor(grammarSearch)
const grammarSearchProvider = GrammarSearchFamily._();

final class GrammarSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GrammarMeta>>,
          List<GrammarMeta>,
          FutureOr<List<GrammarMeta>>
        >
    with
        $FutureModifier<List<GrammarMeta>>,
        $FutureProvider<List<GrammarMeta>> {
  const GrammarSearchProvider._({
    required GrammarSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'grammarSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$grammarSearchHash();

  @override
  String toString() {
    return r'grammarSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GrammarMeta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GrammarMeta>> create(Ref ref) {
    final argument = this.argument as String;
    return grammarSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GrammarSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$grammarSearchHash() => r'17ac15f097fd6634f3d230d3a2c61d3d7528b708';

final class GrammarSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GrammarMeta>>, String> {
  const GrammarSearchFamily._()
    : super(
        retry: null,
        name: r'grammarSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GrammarSearchProvider call(String query) =>
      GrammarSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'grammarSearchProvider';
}

@ProviderFor(GrammarFilterNotifier)
const grammarFilterProvider = GrammarFilterNotifierProvider._();

final class GrammarFilterNotifierProvider
    extends $NotifierProvider<GrammarFilterNotifier, GrammarFilterState> {
  const GrammarFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarFilterNotifierHash();

  @$internal
  @override
  GrammarFilterNotifier create() => GrammarFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrammarFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrammarFilterState>(value),
    );
  }
}

String _$grammarFilterNotifierHash() =>
    r'46b8a817ef4d7af9b4a967be61ad6a37d0e84bbc';

abstract class _$GrammarFilterNotifier extends $Notifier<GrammarFilterState> {
  GrammarFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GrammarFilterState, GrammarFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GrammarFilterState, GrammarFilterState>,
              GrammarFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredGrammars)
const filteredGrammarsProvider = FilteredGrammarsProvider._();

final class FilteredGrammarsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GrammarMeta>>,
          List<GrammarMeta>,
          FutureOr<List<GrammarMeta>>
        >
    with
        $FutureModifier<List<GrammarMeta>>,
        $FutureProvider<List<GrammarMeta>> {
  const FilteredGrammarsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredGrammarsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredGrammarsHash();

  @$internal
  @override
  $FutureProviderElement<List<GrammarMeta>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GrammarMeta>> create(Ref ref) {
    return filteredGrammars(ref);
  }
}

String _$filteredGrammarsHash() => r'519bfb214be4876ede55df0bcaf1939b99ff26b7';

@ProviderFor(GrammarFavoritesNotifier)
const grammarFavoritesProvider = GrammarFavoritesNotifierProvider._();

final class GrammarFavoritesNotifierProvider
    extends
        $AsyncNotifierProvider<
          GrammarFavoritesNotifier,
          List<GrammarFavorite>
        > {
  const GrammarFavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarFavoritesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarFavoritesNotifierHash();

  @$internal
  @override
  GrammarFavoritesNotifier create() => GrammarFavoritesNotifier();
}

String _$grammarFavoritesNotifierHash() =>
    r'1593da48ede103acc5915a66c67ba7448460f75f';

abstract class _$GrammarFavoritesNotifier
    extends $AsyncNotifier<List<GrammarFavorite>> {
  FutureOr<List<GrammarFavorite>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<GrammarFavorite>>, List<GrammarFavorite>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<GrammarFavorite>>,
                List<GrammarFavorite>
              >,
              AsyncValue<List<GrammarFavorite>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(isGrammarFavorite)
const isGrammarFavoriteProvider = IsGrammarFavoriteFamily._();

final class IsGrammarFavoriteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsGrammarFavoriteProvider._({
    required IsGrammarFavoriteFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isGrammarFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isGrammarFavoriteHash();

  @override
  String toString() {
    return r'isGrammarFavoriteProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isGrammarFavorite(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsGrammarFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isGrammarFavoriteHash() => r'd956867a173f178de5c2ab5496ef2a768378066a';

final class IsGrammarFavoriteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const IsGrammarFavoriteFamily._()
    : super(
        retry: null,
        name: r'isGrammarFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsGrammarFavoriteProvider call(String grammarId) =>
      IsGrammarFavoriteProvider._(argument: grammarId, from: this);

  @override
  String toString() => r'isGrammarFavoriteProvider';
}

@ProviderFor(grammarFavoriteIds)
const grammarFavoriteIdsProvider = GrammarFavoriteIdsProvider._();

final class GrammarFavoriteIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  const GrammarFavoriteIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarFavoriteIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarFavoriteIdsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return grammarFavoriteIds(ref);
  }
}

String _$grammarFavoriteIdsHash() =>
    r'c43052160adbe8ecd4f3e54863a4e6a7e2f76147';

@ProviderFor(grammarCategoryCounts)
const grammarCategoryCountsProvider = GrammarCategoryCountsProvider._();

final class GrammarCategoryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<GrammarCategory, int>>,
          Map<GrammarCategory, int>,
          FutureOr<Map<GrammarCategory, int>>
        >
    with
        $FutureModifier<Map<GrammarCategory, int>>,
        $FutureProvider<Map<GrammarCategory, int>> {
  const GrammarCategoryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarCategoryCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarCategoryCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<GrammarCategory, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<GrammarCategory, int>> create(Ref ref) {
    return grammarCategoryCounts(ref);
  }
}

String _$grammarCategoryCountsHash() =>
    r'e590d9e67bea340b8edc0b03cdba19ae5bc99ca8';

@ProviderFor(grammarLevelCounts)
const grammarLevelCountsProvider = GrammarLevelCountsProvider._();

final class GrammarLevelCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<GrammarLevel, int>>,
          Map<GrammarLevel, int>,
          FutureOr<Map<GrammarLevel, int>>
        >
    with
        $FutureModifier<Map<GrammarLevel, int>>,
        $FutureProvider<Map<GrammarLevel, int>> {
  const GrammarLevelCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grammarLevelCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grammarLevelCountsHash();

  @$internal
  @override
  $FutureProviderElement<Map<GrammarLevel, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<GrammarLevel, int>> create(Ref ref) {
    return grammarLevelCounts(ref);
  }
}

String _$grammarLevelCountsHash() =>
    r'dab777417fdd37939ebc9284092aeb107bb4d23d';
