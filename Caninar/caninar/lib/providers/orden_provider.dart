import 'package:flutter/material.dart';

class OrdenProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _ordenList = [];

  List<Map<String, dynamic>> get ordenList => _ordenList;

  addOrden(Map<String, dynamic> item) {
    _ordenList.add(item);
    notifyListeners();
  }

  removeOrder(int index) {
    if (index >= 0 && index < _ordenList.length) {
      _ordenList.removeAt(index);
      notifyListeners();
    }
  }

  clearOrder() {
    _ordenList.clear();
    notifyListeners();
  }
}
