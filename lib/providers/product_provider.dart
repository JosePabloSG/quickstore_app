import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _allProducts = [];
  List<Product> get allProducts => [..._allProducts];

  List<Product> _products = [];
  List<Product> get products => [..._products];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _currentCategoryId;
  int? get currentCategoryId => _currentCategoryId;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchProducts();
      if (_currentCategoryId != null) {
        fetchProductsByCategory(_currentCategoryId!);
      } else {
        _products = [..._allProducts];
      }
      print('Productos cargados: ${_products.length}');
    } catch (e) {
      print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchProductsByCategory(int categoryId) {
    _currentCategoryId = categoryId;
    _products = _allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
    notifyListeners();
  }

  void resetProducts() {
    _currentCategoryId = null;
    _products = [..._allProducts];
    notifyListeners();
  }
}
