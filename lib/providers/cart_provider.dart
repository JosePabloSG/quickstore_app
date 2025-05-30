import 'package:flutter/material.dart';
import 'package:quickstore_app/models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;
  /// Permite agregar múltiples unidades de un producto
  void addToCart(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
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
  int get totalQuantity {
    int total = 0;
    for (var item in _items.values) {
      total += item.quantity;
    }
    return total;
  }
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}