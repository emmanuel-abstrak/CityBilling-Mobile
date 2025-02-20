class Transaction {
  final String id;
  final String provider;
  final String meter;
  final double tokenAmount;
  final String? token;
  final String date;
  final String time;
  final double volumePurchased;
  final String utilityType;
  final String currencyCode;

  Transaction({
    required this.id,
    required this.provider,
    required this.meter,
    required this.tokenAmount,
    this.token,
    required this.date,
    required this.time,
    required this.volumePurchased,
    required this.utilityType,
    required this.currencyCode,
  });

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'meter': meter,
      'tokenAmount': tokenAmount,
      'token': token,
      'date': date,
      'time': time,
      'volumePurchased': volumePurchased,
      'utilityType': utilityType,
      'currencyCode': currencyCode,
    };
  }

  /// Create a Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      provider: json['provider'],
      meter: json['meter'],
      tokenAmount: json['tokenAmount'].toDouble(),
      token: json['token'],
      date: json['date'],
      time: json['time'],
      volumePurchased: json['volumePurchased'].toDouble(),
      utilityType: json['utilityType'],
      currencyCode: json['currencyCode'],
    );
  }

  /// **Format Token for Display (Group in 5s)**
  String get formattedToken {
    if (token == null || token!.length != 25) return "Pending";
    return token!
        .replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} ");
  }
}
