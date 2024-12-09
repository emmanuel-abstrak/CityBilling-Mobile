import 'package:json_annotation/json_annotation.dart';

part 'tariff.g.dart';


@JsonSerializable()
class Tariff {
  final String name;
  final double amount;
  final int statementItemId;

  Tariff({
    required this.name,
    required this.amount,
    required this.statementItemId,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);

  Map<String, dynamic> toJson() => _$TariffToJson(this);
}
