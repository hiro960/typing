// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(typingRepository)
const typingRepositoryProvider = TypingRepositoryProvider._();

final class TypingRepositoryProvider
    extends
        $FunctionalProvider<
          TypingRepository,
          TypingRepository,
          TypingRepository
        >
    with $Provider<TypingRepository> {
  const TypingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'typingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$typingRepositoryHash();

  @$internal
  @override
  $ProviderElement<TypingRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TypingRepository create(Ref ref) {
    return typingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TypingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TypingRepository>(value),
    );
  }
}

String _$typingRepositoryHash() => r'7311acb6d399fc7f4ad2d5c510284864e9e41d5c';

@ProviderFor(OfflineQueue)
const offlineQueueProvider = OfflineQueueProvider._();

final class OfflineQueueProvider
    extends $AsyncNotifierProvider<OfflineQueue, List<PendingCompletion>> {
  const OfflineQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineQueueHash();

  @$internal
  @override
  OfflineQueue create() => OfflineQueue();
}

String _$offlineQueueHash() => r'3d733c8ca01fddaf0f33761c3d09237f4d3c9bb6';

abstract class _$OfflineQueue extends $AsyncNotifier<List<PendingCompletion>> {
  FutureOr<List<PendingCompletion>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PendingCompletion>>,
              List<PendingCompletion>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PendingCompletion>>,
                List<PendingCompletion>
              >,
              AsyncValue<List<PendingCompletion>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
