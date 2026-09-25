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
      // I-configure ang Light Theme para hindi maging dark/itim ang mga screen at text
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Light background
        fontFamily: 'Roboto',
      ),
      // Para siguruhing hindi susunod sa dark mode ng phone o emulator:
      darkTheme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      themeMode: ThemeMode.light,
      home: const RegisterPage(), // Naka-set na dito ang Register Page mo
    );
  }
}
