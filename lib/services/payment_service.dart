import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment.dart';

class PaymentService {
  final String baseUrl = 'https://682f4084f504aa3c70f35128.mockapi.io/Payments_methods';

  Future<List<Payment>> getPaymentsForCard(String paymentMethodId) async {
    try {
      final url = Uri.parse('$baseUrl/$paymentMethodId/Payments');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Payment.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching payments: $e');
      return [];
    }
  }

  Future<Payment?> addPayment(String paymentMethodId, Payment payment) async {
    try {
      final url = Uri.parse('$baseUrl/$paymentMethodId/Payments');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payment.toJson()),
      );

      if (response.statusCode == 201) {
        return Payment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add payment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding payment: $e');
      return null;
    }
  }

  Future<bool> deletePayment(String paymentMethodId, String paymentId) async {
    try {
      final url = Uri.parse('$baseUrl/$paymentMethodId/Payments/$paymentId');
      final response = await http.delete(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting payment: $e');
      return false;
    }
  }
}
