// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'municipality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Municipality _$MunicipalityFromJson(Map<String, dynamic> json) => Municipality(
      id: json['id'] as String,
      name: json['name'] as String,
      endpoint: json['endpoint'] as String,
      type: json['type'] as String,
      active: (json['active'] as num).toInt(),
    );

Map<String, dynamic> _$MunicipalityToJson(Municipality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'endpoint': instance.endpoint,
      'active': instance.active,
      'type': instance.type
    };
