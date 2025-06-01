import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/payment_method.dart';

class CardService {
  final String apiUrl = 'https://682f4084f504aa3c70f35128.mockapi.io/Payments_methods';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final response = await http.get(Uri.parse(apiUrl));

      print('RESPONSE STATUS: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data
            .map((json) => PaymentMethod.fromJson(json))
            .where((pm) => pm.email == user.email)
            .toList();
      } else {
        throw Exception('Failed to load payment methods');
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
      return [];
    }
  }

  Future<PaymentMethod?> addPaymentMethod(PaymentMethod card) async {
    try {
      final jsonBody = json.encode(card.toJson());

      print('DEBUG - JSON enviado: $jsonBody');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      print('DEBUG - Status code: ${response.statusCode}');
      print('DEBUG - Response body: ${response.body}');

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

  Future<PaymentMethod?> updatePaymentMethod(PaymentMethod card) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${card.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(card.toJson()),
      );

      if (response.statusCode == 200) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update payment method');
      }
    } catch (e) {
      print('Error updating payment method: $e');
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
