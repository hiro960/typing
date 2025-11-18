// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordbook_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wordbookRepository)
const wordbookRepositoryProvider = WordbookRepositoryProvider._();

final class WordbookRepositoryProvider
    extends
        $FunctionalProvider<
          WordbookRepository,
          WordbookRepository,
          WordbookRepository
        >
    with $Provider<WordbookRepository> {
  const WordbookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordbookRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordbookRepositoryHash();

  @$internal
  @override
  $ProviderElement<WordbookRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WordbookRepository create(Ref ref) {
    return wordbookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WordbookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WordbookRepository>(value),
    );
  }
}

String _$wordbookRepositoryHash() =>
    r'9913c248710f38b9ec31c3fb113329d8746bf4e3';

@ProviderFor(WordbookNotifier)
const wordbookProvider = WordbookNotifierProvider._();

final class WordbookNotifierProvider
    extends $AsyncNotifierProvider<WordbookNotifier, List<Word>> {
  const WordbookNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordbookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordbookNotifierHash();

  @$internal
  @override
  WordbookNotifier create() => WordbookNotifier();
}

String _$wordbookNotifierHash() => r'98192399a91f46d2d9407ac0f745b718d37c31bf';

abstract class _$WordbookNotifier extends $AsyncNotifier<List<Word>> {
  FutureOr<List<Word>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Word>>, List<Word>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Word>>, List<Word>>,
              AsyncValue<List<Word>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WordbookOfflineQueue)
const wordbookOfflineQueueProvider = WordbookOfflineQueueProvider._();

final class WordbookOfflineQueueProvider
    extends
        $AsyncNotifierProvider<WordbookOfflineQueue, List<PendingOperation>> {
  const WordbookOfflineQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordbookOfflineQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordbookOfflineQueueHash();

  @$internal
  @override
  WordbookOfflineQueue create() => WordbookOfflineQueue();
}

String _$wordbookOfflineQueueHash() =>
    r'07fc69b5d41f1f9800ba8d5947ad94a37e442233';

abstract class _$WordbookOfflineQueue
    extends $AsyncNotifier<List<PendingOperation>> {
  FutureOr<List<PendingOperation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PendingOperation>>, List<PendingOperation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PendingOperation>>,
                List<PendingOperation>
              >,
              AsyncValue<List<PendingOperation>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(filteredWords)
const filteredWordsProvider = FilteredWordsFamily._();

final class FilteredWordsProvider
    extends $FunctionalProvider<List<Word>, List<Word>, List<Word>>
    with $Provider<List<Word>> {
  const FilteredWordsProvider._({
    required FilteredWordsFamily super.from,
    required ({
      WordCategory category,
      Set<WordStatus> statusFilters,
      String searchQuery,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'filteredWordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredWordsHash();

  @override
  String toString() {
    return r'filteredWordsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<Word>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Word> create(Ref ref) {
    final argument =
        this.argument
            as ({
              WordCategory category,
              Set<WordStatus> statusFilters,
              String searchQuery,
            });
    return filteredWords(
      ref,
      category: argument.category,
      statusFilters: argument.statusFilters,
      searchQuery: argument.searchQuery,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Word> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Word>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredWordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredWordsHash() => r'9657d67879a3d8a4cb2fffcf3f5fd1c356731685';

final class FilteredWordsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          List<Word>,
          ({
            WordCategory category,
            Set<WordStatus> statusFilters,
            String searchQuery,
          })
        > {
  const FilteredWordsFamily._()
    : super(
        retry: null,
        name: r'filteredWordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredWordsProvider call({
    required WordCategory category,
    required Set<WordStatus> statusFilters,
    required String searchQuery,
  }) => FilteredWordsProvider._(
    argument: (
      category: category,
      statusFilters: statusFilters,
      searchQuery: searchQuery,
    ),
    from: this,
  );

  @override
  String toString() => r'filteredWordsProvider';
}

@ProviderFor(AudioSettingsNotifier)
const audioSettingsProvider = AudioSettingsNotifierProvider._();

final class AudioSettingsNotifierProvider
    extends $AsyncNotifierProvider<AudioSettingsNotifier, AudioSettings> {
  const AudioSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioSettingsNotifierHash();

  @$internal
  @override
  AudioSettingsNotifier create() => AudioSettingsNotifier();
}

String _$audioSettingsNotifierHash() =>
    r'f2f7751b8c6ce325eb166fb9a23b78b383561049';

abstract class _$AudioSettingsNotifier extends $AsyncNotifier<AudioSettings> {
  FutureOr<AudioSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AudioSettings>, AudioSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AudioSettings>, AudioSettings>,
              AsyncValue<AudioSettings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(WordAudioService)
const wordAudioServiceProvider = WordAudioServiceProvider._();

final class WordAudioServiceProvider
    extends $AsyncNotifierProvider<WordAudioService, void> {
  const WordAudioServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordAudioServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordAudioServiceHash();

  @$internal
  @override
  WordAudioService create() => WordAudioService();
}

String _$wordAudioServiceHash() => r'a633db0a6143e42fc2cf8008f740d9df48ee100a';

abstract class _$WordAudioService extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
