import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/domain/providers/auth_providers.dart';
import '../../data/models/typing_models.dart';
import '../../data/repositories/typing_repository.dart';

part 'typing_providers.g.dart';

@riverpod
TypingRepository typingRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return TypingRepository(apiClient: apiClient);
}

@riverpod
class OfflineQueue extends _$OfflineQueue {
  @override
  FutureOr<List<PendingCompletion>> build() async {
    final repository = ref.watch(typingRepositoryProvider);
    return repository.loadPendingCompletions();
  }

  Future<void> enqueue(PendingCompletion completion) async {
    if (!ref.mounted) return;
    state = const AsyncLoading();

    final repository = ref.watch(typingRepositoryProvider);
    await repository.enqueueCompletion(completion);

    // 非同期処理後にproviderがまだマウントされているか確認
    if (!ref.mounted) return;

    final refreshed = await repository.loadPendingCompletions();

    // 再度確認
    if (!ref.mounted) return;

    state = AsyncData(refreshed);
  }

  Future<void> processQueue() async {
    final repository = ref.watch(typingRepositoryProvider);
    await repository.processQueue();

    // 非同期処理後にproviderがまだマウントされているか確認
    if (!ref.mounted) return;

    final refreshed = await repository.loadPendingCompletions();

    // 再度確認
    if (!ref.mounted) return;

    state = AsyncData(refreshed);
  }
}
