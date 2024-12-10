import 'dart:convert';

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

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      id: (json['id'] as num?)?.toInt() ?? 0,
      meter: json['meter'] as String,
      currency: json['currency'] as String,
      amount: json['amount'] as String,
      unitPrice: json['unitPrice'] as String,
      vat: json['vat'] as String,
      tariffs: (json['tariffs'] != null && json['tariffs'] is String)
          ? (jsonDecode(json['tariffs']) as List<dynamic>)
          .map((e) => Tariff.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
      volume: json['volume'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => _$PurchaseHistoryToJson(this);

  /// Calculates the total amount by adding the `amount` and tariffs' amounts.
  double get totalAmount {
    final double parsedAmount = double.tryParse(amount) ?? 0.0;

    final double tariffsTotal = tariffs.fold(0.0, (sum, tariff) => sum + tariff.amount);

    return parsedAmount + tariffsTotal;
  }
}

