import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BalanceItem {
  final int statementItemId;
  final String name;
  final double amount;

  BalanceItem({
    required this.statementItemId,
    required this.name,
    required this.amount, // Keep this non-nullable
  });

  factory BalanceItem.fromJson(Map<String, dynamic> json) {
    return BalanceItem(
      statementItemId: json['statement_item_id'] as int,
      name: json['name'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

}
