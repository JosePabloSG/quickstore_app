import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', title: 'Camisa', imageUrl: 'https://via.placeholder.com/150', price: 29.99),
    Product(id: '2', title: 'Zapatos', imageUrl: 'https://via.placeholder.com/150', price: 59.99),
    Product(id: '3', title: 'Pantalón', imageUrl: 'https://via.placeholder.com/150', price: 39.99),
    // Puedes agregar más simulados
  ];

  List<Product> get products => [..._products];

  // Método para simular recarga futura
  Future<void> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay de red
    notifyListeners(); // En caso de que la lista cambie
  }
}
