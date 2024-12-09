import 'package:json_annotation/json_annotation.dart';
import 'package:utility_token_app/features/buy/models/tariff.dart';

part 'purchase_history.g.dart';

@JsonSerializable()
class PurchaseHistory {
  final int id;
  final String meter;
  final String currency;
  final String amount;
  final String unitPrice;
  final String vat;
  final List<Tariff> tariffs;
  final String volume;
  final String token;
  final DateTime createdAt;

  PurchaseHistory({
    required this.id,
    required this.meter,
    required this.currency,
    required this.amount,
    required this.unitPrice,
    required this.vat,
    required this.tariffs,
    required this.volume,
    required this.token,
    required this.createdAt,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) =>
      _$PurchaseHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseHistoryToJson(this);
}

