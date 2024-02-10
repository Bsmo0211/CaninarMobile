import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners();
  }

  removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
