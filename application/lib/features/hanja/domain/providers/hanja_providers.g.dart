// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hanja_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hanjaRepository)
const hanjaRepositoryProvider = HanjaRepositoryProvider._();

final class HanjaRepositoryProvider
    extends
        $FunctionalProvider<HanjaRepository, HanjaRepository, HanjaRepository>
    with $Provider<HanjaRepository> {
  const HanjaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hanjaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hanjaRepositoryHash();

  @$internal
  @override
  $ProviderElement<HanjaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HanjaRepository create(Ref ref) {
    return hanjaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HanjaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HanjaRepository>(value),
    );
  }
}

String _$hanjaRepositoryHash() => r'e4a76219729910bad9f27e7aa226006694e71ea7';

@ProviderFor(allHanjaCharacters)
const allHanjaCharactersProvider = AllHanjaCharactersProvider._();

final class AllHanjaCharactersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaCharacter>>,
          List<HanjaCharacter>,
          FutureOr<List<HanjaCharacter>>
        >
    with
        $FutureModifier<List<HanjaCharacter>>,
        $FutureProvider<List<HanjaCharacter>> {
  const AllHanjaCharactersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allHanjaCharactersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allHanjaCharactersHash();

  @$internal
  @override
  $FutureProviderElement<List<HanjaCharacter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaCharacter>> create(Ref ref) {
    return allHanjaCharacters(ref);
  }
}

String _$allHanjaCharactersHash() =>
    r'f6328577eeaeaafaa7295205854743875cd2aa85';

@ProviderFor(hanjaCharactersByLevel)
const hanjaCharactersByLevelProvider = HanjaCharactersByLevelFamily._();

final class HanjaCharactersByLevelProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaCharacter>>,
          List<HanjaCharacter>,
          FutureOr<List<HanjaCharacter>>
        >
    with
        $FutureModifier<List<HanjaCharacter>>,
        $FutureProvider<List<HanjaCharacter>> {
  const HanjaCharactersByLevelProvider._({
    required HanjaCharactersByLevelFamily super.from,
    required HanjaLevel super.argument,
  }) : super(
         retry: null,
         name: r'hanjaCharactersByLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaCharactersByLevelHash();

  @override
  String toString() {
    return r'hanjaCharactersByLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaCharacter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaCharacter>> create(Ref ref) {
    final argument = this.argument as HanjaLevel;
    return hanjaCharactersByLevel(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaCharactersByLevelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaCharactersByLevelHash() =>
    r'2d768eea5d7f52ad4b683da8286c8962a34949fd';

final class HanjaCharactersByLevelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaCharacter>>, HanjaLevel> {
  const HanjaCharactersByLevelFamily._()
    : super(
        retry: null,
        name: r'hanjaCharactersByLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaCharactersByLevelProvider call(HanjaLevel level) =>
      HanjaCharactersByLevelProvider._(argument: level, from: this);

  @override
  String toString() => r'hanjaCharactersByLevelProvider';
}

@ProviderFor(hanjaCharacterDetail)
const hanjaCharacterDetailProvider = HanjaCharacterDetailFamily._();

final class HanjaCharacterDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaCharacter?>,
          HanjaCharacter?,
          FutureOr<HanjaCharacter?>
        >
    with $FutureModifier<HanjaCharacter?>, $FutureProvider<HanjaCharacter?> {
  const HanjaCharacterDetailProvider._({
    required HanjaCharacterDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaCharacterDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaCharacterDetailHash();

  @override
  String toString() {
    return r'hanjaCharacterDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HanjaCharacter?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaCharacter?> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaCharacterDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaCharacterDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaCharacterDetailHash() =>
    r'b9f2b4c7615f52dccc966ffafba62ddea56675af';

final class HanjaCharacterDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HanjaCharacter?>, String> {
  const HanjaCharacterDetailFamily._()
    : super(
        retry: null,
        name: r'hanjaCharacterDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaCharacterDetailProvider call(String characterId) =>
      HanjaCharacterDetailProvider._(argument: characterId, from: this);

  @override
  String toString() => r'hanjaCharacterDetailProvider';
}

@ProviderFor(hanjaCharacterByChar)
const hanjaCharacterByCharProvider = HanjaCharacterByCharFamily._();

final class HanjaCharacterByCharProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaCharacter?>,
          HanjaCharacter?,
          FutureOr<HanjaCharacter?>
        >
    with $FutureModifier<HanjaCharacter?>, $FutureProvider<HanjaCharacter?> {
  const HanjaCharacterByCharProvider._({
    required HanjaCharacterByCharFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaCharacterByCharProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaCharacterByCharHash();

  @override
  String toString() {
    return r'hanjaCharacterByCharProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HanjaCharacter?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaCharacter?> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaCharacterByChar(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaCharacterByCharProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaCharacterByCharHash() =>
    r'c6ccf5f0ad90996ec7efe8ffa692b8728ac24115';

final class HanjaCharacterByCharFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HanjaCharacter?>, String> {
  const HanjaCharacterByCharFamily._()
    : super(
        retry: null,
        name: r'hanjaCharacterByCharProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaCharacterByCharProvider call(String character) =>
      HanjaCharacterByCharProvider._(argument: character, from: this);

  @override
  String toString() => r'hanjaCharacterByCharProvider';
}

@ProviderFor(allHanjaWords)
const allHanjaWordsProvider = AllHanjaWordsProvider._();

final class AllHanjaWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaWord>>,
          List<HanjaWord>,
          FutureOr<List<HanjaWord>>
        >
    with $FutureModifier<List<HanjaWord>>, $FutureProvider<List<HanjaWord>> {
  const AllHanjaWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allHanjaWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allHanjaWordsHash();

  @$internal
  @override
  $FutureProviderElement<List<HanjaWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaWord>> create(Ref ref) {
    return allHanjaWords(ref);
  }
}

String _$allHanjaWordsHash() => r'3f226529ed6a0b3bfba6279274892515aa74f91b';

@ProviderFor(hanjaWordsByCategory)
const hanjaWordsByCategoryProvider = HanjaWordsByCategoryFamily._();

final class HanjaWordsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaWord>>,
          List<HanjaWord>,
          FutureOr<List<HanjaWord>>
        >
    with $FutureModifier<List<HanjaWord>>, $FutureProvider<List<HanjaWord>> {
  const HanjaWordsByCategoryProvider._({
    required HanjaWordsByCategoryFamily super.from,
    required HanjaWordCategory super.argument,
  }) : super(
         retry: null,
         name: r'hanjaWordsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaWordsByCategoryHash();

  @override
  String toString() {
    return r'hanjaWordsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaWord>> create(Ref ref) {
    final argument = this.argument as HanjaWordCategory;
    return hanjaWordsByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaWordsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaWordsByCategoryHash() =>
    r'9b8a373d6b0430efa369dcdcbb0348273b826597';

final class HanjaWordsByCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<HanjaWord>>,
          HanjaWordCategory
        > {
  const HanjaWordsByCategoryFamily._()
    : super(
        retry: null,
        name: r'hanjaWordsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaWordsByCategoryProvider call(HanjaWordCategory category) =>
      HanjaWordsByCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'hanjaWordsByCategoryProvider';
}

@ProviderFor(hanjaWordsByLevel)
const hanjaWordsByLevelProvider = HanjaWordsByLevelFamily._();

final class HanjaWordsByLevelProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaWord>>,
          List<HanjaWord>,
          FutureOr<List<HanjaWord>>
        >
    with $FutureModifier<List<HanjaWord>>, $FutureProvider<List<HanjaWord>> {
  const HanjaWordsByLevelProvider._({
    required HanjaWordsByLevelFamily super.from,
    required HanjaLevel super.argument,
  }) : super(
         retry: null,
         name: r'hanjaWordsByLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaWordsByLevelHash();

  @override
  String toString() {
    return r'hanjaWordsByLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaWord>> create(Ref ref) {
    final argument = this.argument as HanjaLevel;
    return hanjaWordsByLevel(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaWordsByLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaWordsByLevelHash() => r'de318e61b349387ae6ffcfea6cbfbfa4c15f8f9f';

final class HanjaWordsByLevelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaWord>>, HanjaLevel> {
  const HanjaWordsByLevelFamily._()
    : super(
        retry: null,
        name: r'hanjaWordsByLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaWordsByLevelProvider call(HanjaLevel level) =>
      HanjaWordsByLevelProvider._(argument: level, from: this);

  @override
  String toString() => r'hanjaWordsByLevelProvider';
}

@ProviderFor(hanjaWordDetail)
const hanjaWordDetailProvider = HanjaWordDetailFamily._();

final class HanjaWordDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaWord?>,
          HanjaWord?,
          FutureOr<HanjaWord?>
        >
    with $FutureModifier<HanjaWord?>, $FutureProvider<HanjaWord?> {
  const HanjaWordDetailProvider._({
    required HanjaWordDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaWordDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaWordDetailHash();

  @override
  String toString() {
    return r'hanjaWordDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HanjaWord?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaWord?> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaWordDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaWordDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaWordDetailHash() => r'1b8b3f984d09e8a42796247345e4bfbe81eb0e7f';

final class HanjaWordDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HanjaWord?>, String> {
  const HanjaWordDetailFamily._()
    : super(
        retry: null,
        name: r'hanjaWordDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaWordDetailProvider call(String wordId) =>
      HanjaWordDetailProvider._(argument: wordId, from: this);

  @override
  String toString() => r'hanjaWordDetailProvider';
}

@ProviderFor(hanjaSearch)
const hanjaSearchProvider = HanjaSearchFamily._();

final class HanjaSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaSearchResult>,
          HanjaSearchResult,
          FutureOr<HanjaSearchResult>
        >
    with
        $FutureModifier<HanjaSearchResult>,
        $FutureProvider<HanjaSearchResult> {
  const HanjaSearchProvider._({
    required HanjaSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaSearchHash();

  @override
  String toString() {
    return r'hanjaSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HanjaSearchResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaSearchResult> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaSearchHash() => r'92d57cc577f196b7cc05b9cffa969aa9ee0f2c09';

final class HanjaSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HanjaSearchResult>, String> {
  const HanjaSearchFamily._()
    : super(
        retry: null,
        name: r'hanjaSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaSearchProvider call(String query) =>
      HanjaSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'hanjaSearchProvider';
}

@ProviderFor(hanjaCharacterSearch)
const hanjaCharacterSearchProvider = HanjaCharacterSearchFamily._();

final class HanjaCharacterSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaCharacter>>,
          List<HanjaCharacter>,
          FutureOr<List<HanjaCharacter>>
        >
    with
        $FutureModifier<List<HanjaCharacter>>,
        $FutureProvider<List<HanjaCharacter>> {
  const HanjaCharacterSearchProvider._({
    required HanjaCharacterSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaCharacterSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaCharacterSearchHash();

  @override
  String toString() {
    return r'hanjaCharacterSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaCharacter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaCharacter>> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaCharacterSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaCharacterSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaCharacterSearchHash() =>
    r'4cdc2b1de3bbae47614cd2ace4a868a68aaf2bd3';

final class HanjaCharacterSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaCharacter>>, String> {
  const HanjaCharacterSearchFamily._()
    : super(
        retry: null,
        name: r'hanjaCharacterSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaCharacterSearchProvider call(String query) =>
      HanjaCharacterSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'hanjaCharacterSearchProvider';
}

@ProviderFor(hanjaWordSearch)
const hanjaWordSearchProvider = HanjaWordSearchFamily._();

final class HanjaWordSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaWord>>,
          List<HanjaWord>,
          FutureOr<List<HanjaWord>>
        >
    with $FutureModifier<List<HanjaWord>>, $FutureProvider<List<HanjaWord>> {
  const HanjaWordSearchProvider._({
    required HanjaWordSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaWordSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaWordSearchHash();

  @override
  String toString() {
    return r'hanjaWordSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaWord>> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaWordSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaWordSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaWordSearchHash() => r'f4bbd218fdf358da33721185f38a6e322ba7903d';

final class HanjaWordSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaWord>>, String> {
  const HanjaWordSearchFamily._()
    : super(
        retry: null,
        name: r'hanjaWordSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaWordSearchProvider call(String query) =>
      HanjaWordSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'hanjaWordSearchProvider';
}

@ProviderFor(hanjaByKorean)
const hanjaByKoreanProvider = HanjaByKoreanFamily._();

final class HanjaByKoreanProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaCharacter>>,
          List<HanjaCharacter>,
          FutureOr<List<HanjaCharacter>>
        >
    with
        $FutureModifier<List<HanjaCharacter>>,
        $FutureProvider<List<HanjaCharacter>> {
  const HanjaByKoreanProvider._({
    required HanjaByKoreanFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaByKoreanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaByKoreanHash();

  @override
  String toString() {
    return r'hanjaByKoreanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaCharacter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaCharacter>> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaByKorean(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaByKoreanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaByKoreanHash() => r'6fea09195974bf0c3ff0c1bdc5bf8d41505be983';

final class HanjaByKoreanFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaCharacter>>, String> {
  const HanjaByKoreanFamily._()
    : super(
        retry: null,
        name: r'hanjaByKoreanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaByKoreanProvider call(String korean) =>
      HanjaByKoreanProvider._(argument: korean, from: this);

  @override
  String toString() => r'hanjaByKoreanProvider';
}

@ProviderFor(hanjaByJapanese)
const hanjaByJapaneseProvider = HanjaByJapaneseFamily._();

final class HanjaByJapaneseProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HanjaCharacter>>,
          List<HanjaCharacter>,
          FutureOr<List<HanjaCharacter>>
        >
    with
        $FutureModifier<List<HanjaCharacter>>,
        $FutureProvider<List<HanjaCharacter>> {
  const HanjaByJapaneseProvider._({
    required HanjaByJapaneseFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hanjaByJapaneseProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hanjaByJapaneseHash();

  @override
  String toString() {
    return r'hanjaByJapaneseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HanjaCharacter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HanjaCharacter>> create(Ref ref) {
    final argument = this.argument as String;
    return hanjaByJapanese(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HanjaByJapaneseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hanjaByJapaneseHash() => r'0196caf9929f605e44320293a67fae7589201f32';

final class HanjaByJapaneseFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HanjaCharacter>>, String> {
  const HanjaByJapaneseFamily._()
    : super(
        retry: null,
        name: r'hanjaByJapaneseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HanjaByJapaneseProvider call(String japanese) =>
      HanjaByJapaneseProvider._(argument: japanese, from: this);

  @override
  String toString() => r'hanjaByJapaneseProvider';
}

@ProviderFor(hanjaStatistics)
const hanjaStatisticsProvider = HanjaStatisticsProvider._();

final class HanjaStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaStatistics>,
          HanjaStatistics,
          FutureOr<HanjaStatistics>
        >
    with $FutureModifier<HanjaStatistics>, $FutureProvider<HanjaStatistics> {
  const HanjaStatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hanjaStatisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hanjaStatisticsHash();

  @$internal
  @override
  $FutureProviderElement<HanjaStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaStatistics> create(Ref ref) {
    return hanjaStatistics(ref);
  }
}

String _$hanjaStatisticsHash() => r'08769d9dee76b22c4266052577ec4101bc383064';

@ProviderFor(HanjaFilterNotifier)
const hanjaFilterProvider = HanjaFilterNotifierProvider._();

final class HanjaFilterNotifierProvider
    extends $NotifierProvider<HanjaFilterNotifier, HanjaFilterState> {
  const HanjaFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hanjaFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hanjaFilterNotifierHash();

  @$internal
  @override
  HanjaFilterNotifier create() => HanjaFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HanjaFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HanjaFilterState>(value),
    );
  }
}

String _$hanjaFilterNotifierHash() =>
    r'9dc7b93e4ba057b645eeee1f5ebe2af117837faf';

abstract class _$HanjaFilterNotifier extends $Notifier<HanjaFilterState> {
  HanjaFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HanjaFilterState, HanjaFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HanjaFilterState, HanjaFilterState>,
              HanjaFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredHanjaSearch)
const filteredHanjaSearchProvider = FilteredHanjaSearchProvider._();

final class FilteredHanjaSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<HanjaSearchResult>,
          HanjaSearchResult,
          FutureOr<HanjaSearchResult>
        >
    with
        $FutureModifier<HanjaSearchResult>,
        $FutureProvider<HanjaSearchResult> {
  const FilteredHanjaSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredHanjaSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredHanjaSearchHash();

  @$internal
  @override
  $FutureProviderElement<HanjaSearchResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HanjaSearchResult> create(Ref ref) {
    return filteredHanjaSearch(ref);
  }
}

String _$filteredHanjaSearchHash() =>
    r'75db379ec8804a75d447e3722a8cf0716f0d4ccc';
