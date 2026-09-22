import 'package:flutter/material.dart';

import 'screens/register_page.dart'; // I-import ang iyong register page

void main() {
  runApp(const UTriviaApp());
}

class UTriviaApp extends StatelessWidget {
  const UTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'U-TRIVIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      home: const RegisterPage(), // Naka-set na dito ang Register Page mo
    );
  }
}
