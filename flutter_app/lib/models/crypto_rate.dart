class CryptoRate {
  final String id;
  final String symbol;
  final double etbPerUnit;
  final DateTime updatedAt;

  CryptoRate({
    required this.id,
    required this.symbol,
    required this.etbPerUnit,
    required this.updatedAt,
  });

  factory CryptoRate.fromJson(Map<String, dynamic> json) {
    return CryptoRate(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      etbPerUnit: (json['etb_per_unit'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'etb_per_unit': etbPerUnit,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayName {
    switch (symbol) {
      case 'BTC':
        return 'Bitcoin';
      case 'ETH':
        return 'Ethereum';
      case 'USDT':
        return 'Tether USD';
      default:
        return symbol;
    }
  }
}
