// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_add_words_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 瞬間作文の単語を一括追加するProvider

@ProviderFor(BulkAddWordsNotifier)
const bulkAddWordsProvider = BulkAddWordsNotifierProvider._();

/// 瞬間作文の単語を一括追加するProvider
final class BulkAddWordsNotifierProvider
    extends $NotifierProvider<BulkAddWordsNotifier, BulkAddState> {
  /// 瞬間作文の単語を一括追加するProvider
  const BulkAddWordsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulkAddWordsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulkAddWordsNotifierHash();

  @$internal
  @override
  BulkAddWordsNotifier create() => BulkAddWordsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BulkAddState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BulkAddState>(value),
    );
  }
}

String _$bulkAddWordsNotifierHash() =>
    r'd8e5ad1b9c16de575a1d2a407c5af9a8a2bee7dc';

/// 瞬間作文の単語を一括追加するProvider

abstract class _$BulkAddWordsNotifier extends $Notifier<BulkAddState> {
  BulkAddState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BulkAddState, BulkAddState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BulkAddState, BulkAddState>,
              BulkAddState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// CSVの総単語数を取得するProvider

@ProviderFor(quickTranslationWordCount)
const quickTranslationWordCountProvider = QuickTranslationWordCountProvider._();

/// CSVの総単語数を取得するProvider

final class QuickTranslationWordCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// CSVの総単語数を取得するProvider
  const QuickTranslationWordCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickTranslationWordCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickTranslationWordCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return quickTranslationWordCount(ref);
  }
}

String _$quickTranslationWordCountHash() =>
    r'f03103d22d1c30a1502f252468ed6483f081383f';
