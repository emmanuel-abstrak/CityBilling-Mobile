import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String accessToken;
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;

  User({
    required this.accessToken,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  /// A factory constructor for creating a `User` instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// A method for converting a `User` instance to a JSON map.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
