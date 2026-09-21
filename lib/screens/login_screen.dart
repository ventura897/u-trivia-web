import 'package:flutter/material.dart';

import 'main_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image / Placeholder with Tint
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE2ECE9),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.25,
                child: Container(
                  color: Colors.teal.shade900,
                ),
              ),
            ),
          ),
          // Login Modal Card
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 480,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo & Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          child: const Center(
                            child: Text(
                              'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'U-TRIVIA',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A smart learning platform that makes university learning\nfun through quizzes, campus challenges, and rewards.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Log in to continue',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Toggle Student / Faculty
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isStudent = true),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isStudent
                                      ? Colors.green.shade700
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Student',
                                  style: TextStyle(
                                    color: isStudent
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isStudent = false),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: !isStudent
                                      ? Colors.green.shade700
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Faculty',
                                  style: TextStyle(
                                    color: !isStudent
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ID Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isStudent ? 'Student ID' : 'Teacher ID',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        hintText: isStudent
                            ? 'Enter your Student ID'
                            : 'Enter your Teacher ID',
                        hintStyle:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name Input
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Name',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password Input
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Create a Password',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Example123#',
                        hintStyle:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button (Punta sa Dashboard)
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainDashboardScreen()),
                          );
                        },
                        child: const Text('Log in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
