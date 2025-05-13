import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId) && _items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
      notifyListeners();
    }
  }

  double get subtotal => _items.values
      .fold(0, (sum, item) => sum + item.product.price * item.quantity);

  double get shipping => subtotal > 0 ? 5.0 : 0.0;

  double get total => subtotal + shipping;

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}
