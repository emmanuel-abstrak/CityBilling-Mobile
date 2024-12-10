import 'package:json_annotation/json_annotation.dart';

part 'tariff.g.dart';

@JsonSerializable()
class Tariff {
  final String name;
  final double amount; // Adjusted for precision.
  final int statementItemId;

  Tariff({
    required this.name,
    required this.amount,
    required this.statementItemId,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      name: json['name'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0, // Handle nulls.
      statementItemId: (json['statement_item_id'] as num?)?.toInt() ?? 0, // Added null safety.
    );
  }

  Map<String, dynamic> toJson() => _$TariffToJson(this);
}
