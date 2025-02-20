class Currency {
  final String id;
  final String name;
  final String code;
  final String symbol;
  final double rate;
  final bool isActive;

  Currency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
    required this.rate,
    required this.isActive,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      symbol: json['symbol'],
      rate: json['rate'].toDouble(),
      isActive: json['is_active'],
    );
  }
}
