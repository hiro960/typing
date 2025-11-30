import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/lesson_index.dart' as lesson_index;
import '../../data/models/lesson_models.dart';
import '../../data/models/lesson_progress.dart';
import 'lesson_progress_providers.dart';
import 'lesson_providers.dart';

class HomeState {
  const HomeState({
    required this.catalog,
    required this.statsAsync,
    required this.progress,
    required this.focusLesson,
  });

  final Map<LessonLevel, List<lesson_index.LessonMeta>> catalog;
  final AsyncValue<LessonStatsSummary> statsAsync;
  final Map<String, LessonProgress> progress;
  final lesson_index.LessonMeta? focusLesson;

  /// 統計データ（ローディング中はデフォルト値）
  LessonStatsSummary get stats =>
      statsAsync.hasValue ? statsAsync.value! : const LessonStatsSummary();

  /// 統計がローディング中かどうか
  bool get isStatsLoading => statsAsync.isLoading;
}

final homeStateProvider =
    Provider.autoDispose<AsyncValue<HomeState>>((ref) {
  final catalogAsync = ref.watch(lessonCatalogProvider);
  final statsAsync = ref.watch(lessonStatsProvider(level: null));
  final progressAsync = ref.watch(lessonProgressControllerProvider);

  // カタログのエラーは致命的
  if (catalogAsync.hasError) {
    return AsyncError(
      catalogAsync.error!,
      catalogAsync.stackTrace ?? StackTrace.current,
    );
  }

  // 進捗のエラーは致命的
  if (progressAsync.hasError) {
    return AsyncError(
      progressAsync.error!,
      progressAsync.stackTrace ?? StackTrace.current,
    );
  }

  // カタログと進捗がロード中の場合のみローディング状態を返す
  // 統計はローディング中でも画面表示を開始する
  if (catalogAsync.isLoading || progressAsync.isLoading) {
    return const AsyncLoading();
  }

  final catalog = catalogAsync.value ?? const {};
  final progress = progressAsync.value ?? const <String, LessonProgress>{};
  final focusLesson = _findNextLesson(catalog, progress);

  return AsyncData(
    HomeState(
      catalog: catalog,
      statsAsync: statsAsync,
      progress: progress,
      focusLesson: focusLesson,
    ),
  );
});

lesson_index.LessonMeta? _findNextLesson(
  Map<LessonLevel, List<lesson_index.LessonMeta>> catalog,
  Map<String, LessonProgress> progress,
) {
  for (final level in LessonLevel.values) {
    final lessons = catalog[level] ?? const [];
    for (final lesson in lessons) {
      final rate = progress[lesson.id]?.normalizedCompletionRate ?? 0;
      if (rate < 100) {
        return lesson;
      }
    }
  }
  return null;
}
