class PaymentMethod {
  final String id;
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cardType; // 'visa', 'mastercard', etc.
  final String? cvv;

  PaymentMethod({
    required this.id,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.cvv,
  });

  // Para mostrar solo los últimos 4 dígitos de la tarjeta
  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      cardHolder: json['cardHolder'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      cardType: json['cardType'] ?? 'visa',
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'cvv': cvv,
    };
  }
}
