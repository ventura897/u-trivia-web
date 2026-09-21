import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
