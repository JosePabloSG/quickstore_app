import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _products = [];
  List<Product> get products => [..._products];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {  
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
      print('Productos cargados: ${_products.length}');
    } catch (e) {
      print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.fetchProductsByCategory(categoryId);
    } catch (e) {
      print('Error al filtrar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
