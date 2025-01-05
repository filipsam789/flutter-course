import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_flutter_project/models/joke_model.dart';
import 'package:new_flutter_project/services/api_service.dart';

import '../widgets/jokes/joke_data.dart';

class RandomJoke extends StatefulWidget {
  const RandomJoke({super.key});

  @override
  State<RandomJoke> createState() => _RandomJokeState();
}

class _RandomJokeState extends State<RandomJoke> {
  Joke joke = Joke(id: 0, setup: '', punchline: '', type: '');
  String id = '';

  @override
  void initState() {
    super.initState();
    getRandomJoke();
  }

void getRandomJoke() async {
  try {
    final response = await ApiService.getRandomJoke();
    final data = json.decode(response.body);
    setState(() {
      joke = Joke.fromJson(data);
    });
  } catch (error) {
    print("Error: $error");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            JokeData(id: joke.id, joke: joke),
          ],
        ),
      ),
    );
  }
}
