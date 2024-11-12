import 'package:flutter/material.dart';

class TopPanelProvider extends ChangeNotifier {
  bool recordMode = false;

  void switchMode() {
    recordMode = !recordMode;
    notifyListeners();
  }

  void mySetState() {
    notifyListeners();
  }
}
