class PaymentMethod {
  final String id;
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cardType;
  final String email;
  final int cvv;

  PaymentMethod({
    required this.id,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    required this.email,
    required this.cvv,
  });

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
      cardType: json['cardType'] ?? '',
      email: json['email'] ?? '',
      cvv: json['cvv'] is int ? json['cvv'] : int.tryParse(json['cvv'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'email': email,
      'cvv': cvv,
    };
  }
}
