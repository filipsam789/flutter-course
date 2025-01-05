import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, String>> _favorites = [];

  List<Map<String, String>> get favorites => _favorites;

  void addFavorite(String setup, String punchline) {
    _favorites.add({'setup': setup, 'punchline': punchline});
    notifyListeners();
  }

  void removeFavorite(String setup) {
    _favorites.removeWhere((joke) => joke['setup'] == setup);
    notifyListeners();
  }

  bool isFavorite(String setup) {
    return _favorites.any((joke) => joke['setup'] == setup);
  }
}
