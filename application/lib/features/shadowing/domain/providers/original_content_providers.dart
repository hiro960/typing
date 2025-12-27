import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/original_content.dart';
import '../../data/models/shadowing_models.dart';
import '../../data/repositories/original_content_repository.dart';

part 'original_content_providers.g.dart';

/// オリジナル文章リポジトリのプロバイダー
@Riverpod(keepAlive: true)
OriginalContentRepository originalContentRepository(Ref ref) {
  return OriginalContentRepository();
}

/// オリジナル文章一覧のプロバイダー
@riverpod
Future<List<OriginalContent>> originalContents(Ref ref) async {
  final repository = ref.watch(originalContentRepositoryProvider);
  return repository.getAllContents();
}

/// 単一のオリジナル文章を取得するプロバイダー
@riverpod
Future<OriginalContent?> originalContent(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(originalContentRepositoryProvider);
  return repository.getContent(id);
}

/// オリジナル文章の統計を取得するプロバイダー
@riverpod
Future<OriginalContentStats> originalContentStats(Ref ref) async {
  final repository = ref.watch(originalContentRepositoryProvider);
  return repository.getStats();
}

/// オリジナル文章の保存（新規作成・更新）Notifier
@Riverpod(keepAlive: true)
class OriginalContentSaver extends _$OriginalContentSaver {
  @override
  FutureOr<void> build() {
    // 初期状態は何もしない
  }

  /// オリジナル文章を保存
  Future<OriginalContent> save({
    String? id,
    required String title,
    required String text,
    List<TextSegment>? segments,
    String? audioPath,
    int durationSeconds = 0,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(originalContentRepositoryProvider);
      final content = await repository.saveContent(
        id: id,
        title: title,
        text: text,
        segments: segments,
        audioPath: audioPath,
        durationSeconds: durationSeconds,
      );
      // コンテンツ一覧を更新
      ref.invalidate(originalContentsProvider);
      ref.invalidate(originalContentStatsProvider);
      state = const AsyncData(null);
      return content;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// オリジナル文章を削除
  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(originalContentRepositoryProvider);
      await repository.deleteContent(id);
      // コンテンツ一覧を更新
      ref.invalidate(originalContentsProvider);
      ref.invalidate(originalContentStatsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// 練習回数更新Notifier
@Riverpod(keepAlive: true)
class OriginalContentPractice extends _$OriginalContentPractice {
  @override
  FutureOr<void> build() {
    // 初期状態は何もしない
  }

  /// 練習回数をインクリメント
  Future<OriginalContent> incrementPracticeCount(String id) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(originalContentRepositoryProvider);
      final content = await repository.updatePracticeCount(id);
      // コンテンツ一覧を更新
      ref.invalidate(originalContentsProvider);
      ref.invalidate(originalContentProvider(id));
      ref.invalidate(originalContentStatsProvider);
      state = const AsyncData(null);
      return content;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// 音声パスとセグメント（タイムスタンプ付き）を更新
  Future<OriginalContent> updateAudioWithSegments(
    String id,
    String audioPath,
    int durationSeconds,
    List<TextSegment> segments,
  ) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(originalContentRepositoryProvider);
      final content = await repository.updateAudioWithSegments(
        id,
        audioPath,
        durationSeconds,
        segments,
      );
      // コンテンツを更新
      ref.invalidate(originalContentsProvider);
      ref.invalidate(originalContentProvider(id));
      state = const AsyncData(null);
      return content;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
