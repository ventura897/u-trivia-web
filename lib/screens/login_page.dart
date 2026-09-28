import 'package:flutter/material.dart';

import '../services/auth_service.dart'; // Firebase login logic
import 'dashboard.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isStudent = true;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedDepartment;

  // Firebase
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Pinipigilan ang double-tap habang naglo-login

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.login(
        isStudent: isStudent,
        idNumber: _idController.text,
        name: _nameController.text,
        department: selectedDepartment!,
        password: _passwordController.text,
      );

      if (!mounted) return;
      // Direktang lumilipat sa DashboardScreen nang walang onNavigate error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white.withValues(alpha: 0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.school, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'U-TRIVIA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A smart learning platform that makes university learning\nfun through quizzes, campus challenges, and rewards.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 420,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Center(
                            child: Text(
                              'Log in to continue',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Log in as',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isStudent = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isStudent
                                          ? const Color(0xFF2E7D32)
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Student',
                                        style: TextStyle(
                                          color: isStudent
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => isStudent = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !isStudent
                                          ? const Color(0xFF2E7D32)
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Faculty',
                                        style: TextStyle(
                                          color: !isStudent
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isStudent ? 'Student ID' : 'Teacher ID',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _idController,
                            decoration: InputDecoration(
                              hintText: isStudent
                                  ? 'Enter your Student ID'
                                  : 'Enter your Teacher ID',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return isStudent
                                    ? 'Please enter your Student ID'
                                    : 'Please enter your Teacher ID';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your full name',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Department / Course',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: selectedDepartment,
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: 'Select your department or course',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'BSIT',
                                  child: Text(
                                      'Bachelor of Science in Information Technology')),
                              DropdownMenuItem(
                                  value: 'BSCS',
                                  child: Text(
                                      'Bachelor of Science in Computer Science')),
                              DropdownMenuItem(
                                  value: 'BSED',
                                  child:
                                      Text('Bachelor of Secondary Education')),
                              DropdownMenuItem(
                                  value: 'BEED',
                                  child:
                                      Text('Bachelor of Elementary Education')),
                              DropdownMenuItem(
                                  value: 'BSN',
                                  child:
                                      Text('Bachelor of Science in Nursing')),
                              DropdownMenuItem(
                                  value: 'BSBA',
                                  child: Text(
                                      'Bachelor of Science in Business Administration')),
                              DropdownMenuItem(
                                  value: 'BSHM',
                                  child: Text(
                                      'Bachelor of Science in Hospitality Management')),
                              DropdownMenuItem(
                                  value: 'BSCrim',
                                  child: Text(
                                      'Bachelor of Science in Criminology')),
                              DropdownMenuItem(
                                  value: 'BSCE',
                                  child: Text(
                                      'Bachelor of Science in Civil Engineering')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your department';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedDepartment = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: 'Example123#',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock,
                                      size: 16, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Colors.grey)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('or',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ),
                              Expanded(child: Divider(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.g_mobiledata,
                                      size: 28, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Register",
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
