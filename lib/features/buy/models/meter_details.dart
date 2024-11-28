

import 'package:json_annotation/json_annotation.dart';

part 'meter_details.g.dart';

@JsonSerializable()
class MeterDetails {
  final String customerName;
  final String? customerPhone;
  final String customerAddress;
  final double price;
  final double vat;
  final String currency;
  final String unit;
  final String provider;
  final String number;

  MeterDetails({
    required this.customerName,
    this.customerPhone,
    required this.customerAddress,
    required this.price,
    required this.vat,
    required this.currency,
    required this.unit,
    required this.provider,
    required this.number,
  });

  factory MeterDetails.fromJson(Map<String, dynamic> json) =>
      _$MeterDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MeterDetailsToJson(this);
}
