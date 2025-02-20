class UtilityProvider {
  final String id;
  final String name;
  final String endpoint;

  UtilityProvider({
    required this.id,
    required this.name,
    required this.endpoint,
  });

  // Factory method to create a UtilityProvider from JSON
  factory UtilityProvider.fromJson(Map<String, dynamic> json) {
    return UtilityProvider(
      id: json['id'].toString(),
      name: json['name'].toString(),
      endpoint: json['endpoint'].toString(),
    );
  }

  // Convert a UtilityProvider object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'endpoint': endpoint,
    };
  }
}
