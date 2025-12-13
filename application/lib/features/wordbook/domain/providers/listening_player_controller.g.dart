// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_player_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ListeningPlayerController)
const listeningPlayerControllerProvider = ListeningPlayerControllerProvider._();

final class ListeningPlayerControllerProvider
    extends $NotifierProvider<ListeningPlayerController, ListeningPlayerState> {
  const ListeningPlayerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listeningPlayerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listeningPlayerControllerHash();

  @$internal
  @override
  ListeningPlayerController create() => ListeningPlayerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListeningPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListeningPlayerState>(value),
    );
  }
}

String _$listeningPlayerControllerHash() =>
    r'bcdd8b3c4747e96322be9b31907a301d53fbe2f7';

abstract class _$ListeningPlayerController
    extends $Notifier<ListeningPlayerState> {
  ListeningPlayerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ListeningPlayerState, ListeningPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListeningPlayerState, ListeningPlayerState>,
              ListeningPlayerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
