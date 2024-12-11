

import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:utility_token_app/features/municipalities/models/municipality.dart';

import '../../municipalities/state/municipalities_controller.dart';

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
  final Municipality municipality;

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
    required this.municipality,
  });

  factory MeterDetails.fromJson(Map<String, dynamic> json) => MeterDetails(
    customerName: json['customerName'] as String,
    customerPhone: json['customerPhone'] as String?,
    customerAddress: json['customerAddress'] as String,
    price: (json['price'] as num).toDouble(),
    vat: (json['vat'] as num).toDouble(),
    currency: json['currency'] as String,
    unit: json['unit'] as String,
    provider: json['provider'] as String,
    number: json['number'] as String,
    municipality: Get.find<MunicipalityController>().selectedMunicipality.value!
  );

  Map<String, dynamic> toJson() => _$MeterDetailsToJson(this);
}
