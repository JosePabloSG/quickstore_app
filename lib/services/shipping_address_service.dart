import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';

class ShippingAddressService {
  final String apiUrl = 'https://682f4084f504aa3c70f35128.mockapi.io/shipping-address';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Address>> getAddresses() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => Address.fromMap(json))
            .where((address) => address.email == user.email)
            .toList();
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      print('Error fetching addresses: $e');
      return [];
    }
  }

  Future<Address> createAddress(Address address) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      // Asegurarnos de que la dirección tenga el correo del usuario
      final addressWithEmail = Address(
        id: address.id,
        street: address.street,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        country: address.country,
        label: address.label,
        isDefault: address.isDefault,
        email: user.email!, // Agregamos el email del usuario
      );

      print('DEBUG - Creando dirección con datos:');
      print('DEBUG - ID: ${addressWithEmail.id}');
      print('DEBUG - Street: ${addressWithEmail.street}');
      print('DEBUG - City: ${addressWithEmail.city}');
      print('DEBUG - State: ${addressWithEmail.state}');
      print('DEBUG - ZipCode: ${addressWithEmail.zipCode}');
      print('DEBUG - Country: ${addressWithEmail.country}');
      print('DEBUG - Label: ${addressWithEmail.label}');
      print('DEBUG - IsDefault: ${addressWithEmail.isDefault}');
      print('DEBUG - Email: ${addressWithEmail.email}');

      final jsonBody = json.encode(addressWithEmail.toMap());
      print('DEBUG - JSON a enviar: $jsonBody');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      print('DEBUG - Status code: ${response.statusCode}');
      print('DEBUG - Response body: ${response.body}');

      if (response.statusCode == 201) {
        return Address.fromMap(json.decode(response.body));
      } else {
        throw Exception('Failed to create address: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating address: $e');
      rethrow;
    }
  }

  Future<Address> updateAddress(Address address) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      // Asegurarnos de que la dirección tenga el correo del usuario
      final addressWithEmail = Address(
        id: address.id,
        street: address.street,
        city: address.city,
        state: address.state,
        zipCode: address.zipCode,
        country: address.country,
        label: address.label,
        isDefault: address.isDefault,
        email: user.email!, // Agregamos el email del usuario
      );

      final response = await http.put(
        Uri.parse('$apiUrl/${address.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(addressWithEmail.toMap()),
      );

      if (response.statusCode == 200) {
        return Address.fromMap(json.decode(response.body));
      } else {
        throw Exception('Failed to update address');
      }
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }
}
