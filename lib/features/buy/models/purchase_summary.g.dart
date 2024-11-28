// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseSummary _$PurchaseSummaryFromJson(Map<String, dynamic> json) =>
    PurchaseSummary(
      amount: (json['amount'] as num).toDouble(),
      balances: (json['balances'] as List<dynamic>)
          .map((e) => BalanceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      vat: (json['vat'] as num).toDouble(),
      tokenAmount: (json['tokenAmount'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      currency: json['currency'] as String,
      meter: MeterDetails.fromJson(json['meter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseSummaryToJson(PurchaseSummary instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'balances': instance.balances,
      'vat': instance.vat,
      'tokenAmount': instance.tokenAmount,
      'volume': instance.volume,
      'currency': instance.currency,
      'meter': instance.meter,
    };
