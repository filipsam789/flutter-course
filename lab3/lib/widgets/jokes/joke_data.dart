import 'package:flutter/material.dart';
import 'package:new_flutter_project/models/joke_model.dart';

class JokeData extends StatelessWidget {
  final int id;
  final Joke joke;

  const JokeData({super.key, required this.id, required this.joke});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 232, 226, 232),
        borderRadius: BorderRadius.circular(10),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            title: Text(
              joke.setup,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
            title: Text(
              joke.punchline,
              style: const TextStyle(
                color: Color.fromARGB(255, 108, 108, 108),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
