// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tariff _$TariffFromJson(Map<String, dynamic> json) => Tariff(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      statementItemId: (json['statementItemId'] as num).toInt(),
    );

Map<String, dynamic> _$TariffToJson(Tariff instance) => <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'statementItemId': instance.statementItemId,
    };
