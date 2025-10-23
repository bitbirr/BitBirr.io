class Order {
  final String id;
  final String userId;
  final String asset;
  final double etbAmount;
  final double cryptoAmount;
  final String paymentMethod;
  final String receiverAddress;
  final String status;
  final String? txHash;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.asset,
    required this.etbAmount,
    required this.cryptoAmount,
    required this.paymentMethod,
    required this.receiverAddress,
    required this.status,
    this.txHash,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      asset: json['asset'] as String,
      etbAmount: (json['etb_amount'] as num).toDouble(),
      cryptoAmount: (json['crypto_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      receiverAddress: json['receiver_address'] as String,
      status: json['status'] as String,
      txHash: json['tx_hash'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'asset': asset,
      'etb_amount': etbAmount,
      'crypto_amount': cryptoAmount,
      'payment_method': paymentMethod,
      'receiver_address': receiverAddress,
      'status': status,
      'tx_hash': txHash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending Payment';
      case 'paid':
        return 'Payment Confirmed';
      case 'processing':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
