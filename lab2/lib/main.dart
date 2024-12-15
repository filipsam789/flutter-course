import 'package:flutter/material.dart';
import 'package:new_flutter_project/screens/home.dart';
import 'package:new_flutter_project/screens/jokes.dart';
import 'package:new_flutter_project/screens/random_joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes',
      initialRoute: '/',
      routes: {
        '/' : (context) => const Home(),
        '/jokes': (context) => const Jokes(),
        '/random_joke': (context) => const RandomJoke(),
      },
    );
  }
}


