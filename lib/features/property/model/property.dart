import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String id;
  final String name;
  final String address;
  final String meterNumber;

  const Property({
    required this.id,
    required this.name,
    required this.address,
    required this.meterNumber,
  });

  /// Factory constructor for JSON deserialization
  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  /// Method for JSON serialization
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  /// Copy with method for immutability
  ///
  /// Allows creating a new instance of [Property] with updated values
  Property copyWith({
    String? id,
    String? name,
    String? address,
    String? meterNumber,
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      meterNumber: meterNumber ?? this.meterNumber,
    );
  }

  List<Object> get props => [id, name, address, meterNumber];
}
