import 'package:flutter/material.dart';

class IndexNavegacion with ChangeNotifier {
  int _index = 2;

  int get Index {
    return _index;
  }

  set Index(int index) {
    _index = index;
    notifyListeners();
  }
}
