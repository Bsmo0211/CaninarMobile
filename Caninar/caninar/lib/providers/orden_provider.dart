import 'package:flutter/material.dart';

class OrdenProvider extends ChangeNotifier {
  final Map<String, dynamic> _ordenList = {};

  Map<String, dynamic> get ordenList => _ordenList;

  addOrden(Map<String, dynamic> item) {
    _ordenList.addAll(item);
    notifyListeners();
  }

  removeOrder(int index) {
    if (index >= 0 && index < _ordenList.length) {
      _ordenList.remove(index);
      notifyListeners();
    }
  }

  clearOrder() {
    _ordenList.clear();
    notifyListeners();
  }
}
