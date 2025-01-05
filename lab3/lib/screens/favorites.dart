import 'package:flutter/material.dart';
import 'package:new_flutter_project/providers/FavoritesProvider.dart';
import 'package:new_flutter_project/widgets/jokes/jokes_card.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.blueAccent[100],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet!"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final joke = favorites[index];
                return JokesCard(
                  setup: joke['setup']!,
                  punchline: joke['punchline']!,
                  onFavoriteToggle: () {
                    favoritesProvider.removeFavorite(joke['setup']!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Removed from favorites")),
                    );
                  },
                );
              },
            ),
    );
  }
}