// providers/favorites_provider.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  void addFavorite(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
