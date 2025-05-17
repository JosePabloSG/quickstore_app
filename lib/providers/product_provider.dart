import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _allProducts = []; // Todos los productos sin filtrar
  List<Product> get allProducts => [..._allProducts];

  List<Product> _products = []; // Productos visibles actualmente
  List<Product> get products => [..._products];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchProducts(); // Carga todos
      _products = [..._allProducts]; // Se muestran todos inicialmente
      print('Productos cargados: ${_products.length}');
    } catch (e) {
      print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchProductsByCategory(int categoryId) {
    _products = _allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
    notifyListeners();
  }

  void resetProducts() {
    _products = [..._allProducts];
    notifyListeners();
  }
}
