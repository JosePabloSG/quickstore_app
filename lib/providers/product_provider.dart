import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  List<Product> _allProducts = [];
  List<Product> get allProducts => [..._allProducts];

  List<Product> _products = [];
  List<Product> get products => [..._products];

  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => [..._filteredProducts];

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
      _filteredProducts = [..._products]; // inicializa con todos
      print('Productos cargados: ${_products.length}');
    } catch (e) {
      print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchProductsByCategory(int categoryId) {
    _currentCategoryId = categoryId;
    _products =
        _allProducts
            .where((product) => product.categoryId == categoryId)
            .toList();
    _filteredProducts = [..._products];
    notifyListeners();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [..._products];
    } else {
      _filteredProducts =
          _products
              .where(
                (product) =>
                    product.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }

  void resetProducts() {
    _currentCategoryId = null;
    _products = [..._allProducts];
    _filteredProducts = [..._products];
    notifyListeners();
  }
}
