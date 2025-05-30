import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_api_service.dart';
import '../services/product_api_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryApiService _apiService = CategoryApiService();
  final ProductApiService _productApiService = ProductApiService();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => [..._categories];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners(); // Notificar que empieza la carga

    try {
      // Fetch categories first
      final categoriesData = await _apiService.fetchCategories();

      // Fetch all products to count them per category
      final allProducts = await _productApiService.fetchProducts(limit: 100);

      // Count products per category
      final categoryProductCount = <int, int>{};
      for (final product in allProducts) {
        categoryProductCount[product.categoryId] =
            (categoryProductCount[product.categoryId] ?? 0) + 1;
      }

      // Update categories with product count
      _categories =
          categoriesData.map((category) {
            return CategoryModel(
              id: category.id,
              name: category.name,
              image: category.image,
              parentId: category.parentId,
              subcategories: category.subcategories,
              productCount: categoryProductCount[category.id] ?? 0,
            );
          }).toList();
    } catch (e) {
      print('Error al cargar categorías: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Siempre se notifica que terminó
    }
  }
}
