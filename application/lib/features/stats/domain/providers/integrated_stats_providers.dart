import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/stats/data/models/integrated_stats_model.dart';
import 'package:chaletta/features/stats/data/repositories/integrated_stats_repository.dart';

part 'integrated_stats_providers.g.dart';

/// IntegratedStatsRepository プロバイダー
@riverpod
IntegratedStatsRepository integratedStatsRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return IntegratedStatsRepository(apiClient: apiClient);
}

/// 統合統計プロバイダー（週次）
@riverpod
Future<IntegratedStats> integratedStats(Ref ref) async {
  final repository = ref.watch(integratedStatsRepositoryProvider);
  return repository.fetchIntegratedStats(range: 'weekly');
}

/// 統合統計プロバイダー（月次）
@riverpod
Future<IntegratedStats> monthlyIntegratedStats(Ref ref) async {
  final repository = ref.watch(integratedStatsRepositoryProvider);
  return repository.fetchIntegratedStats(range: 'monthly');
}

/// 統合統計プロバイダー（全期間）
@riverpod
Future<IntegratedStats> allTimeIntegratedStats(Ref ref) async {
  final repository = ref.watch(integratedStatsRepositoryProvider);
  return repository.fetchIntegratedStats(range: 'all');
}
