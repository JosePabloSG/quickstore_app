import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _query = '';
  final List<String> _history = [];

  String get query => _query;
  List<String> get history => List.unmodifiable(_history);
  bool get isQueryEmpty => _query.trim().isEmpty;

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void addToHistory(String term) {
    if (term.isNotEmpty && !_history.contains(term)) {
      _history.insert(0, term);
      if (_history.length > 10) _history.removeLast();
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
