import 'package:flutter/material.dart';
import 'package:new_flutter_project/models/joke_model.dart';
import 'package:new_flutter_project/services/api_service.dart';
import 'package:new_flutter_project/widgets/jokes/jokes_card.dart';

class Jokes extends StatefulWidget {
  const Jokes({super.key});

  @override
  State<Jokes> createState() => _JokesState();
}

class _JokesState extends State<Jokes> {
  List<Joke> jokes = [];
  String type = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    type = ModalRoute.of(context)?.settings.arguments as String;
    if (type.isNotEmpty) {
      getJokes(type);
    }
  }

  void getJokes(String type) async {
    try {
      final response = await ApiService.getJokesForType(type);
      final data = List.from(response.map((joke) => Joke.fromJson(joke)));
      setState(() {
        jokes = data.cast<Joke>();
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Jokes'),
        backgroundColor: Colors.blueAccent[100],
      ),
      body: jokes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return JokesCard(setup: joke.setup, punchline: joke.punchline);
              },
            ),
    );
  }
}
