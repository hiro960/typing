// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diaryRepository)
const diaryRepositoryProvider = DiaryRepositoryProvider._();

final class DiaryRepositoryProvider
    extends
        $FunctionalProvider<DiaryRepository, DiaryRepository, DiaryRepository>
    with $Provider<DiaryRepository> {
  const DiaryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiaryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DiaryRepository create(Ref ref) {
    return diaryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryRepository>(value),
    );
  }
}

String _$diaryRepositoryHash() => r'400063008b3ec91e2cd672ed41835350da6c7a8d';

@ProviderFor(aiCorrectionService)
const aiCorrectionServiceProvider = AiCorrectionServiceProvider._();

final class AiCorrectionServiceProvider
    extends
        $FunctionalProvider<
          AiCorrectionService,
          AiCorrectionService,
          AiCorrectionService
        >
    with $Provider<AiCorrectionService> {
  const AiCorrectionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCorrectionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCorrectionServiceHash();

  @$internal
  @override
  $ProviderElement<AiCorrectionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiCorrectionService create(Ref ref) {
    return aiCorrectionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiCorrectionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiCorrectionService>(value),
    );
  }
}

String _$aiCorrectionServiceHash() =>
    r'7783fd60cc1615dc560c96f2d948151e6f0c7a1d';

@ProviderFor(DiaryTimelineController)
const diaryTimelineControllerProvider = DiaryTimelineControllerProvider._();

final class DiaryTimelineControllerProvider
    extends $NotifierProvider<DiaryTimelineController, DiaryTimelineState> {
  const DiaryTimelineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryTimelineControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryTimelineControllerHash();

  @$internal
  @override
  DiaryTimelineController create() => DiaryTimelineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryTimelineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryTimelineState>(value),
    );
  }
}

String _$diaryTimelineControllerHash() =>
    r'4c15ddc2d90f6bf42adf2a349ef028534a42306d';

abstract class _$DiaryTimelineController extends $Notifier<DiaryTimelineState> {
  DiaryTimelineState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiaryTimelineState, DiaryTimelineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiaryTimelineState, DiaryTimelineState>,
              DiaryTimelineState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PostCommentsController)
const postCommentsControllerProvider = PostCommentsControllerFamily._();

final class PostCommentsControllerProvider
    extends $NotifierProvider<PostCommentsController, DiaryCommentsState> {
  const PostCommentsControllerProvider._({
    required PostCommentsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postCommentsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postCommentsControllerHash();

  @override
  String toString() {
    return r'postCommentsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostCommentsController create() => PostCommentsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryCommentsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryCommentsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postCommentsControllerHash() =>
    r'825ee415c0f13441a10391402570a6a006234edc';

final class PostCommentsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostCommentsController,
          DiaryCommentsState,
          DiaryCommentsState,
          DiaryCommentsState,
          String
        > {
  const PostCommentsControllerFamily._()
    : super(
        retry: null,
        name: r'postCommentsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostCommentsControllerProvider call(String postId) =>
      PostCommentsControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'postCommentsControllerProvider';
}

abstract class _$PostCommentsController extends $Notifier<DiaryCommentsState> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  DiaryCommentsState build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<DiaryCommentsState, DiaryCommentsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiaryCommentsState, DiaryCommentsState>,
              DiaryCommentsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DiaryBookmarksController)
const diaryBookmarksControllerProvider = DiaryBookmarksControllerProvider._();

final class DiaryBookmarksControllerProvider
    extends $NotifierProvider<DiaryBookmarksController, DiaryBookmarksState> {
  const DiaryBookmarksControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryBookmarksControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryBookmarksControllerHash();

  @$internal
  @override
  DiaryBookmarksController create() => DiaryBookmarksController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryBookmarksState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryBookmarksState>(value),
    );
  }
}

String _$diaryBookmarksControllerHash() =>
    r'7c17e422c74be4f4a5e983c68af5e3aa4fdb2011';

abstract class _$DiaryBookmarksController
    extends $Notifier<DiaryBookmarksState> {
  DiaryBookmarksState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiaryBookmarksState, DiaryBookmarksState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiaryBookmarksState, DiaryBookmarksState>,
              DiaryBookmarksState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DiaryNotificationsController)
const diaryNotificationsControllerProvider =
    DiaryNotificationsControllerProvider._();

final class DiaryNotificationsControllerProvider
    extends
        $NotifierProvider<
          DiaryNotificationsController,
          DiaryNotificationsState
        > {
  const DiaryNotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryNotificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryNotificationsControllerHash();

  @$internal
  @override
  DiaryNotificationsController create() => DiaryNotificationsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryNotificationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryNotificationsState>(value),
    );
  }
}

String _$diaryNotificationsControllerHash() =>
    r'cf309a74a0818fe7972efae4fea4e7614a8ee8a7';

abstract class _$DiaryNotificationsController
    extends $Notifier<DiaryNotificationsState> {
  DiaryNotificationsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<DiaryNotificationsState, DiaryNotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiaryNotificationsState, DiaryNotificationsState>,
              DiaryNotificationsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
