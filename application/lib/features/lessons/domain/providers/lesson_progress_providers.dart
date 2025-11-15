import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/domain/providers/auth_providers.dart';
import '../../data/models/lesson_models.dart';
import '../../data/models/lesson_progress.dart';
import '../../data/repositories/lesson_progress_repository.dart';

part 'lesson_progress_providers.g.dart';

@riverpod
LessonProgressRepository lessonProgressRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return LessonProgressRepository(apiClient: apiClient);
}

@riverpod
Future<LessonStatsSummary> lessonStats(Ref ref, {LessonLevel? level}) async {
  final repository = ref.watch(lessonProgressRepositoryProvider);
  return repository.fetchStats(level: level);
}

@riverpod
class LessonProgressController extends _$LessonProgressController {
  @override
  FutureOr<Map<String, LessonProgress>> build() async {
    final repository = ref.watch(lessonProgressRepositoryProvider);
    return repository.loadLocalProgress();
  }

  Future<void> markCompleted({
    required String lessonId,
    required int completedItems,
    required int totalItems,
    required int wpm,
    required double accuracy,
  }) async {
    state = const AsyncLoading();
    final repository = ref.watch(lessonProgressRepositoryProvider);
    final updated = await repository.markCompleted(
      lessonId,
      completedItems: completedItems,
      totalItems: totalItems,
      wpm: wpm,
      accuracy: accuracy,
    );
    state = AsyncData(updated);
  }
}
