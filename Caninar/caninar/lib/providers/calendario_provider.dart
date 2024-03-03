import 'package:flutter/material.dart';

class CalendarioProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _calendarioList = [];

  List<Map<String, dynamic>> get calendarioList => _calendarioList;

  addOrden(Map<String, dynamic> item) {
    _calendarioList.add(item);
    notifyListeners();
  }

  removeOrder(int index) {
    if (index >= 0 && index < _calendarioList.length) {
      _calendarioList.removeAt(index);
      notifyListeners();
    }
  }

  clearOrder() {
    _calendarioList.clear();
    notifyListeners();
  }
}
