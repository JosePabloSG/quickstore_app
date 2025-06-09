import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/payment_method.dart';

class PaymentMethodService {
  final String apiUrl = 'https://682f4084f504aa3c70f35128.mockapi.io/payment-methods';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => PaymentMethod.fromJson(json))
            .where((method) => method.email == user.email)
            .toList();
      } else {
        throw Exception('Failed to load payment methods');
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
      return [];
    }
  }

  Future<PaymentMethod> createPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      // Asegurarnos de que el método de pago tenga el correo del usuario
      final methodWithEmail = PaymentMethod(
        id: paymentMethod.id,
        cardNumber: paymentMethod.cardNumber,
        cardHolderName: paymentMethod.cardHolderName,
        expiryDate: paymentMethod.expiryDate,
        cvv: paymentMethod.cvv,
        email: user.email!,
        isDefault: paymentMethod.isDefault,
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(methodWithEmail.toJson()),
      );

      if (response.statusCode == 201) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create payment method');
      }
    } catch (e) {
      print('Error creating payment method: $e');
      rethrow;
    }
  }

  Future<PaymentMethod> updatePaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      // Asegurarnos de que el método de pago tenga el correo del usuario
      final methodWithEmail = PaymentMethod(
        id: paymentMethod.id,
        cardNumber: paymentMethod.cardNumber,
        cardHolderName: paymentMethod.cardHolderName,
        expiryDate: paymentMethod.expiryDate,
        cvv: paymentMethod.cvv,
        email: user.email!,
        isDefault: paymentMethod.isDefault,
      );

      final response = await http.put(
        Uri.parse('$apiUrl/${paymentMethod.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(methodWithEmail.toJson()),
      );

      if (response.statusCode == 200) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update payment method');
      }
    } catch (e) {
      print('Error updating payment method: $e');
      rethrow;
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete payment method');
      }
    } catch (e) {
      print('Error deleting payment method: $e');
      rethrow;
    }
  }
} 