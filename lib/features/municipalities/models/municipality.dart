import 'package:json_annotation/json_annotation.dart';

part 'municipality.g.dart';

@JsonSerializable()
class Municipality {
  final String id;
  final String name;
  final String endpoint;
  final String type;
  final int active;

  Municipality({
    required this.id,
    required this.name,
    required this.endpoint,
    required this.type,
    required this.active,
  });

  /// A factory constructor for creating a new `Municipality` instance
  /// from a map. Pass the map to the generated `_$MunicipalityFromJson()` function.
  factory Municipality.fromJson(Map<String, dynamic> json) => _$MunicipalityFromJson(json);

  /// A method that converts the `Municipality` instance into a map.
  /// Pass the map to the generated `_$MunicipalityToJson()` function.
  Map<String, dynamic> toJson() => _$MunicipalityToJson(this);
}
