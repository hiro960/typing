import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_model.freezed.dart';
part 'exchange_rate_model.g.dart';

/// 為替レートモデル
@freezed
abstract class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required DateTime fetchedAt,
  }) = _ExchangeRate;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);
}
