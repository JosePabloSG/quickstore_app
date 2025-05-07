import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_api_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryApiService _apiService = CategoryApiService();

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => [..._categories];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners(); // Notificar que empieza la carga

    try {
      _categories = await _apiService.fetchCategories();
    } catch (e) {
      print('Error al cargar categorías: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Siempre se notifica que terminó
    }
  }
}
