import 'package:json_annotation/json_annotation.dart';

import 'balance_item.dart';
import 'meter_details.dart';

part 'purchase_summary.g.dart';

@JsonSerializable()
class PurchaseSummary {
  final double amount;
  final List<BalanceItem> balances;
  final double vat;
  final double tokenAmount;
  final double volume;
  final String currency;
  final MeterDetails meter;

  PurchaseSummary({
    required this.amount,
    required this.balances,
    required this.vat,
    required this.tokenAmount,
    required this.volume,
    required this.currency,
    required this.meter,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseSummaryToJson(this);
}

