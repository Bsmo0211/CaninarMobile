import 'package:flutter/material.dart';

class ProductoProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _productoList = [];

  List<Map<String, dynamic>> get productoList => _productoList;

  addOrden(Map<String, dynamic> item) {
    _productoList.add(item);
    notifyListeners();
  }

  removeProducto(int index) {
    if (index >= 0 && index < _productoList.length) {
      _productoList.removeAt(index);
      notifyListeners();
    }
  }

  clearProducto() {
    _productoList.clear();
    notifyListeners();
  }
}
