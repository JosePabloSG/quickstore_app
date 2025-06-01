import 'package:flutter/material.dart';
import '../models/product.dart';

class BuyNowProvider with ChangeNotifier {
  Product? _product;
  int _quantity = 1;
  bool _isBuyNow = false;

  Product? get product => _product;
  int get quantity => _quantity;
  bool get isBuyNow => _isBuyNow;

  void setPurchase(Product product, int quantity) {
    _product = product;
    _quantity = quantity;
    _isBuyNow = true;
    notifyListeners();
  }

  void clear() {
    _product = null;
    _quantity = 1;
    _isBuyNow = false;
    notifyListeners();
  }
  double get total => product != null ? product!.price * quantity : 0.0;

}

