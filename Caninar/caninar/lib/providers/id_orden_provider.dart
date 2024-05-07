import 'package:caninar/API/APi.dart';
import 'package:flutter/material.dart';

class IdOrdenProvider extends ChangeNotifier {
  String? _idOrden;

  String? get idOrden => _idOrden;

  set idOrden(String? idOrden) {
    _idOrden = idOrden;
    notifyListeners();
  }

  Future<String?> crearOrden(Map<String, dynamic> ordenList) async {
    _idOrden = await API().createOrden(ordenList);
    notifyListeners();

    return _idOrden;
  }
}
