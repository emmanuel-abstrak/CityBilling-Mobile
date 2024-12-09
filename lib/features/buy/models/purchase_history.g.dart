// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseHistory _$PurchaseHistoryFromJson(Map<String, dynamic> json) =>
    PurchaseHistory(
      id: (json['id'] as num).toInt(),
      meter: json['meter'] as String,
      currency: json['currency'] as String,
      amount: json['amount'] as String,
      unitPrice: json['unitPrice'] as String,
      vat: json['vat'] as String,
      tariffs: (json['tariffs'] as List<dynamic>)
          .map((e) => Tariff.fromJson(e as Map<String, dynamic>))
          .toList(),
      volume: json['volume'] as String,
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PurchaseHistoryToJson(PurchaseHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meter': instance.meter,
      'currency': instance.currency,
      'amount': instance.amount,
      'unitPrice': instance.unitPrice,
      'vat': instance.vat,
      'tariffs': instance.tariffs,
      'volume': instance.volume,
      'token': instance.token,
      'createdAt': instance.createdAt.toIso8601String(),
    };
