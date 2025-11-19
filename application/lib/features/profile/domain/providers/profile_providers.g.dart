// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
const profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  const ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'bbbb65816e499c590f59d8cc2b2b88a64ce8f17d';

@ProviderFor(userProfile)
const userProfileProvider = UserProfileFamily._();

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel>,
          UserModel,
          FutureOr<UserModel>
        >
    with $FutureModifier<UserModel>, $FutureProvider<UserModel> {
  const UserProfileProvider._({
    required UserProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @override
  String toString() {
    return r'userProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserModel> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel> create(Ref ref) {
    final argument = this.argument as String;
    return userProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileHash() => r'e7a6fdf7f15d2e736f5d738e4cc00fba37f22b0c';

final class UserProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserModel>, String> {
  const UserProfileFamily._()
    : super(
        retry: null,
        name: r'userProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileProvider call(String userId) =>
      UserProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileProvider';
}

@ProviderFor(userStats)
const userStatsProvider = UserStatsFamily._();

final class UserStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStatsModel>,
          UserStatsModel,
          FutureOr<UserStatsModel>
        >
    with $FutureModifier<UserStatsModel>, $FutureProvider<UserStatsModel> {
  const UserStatsProvider._({
    required UserStatsFamily super.from,
    required (String, {String range}) super.argument,
  }) : super(
         retry: null,
         name: r'userStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userStatsHash();

  @override
  String toString() {
    return r'userStatsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<UserStatsModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserStatsModel> create(Ref ref) {
    final argument = this.argument as (String, {String range});
    return userStats(ref, argument.$1, range: argument.range);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userStatsHash() => r'1fdc860ec65f9b622243a47b501914e97c10ee30';

final class UserStatsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<UserStatsModel>,
          (String, {String range})
        > {
  const UserStatsFamily._()
    : super(
        retry: null,
        name: r'userStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserStatsProvider call(String userId, {String range = 'all'}) =>
      UserStatsProvider._(argument: (userId, range: range), from: this);

  @override
  String toString() => r'userStatsProvider';
}

@ProviderFor(userPosts)
const userPostsProvider = UserPostsFamily._();

final class UserPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiaryPost>>,
          List<DiaryPost>,
          FutureOr<List<DiaryPost>>
        >
    with $FutureModifier<List<DiaryPost>>, $FutureProvider<List<DiaryPost>> {
  const UserPostsProvider._({
    required UserPostsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userPostsHash();

  @override
  String toString() {
    return r'userPostsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DiaryPost>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiaryPost>> create(Ref ref) {
    final argument = this.argument as String;
    return userPosts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userPostsHash() => r'8a1874250e27a12c4fd28712e2991b1028a5063c';

final class UserPostsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DiaryPost>>, String> {
  const UserPostsFamily._()
    : super(
        retry: null,
        name: r'userPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserPostsProvider call(String userId) =>
      UserPostsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userPostsProvider';
}
