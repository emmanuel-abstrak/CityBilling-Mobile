// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterDetails _$MeterDetailsFromJson(Map<String, dynamic> json) => MeterDetails(
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String?,
      customerAddress: json['customerAddress'] as String,
      price: (json['price'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String,
      provider: json['provider'] as String,
      number: json['number'] as String,
    );

Map<String, dynamic> _$MeterDetailsToJson(MeterDetails instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerAddress': instance.customerAddress,
      'price': instance.price,
      'vat': instance.vat,
      'currency': instance.currency,
      'unit': instance.unit,
      'provider': instance.provider,
      'number': instance.number,
    };
