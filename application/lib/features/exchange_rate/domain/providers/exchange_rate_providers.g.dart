// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ExchangeRateRepository プロバイダー

@ProviderFor(exchangeRateRepository)
const exchangeRateRepositoryProvider = ExchangeRateRepositoryProvider._();

/// ExchangeRateRepository プロバイダー

final class ExchangeRateRepositoryProvider
    extends
        $FunctionalProvider<
          ExchangeRateRepository,
          ExchangeRateRepository,
          ExchangeRateRepository
        >
    with $Provider<ExchangeRateRepository> {
  /// ExchangeRateRepository プロバイダー
  const ExchangeRateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExchangeRateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExchangeRateRepository create(Ref ref) {
    return exchangeRateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExchangeRateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExchangeRateRepository>(value),
    );
  }
}

String _$exchangeRateRepositoryHash() =>
    r'545de01698523a9dadb8d35885376c5304d6b31c';

/// 為替レートプロバイダー（JPY→KRW）

@ProviderFor(exchangeRate)
const exchangeRateProvider = ExchangeRateProvider._();

/// 為替レートプロバイダー（JPY→KRW）

final class ExchangeRateProvider
    extends
        $FunctionalProvider<
          AsyncValue<ExchangeRate>,
          ExchangeRate,
          FutureOr<ExchangeRate>
        >
    with $FutureModifier<ExchangeRate>, $FutureProvider<ExchangeRate> {
  /// 為替レートプロバイダー（JPY→KRW）
  const ExchangeRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateHash();

  @$internal
  @override
  $FutureProviderElement<ExchangeRate> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ExchangeRate> create(Ref ref) {
    return exchangeRate(ref);
  }
}

String _$exchangeRateHash() => r'8ea684926e1e889e96b0c9492782e475a86c6e7d';
