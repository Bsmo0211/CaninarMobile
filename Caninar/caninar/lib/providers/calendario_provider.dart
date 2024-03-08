import 'package:flutter/material.dart';

class CalendarioProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _calendarioList = [];

  List<Map<String, dynamic>> get calendarioList => _calendarioList;

  addCalendario(Map<String, dynamic> item) {
    _calendarioList.add(item);
    notifyListeners();
  }

  removeCalendario(int index) {
    if (index >= 0 && index < _calendarioList.length) {
      _calendarioList.removeAt(index);
      notifyListeners();
    }
  }

  clearCalendario() {
    _calendarioList.clear();
    notifyListeners();
  }
}
