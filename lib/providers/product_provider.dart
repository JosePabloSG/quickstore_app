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

  //Filtros avanzados
  double? _minPrice;
  double? _maxPrice;
  List<int> _selectedCategoryIds = [];
  double? _minRating;
  bool _onlyInStock = false;
  bool _onlyWithDiscount = false;
  //Filtros avanzados

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
    _currentCategoryId = categoryId;
    _page = 1;
    _hasMoreItems = true;
    _products.clear();
    _filteredProducts.clear();

    _isLoading = true;
    notifyListeners();

    try {
      final products = await _apiService.fetchProductsByCategory(categoryId);
      _products = products;
      _filteredProducts = [...products];
      _hasMoreItems = products.length >= _itemsPerPage;
    } catch (e) {
      print('Error fetching products by category: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  //Metodo para establecer filtros avanzados
  void setAdvancedFilters({
    double? minPrice,
    double? maxPrice,
    List<int>? categoryIds,
    double? minRating,
    bool? onlyInStock,
    bool? onlyWithDiscount,
  }) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _selectedCategoryIds = categoryIds ?? [];
    _minRating = minRating;
    _onlyInStock = onlyInStock ?? false;
    _onlyWithDiscount = onlyWithDiscount ?? false;
    applyAdvancedFilters();
  }

  //Metodo para aplicar los filtros avanzados
  void applyAdvancedFilters() {
    _filteredProducts =
        _allProducts.where((product) {
          final matchesPrice =
              (_minPrice == null || product.price >= _minPrice!) &&
              (_maxPrice == null || product.price <= _maxPrice!);

          final matchesCategory =
              _selectedCategoryIds.isEmpty ||
              _selectedCategoryIds.contains(product.categoryId);

          final matchesRating =
              _minRating == null || product.rating >= _minRating!;

          final matchesStock = !_onlyInStock || product.stock > 0;

          final matchesDiscount = !_onlyWithDiscount || product.hasPriceChanged;

          return matchesPrice &&
              matchesCategory &&
              matchesRating &&
              matchesStock &&
              matchesDiscount;
        }).toList();

    notifyListeners();
  }

  void resetProducts() {
    _currentCategoryId = null;
    _page = 1;
    _hasMoreItems = true;
    _products = [..._allProducts];
    _filteredProducts = [..._products];
    notifyListeners();
  }
}
