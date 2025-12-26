import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/shadowing_models.dart';
import '../../data/repositories/shadowing_repository.dart';

part 'shadowing_providers.g.dart';

/// シャドーイングリポジトリのプロバイダー
@Riverpod(keepAlive: true)
ShadowingRepository shadowingRepository(Ref ref) {
  return ShadowingRepository();
}

/// レベル別コンテンツ一覧のプロバイダー
@riverpod
Future<List<ShadowingContent>> shadowingContents(
  Ref ref,
  ShadowingLevel level,
) async {
  final repository = ref.watch(shadowingRepositoryProvider);
  return repository.loadContents(level);
}

/// 全進捗データのプロバイダー
@riverpod
Future<Map<String, ShadowingProgress>> shadowingAllProgress(
  Ref ref,
) async {
  final repository = ref.watch(shadowingRepositoryProvider);
  return repository.loadAllProgress();
}

/// レベル別統計のプロバイダー
@riverpod
Future<ShadowingLevelStats> shadowingLevelStats(
  Ref ref,
  ShadowingLevel level,
) async {
  final repository = ref.watch(shadowingRepositoryProvider);
  final contents = await ref.watch(shadowingContentsProvider(level).future);
  return repository.getLevelStats(level, contents);
}

/// 全レベルの統計を取得するプロバイダー
@riverpod
Future<List<ShadowingLevelStats>> shadowingAllLevelStats(
  Ref ref,
) async {
  final stats = await Future.wait<ShadowingLevelStats>([
    ref.watch(shadowingLevelStatsProvider(ShadowingLevel.beginner).future),
    ref.watch(shadowingLevelStatsProvider(ShadowingLevel.intermediate).future),
    ref.watch(shadowingLevelStatsProvider(ShadowingLevel.advanced).future),
  ]);
  return stats;
}

/// 特定コンテンツの進捗を取得するプロバイダー
@riverpod
Future<ShadowingProgress?> shadowingProgress(
  Ref ref,
  String contentId,
) async {
  final allProgress = await ref.watch(shadowingAllProgressProvider.future);
  return allProgress[contentId];
}
