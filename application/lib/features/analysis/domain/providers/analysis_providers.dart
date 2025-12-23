import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/providers/auth_providers.dart';
import '../../data/repositories/analysis_repository.dart';
import '../models/analysis_models.dart';

part 'analysis_providers.g.dart';

@riverpod
AnalysisRepository analysisRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return AnalysisRepository(apiClient: apiClient);
}

@riverpod
Future<AnalysisDashboard> analysisDashboard(
  Ref ref, {
  String period = 'month',
  String? calendarMonth,
}) async {
  final repository = ref.watch(analysisRepositoryProvider);
  return repository.fetchDashboard(
    period: period,
    calendarMonth: calendarMonth,
  );
}
