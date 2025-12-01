import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/models/writing_models.dart';
import '../../data/repositories/writing_data_repository.dart';
import '../../data/repositories/writing_storage_repository.dart';

/// WritingDataRepositoryプロバイダ
final writingDataRepositoryProvider = Provider<WritingDataRepository>((ref) {
  return WritingDataRepository();
});

/// WritingStorageRepositoryプロバイダ
final writingStorageRepositoryProvider = FutureProvider<WritingStorageRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return WritingStorageRepository(prefs);
});

/// 全パターンを提供するプロバイダ（非同期）
final writingPatternsProvider = FutureProvider<List<WritingPattern>>((ref) async {
  final repository = ref.watch(writingDataRepositoryProvider);
  return await repository.getAllPatterns();
});

/// 特定のパターンを取得するプロバイダ
final writingPatternProvider = FutureProvider.family<WritingPattern?, String>((ref, patternId) async {
  final patterns = await ref.watch(writingPatternsProvider.future);
  try {
    return patterns.firstWhere((p) => p.id == patternId);
  } catch (_) {
    return null;
  }
});

/// 特定のトピックを取得するプロバイダ
final writingTopicProvider = FutureProvider.family<WritingTopic?, ({String patternId, String topicId})>((ref, params) async {
  final pattern = await ref.watch(writingPatternProvider(params.patternId).future);
  if (pattern == null) return null;

  try {
    return pattern.topics.firstWhere((t) => t.id == params.topicId);
  } catch (_) {
    return null;
  }
});

/// 統計情報プロバイダ
final writingStatsProvider = FutureProvider<WritingStats>((ref) async {
  final storage = await ref.watch(writingStorageRepositoryProvider.future);
  return await storage.getStats();
});

/// 完了記録リストプロバイダ
final writingCompletionsProvider = FutureProvider<List<WritingCompletion>>((ref) async {
  final storage = await ref.watch(writingStorageRepositoryProvider.future);
  return await storage.getCompletions();
});

/// 特定パターンの完了記録プロバイダ
final writingPatternCompletionsProvider = FutureProvider.family<List<WritingCompletion>, String>((ref, patternId) async {
  final storage = await ref.watch(writingStorageRepositoryProvider.future);
  return await storage.getCompletionsByPattern(patternId);
});
