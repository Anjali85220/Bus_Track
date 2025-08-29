import 'package:flutter/material.dart';
import 'package:TrackMyBus/firebase_auth_service.dart';
import 'dashboard_student.dart';
import 'login_student_page.dart';

class SignupStudentPage extends StatefulWidget {
  const SignupStudentPage({super.key});

  @override
  State<SignupStudentPage> createState() => _SignupStudentPageState();
}

class _SignupStudentPageState extends State<SignupStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _routeController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? result = await _authService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: 'student',
      routeNo: _routeController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const StudentDashboard()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'College Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  if (!value.endsWith('@hitam.org')) {
                    return 'Please use your official college email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeController,
                decoration: const InputDecoration(labelText: 'Route Number'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter route number' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginStudentPage()),
                  );
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
