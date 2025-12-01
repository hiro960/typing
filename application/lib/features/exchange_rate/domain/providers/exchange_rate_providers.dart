import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chaletta/features/auth/domain/providers/auth_providers.dart';
import 'package:chaletta/features/exchange_rate/data/models/exchange_rate_model.dart';
import 'package:chaletta/features/exchange_rate/data/repositories/exchange_rate_repository.dart';

part 'exchange_rate_providers.g.dart';

/// ExchangeRateRepository プロバイダー
@riverpod
ExchangeRateRepository exchangeRateRepository(Ref ref) {
  final apiClient = ref.watch(apiClientServiceProvider);
  return ExchangeRateRepository(apiClient: apiClient);
}

/// 為替レートプロバイダー（JPY→KRW）
@riverpod
Future<ExchangeRate> exchangeRate(Ref ref) async {
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return repository.fetchExchangeRate(base: 'JPY', target: 'KRW');
}
