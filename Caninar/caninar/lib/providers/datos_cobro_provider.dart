import 'package:flutter/material.dart';

class CobroProvider extends ChangeNotifier {
  final Map<String, dynamic> _cobro = {};

  Map<String, dynamic> get cobro => _cobro;

  addCobro(Map<String, dynamic> item) {
    _cobro.addAll(item);
    notifyListeners();
  }

  clearCobro() {
    _cobro.clear();
    notifyListeners();
  }
}
