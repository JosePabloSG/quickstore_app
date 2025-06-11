import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ShippingAddressService {
  static const String baseUrl =
      'https://682f4084f504aa3c70f35128.mockapi.io/shipping-address';

  // Obtener las direcciones de un usuario
  Future<List<Address>> getAddresses({required String userEmail}) async {
    try {
      // Agregamos el email como parámetro de consulta
      final uri = Uri.parse(
        baseUrl,
      ).replace(queryParameters: {'email': userEmail});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .where((json) => json['email'] == userEmail) // Filtramos por email
            .map(
              (json) => Address(
                id: json['id'],
                street: json['street'],
                city: json['city'],
                state: json['state'],
                zipCode: json['zipCode'],
                country: json['country'],
                label: json['label'],
                email: json['email'],
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  // Crear una nueva dirección
  Future<Address> createAddress(Address address) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'street': address.street,
          'city': address.city,
          'state': address.state,
          'zipCode': address.zipCode,
          'country': address.country,
          'label': address.label,
          'email': address.email,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Address(
          id: data['id'],
          street: data['street'],
          city: data['city'],
          state: data['state'],
          zipCode: data['zipCode'],
          country: data['country'],
          label: data['label'],
          email: address.email,
        );
      } else {
        throw Exception('Failed to create address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating address: $e');
    }
  }

  // Actualizar una dirección existente
  Future<Address> updateAddress(Address address) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${address.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'street': address.street,
          'city': address.city,
          'state': address.state,
          'zipCode': address.zipCode,
          'country': address.country,
          'label': address.label,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Address(
          id: data['id'],
          street: data['street'],
          city: data['city'],
          state: data['state'],
          zipCode: data['zipCode'],
          country: data['country'],
          label: data['label'],
          email: address.email,
        );
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  // Eliminar una dirección
  Future<void> deleteAddress(String addressId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$addressId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }
}
