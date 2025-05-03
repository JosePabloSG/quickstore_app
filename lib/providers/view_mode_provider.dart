import 'package:flutter/material.dart';

enum ViewMode { grid, list }

class ViewModeProvider with ChangeNotifier {
  ViewMode _viewMode = ViewMode.grid;

  ViewMode get viewMode => _viewMode;

  void toggleViewMode() {
    _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    notifyListeners();
  }

  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }
}
