import 'package:flutter/material.dart';
import 'package:new_flutter_project/providers/FavoritesProvider.dart';
import 'package:provider/provider.dart';

class JokesCard extends StatelessWidget {
  final String setup;
  final String punchline;
  final VoidCallback? onFavoriteToggle;

  const JokesCard({
    super.key,
    required this.setup,
    required this.punchline,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(setup);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Joke Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    setup,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    punchline,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriteToggle ??
                    () {
                      if (isFavorite) {
                        favoritesProvider.removeFavorite(setup);
                      } else {
                        favoritesProvider.addFavorite(setup, punchline);
                      }
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}