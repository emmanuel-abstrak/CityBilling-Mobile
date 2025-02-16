class Meter {
  final String provider;
  final String number;
  final String name;

  Meter({required this.provider, required this.number, required this.name});

  /// Convert a `Meter` object to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'number': number,
      'name': name,
    };
  }

  /// Create a `Meter` object from JSON
  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      provider: json['provider'],
      number: json['number'] as String,
      name: json['name'] as String,
    );
  }
}
