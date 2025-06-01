class Payment {
  final String paymentsMethodId;
  final double amount;
  final DateTime hourDate;
  final int orderNumber;

  Payment({

    required this.paymentsMethodId,
    required this.amount,
    required this.hourDate,
    required this.orderNumber,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentsMethodId: json['Payments_methodId'] ?? '',
      amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
      hourDate: DateTime.tryParse(json['HourDate'] ?? '') ?? DateTime.now(),
      orderNumber: int.tryParse(json['OrderNumber'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Payments_methodId': paymentsMethodId,
      'Amount': amount,
      'HourDate': hourDate.toIso8601String(),
      'OrderNumber': orderNumber,
    };
  }
}
