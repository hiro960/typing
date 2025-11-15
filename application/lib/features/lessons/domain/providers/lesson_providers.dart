import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/lesson_index.dart';
import '../../data/models/lesson_models.dart';
import '../../data/repositories/lesson_repository.dart';

part 'lesson_providers.g.dart';

@Riverpod(keepAlive: true)
LessonRepository lessonRepository(Ref ref) {
  return LessonRepository();
}

@riverpod
Future<LessonIndex> lessonIndex(Ref ref) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return repository.loadIndex();
}

@riverpod
Future<Map<LessonLevel, List<LessonMeta>>> lessonCatalog(Ref ref) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return repository.loadCatalog();
}

@riverpod
Future<List<LessonMeta>> lessonsByLevel(Ref ref, LessonLevel level) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return repository.lessonsByLevel(level);
}

@riverpod
Future<Lesson> lessonDetail(Ref ref, String lessonId) async {
  final repository = ref.watch(lessonRepositoryProvider);
  return repository.loadLesson(lessonId);
}
