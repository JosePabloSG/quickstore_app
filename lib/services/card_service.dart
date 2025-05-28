import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_method.dart';
import '../config/env.dart';

class CardService {
  final String apiUrl = Env.paymentMethodsApiUrl;

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment methods');
      }
    } catch (e) {
      // En caso de error en la conexión o parsing, devolvemos una lista vacía
      print('Error fetching payment methods: $e');
      return [];
    }
  }

  Future<PaymentMethod?> addPaymentMethod(PaymentMethod card) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(card.toJson()),
      );

      if (response.statusCode == 201) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add payment method');
      }
    } catch (e) {
      print('Error adding payment method: $e');
      return null;
    }
  }

  Future<bool> deletePaymentMethod(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting payment method: $e');
      return false;
    }
  }
}
