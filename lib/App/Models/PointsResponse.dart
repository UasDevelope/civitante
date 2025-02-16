class PointsResponse {
  final int availablePoints;
   bool paymentId;
  final List<TransactionHistory> transactionHistory;

  PointsResponse({
    required this.availablePoints,
    required this.paymentId,
    required this.transactionHistory,
  });

  factory PointsResponse.fromJson(Map<String, dynamic> json) {
    return PointsResponse(
      availablePoints: json['availablePoints'] as int,
      paymentId: json["paymentId"],
      transactionHistory: (json['transactionHistory'] as List)
          .map((item) => TransactionHistory.fromJson(item))
          .toList(),
    );
  }
}

class TransactionHistory {
  final String id;
  final String userId;
  final String type;
  final int points;
  final int? amountSpent;
  final String? reason;
  final DateTime createdAt;
  final int version;

  TransactionHistory({
    required this.id,
    required this.userId,
    required this.type,
    required this.points,
    this.amountSpent,
    this.reason,
    required this.createdAt,
    required this.version,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      points: json['points'] as int,
      amountSpent: json['amountSpent'] as int?,
      reason: json['reason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      version: json['__v'] as int,
    );
  }
}
