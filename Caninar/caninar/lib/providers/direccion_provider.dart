import 'package:flutter/material.dart';

class DireccionProvider extends ChangeNotifier {
  final Map<String, dynamic> _direccion = {};

  Map<String, dynamic> get direccion => _direccion;

  addDireccion(Map<String, dynamic> item) {
    _direccion.addAll(item);
    notifyListeners();
  }

  removeDireccion(int index) {
    if (index >= 0 && index < _direccion.length) {
      _direccion.remove(index);
      notifyListeners();
    }
  }
}
