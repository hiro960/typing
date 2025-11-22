import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/providers/auth_providers.dart';
import '../../../diary/data/models/diary_post.dart';
import '../../data/models/user_stats_model.dart';
import '../../data/repositories/profile_repository.dart';

part 'profile_providers.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return ProfileRepository(apiClient: apiClient);
}

@riverpod
Future<UserModel> userProfile(Ref ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchUserProfile(userId);
}

@riverpod
Future<UserStatsModel> userStats(
  Ref ref,
  String userId, {
  String range = 'all',
}) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchUserStats(userId, range: range);
}

@riverpod
Future<List<DiaryPost>> userPosts(Ref ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchUserPosts(userId);
}

@riverpod
Future<List<UserModel>> userFollowers(Ref ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchFollowers(userId);
}

@riverpod
Future<List<UserModel>> userFollowing(Ref ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.fetchFollowing(userId);
}
