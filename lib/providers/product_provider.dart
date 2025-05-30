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

  List<Product> _popularProducts = [];
  List<Product> get popularProducts => [..._popularProducts];

  List<Product> _recommendedProducts = [];
  List<Product> get recommendedProducts => [..._recommendedProducts];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMoreItems = true;
  bool get hasMoreItems => _hasMoreItems;

  int? _currentCategoryId;
  int? get currentCategoryId => _currentCategoryId;

  int _page = 1;
  int _itemsPerPage = 10;

  Future<void> fetchProducts({bool refresh = false, int? page}) async {
    if (refresh) {
      _page = 1;
      _hasMoreItems = true;
      _allProducts.clear();
      _products.clear();
      _filteredProducts.clear();
    }

    if (!_hasMoreItems && !refresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _apiService.fetchProducts(
        page: page ?? _page,
        limit: _itemsPerPage,
      );
      _allProducts.addAll(newProducts);

      // Sort by popularity and set popular products
      // Sort by popularity for best sellers
      final sortedByPopularity = List<Product>.from(newProducts)
        ..sort((a, b) => b.rating.compareTo(a.rating));
      _popularProducts = sortedByPopularity.take(5).toList();

      // Sort by relevance based on user's history
      // TODO: Implement actual user history logic
      _recommendedProducts = List<Product>.from(
        newProducts,
      )..sort((a, b) => (b.reviews * b.rating).compareTo(a.reviews * a.rating));
      _recommendedProducts = _recommendedProducts.take(5).toList();

      if (_currentCategoryId != null) {
        _updateFilteredProductsByCategory();
      } else {
        _products.addAll(newProducts);
        _filteredProducts = [..._products];
      }

      _hasMoreItems = newProducts.length >= _itemsPerPage;
      _page++;
    } catch (e) {
      print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _updateFilteredProductsByCategory() {
    _products =
        _allProducts
            .where((product) => product.categoryId == _currentCategoryId)
            .toList();
    _filteredProducts = [..._products];
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    if (_currentCategoryId == categoryId && _products.isNotEmpty) {
      // Si ya estamos mostrando esta categoría, no hacemos nada
      return;
    }

    _currentCategoryId = categoryId;
    _page = 1;
    _hasMoreItems = true;
    _products.clear();
    _filteredProducts.clear();
    _allProducts.clear();

    _isLoading = true;
    notifyListeners();

    try {
      final List<Product> products = await _apiService.fetchProductsByCategory(
        categoryId,
        limit: _itemsPerPage,
      );

      if (products.isNotEmpty) {
        _products = products;
        _filteredProducts = products;
        _allProducts = products;
        _hasMoreItems = products.length >= _itemsPerPage;

        // También actualizar productos populares y recomendados de esta categoría
        var popularProducts = List<Product>.from(products);
        popularProducts.sort((a, b) => b.rating.compareTo(a.rating));
        _popularProducts = popularProducts.take(5).toList();

        var recommendedProducts = List<Product>.from(products);
        recommendedProducts.sort(
          (a, b) => (b.reviews * b.rating).compareTo(a.reviews * a.rating),
        );
        _recommendedProducts = recommendedProducts.take(5).toList();
      }
    } catch (e) {
      print('Error fetching products by category: $e');
    }

    _isLoading = false;
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

  Future<void> resetProducts() async {
    _currentCategoryId = null;
    _page = 1;
    _hasMoreItems = true;
    _products.clear();
    _filteredProducts.clear();
    _allProducts.clear();

    // En lugar de llamar a fetchProducts directamente,
    // usamos el método de la clase con refresh = true
    await fetchProducts(refresh: true);
  }
}
