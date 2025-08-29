import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginDriverPage extends StatefulWidget {
  const LoginDriverPage({super.key});

  @override
  State<LoginDriverPage> createState() => _LoginDriverPageState();
}

class _LoginDriverPageState extends State<LoginDriverPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        Navigator.pushNamed(context, '/dashboard-driver');
      } on FirebaseAuthException catch (e) {
        _showError(e.message ?? 'Login failed.');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        title: const Text('Driver Login'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter email' : null,
                    onChanged: (val) => email = val.trim(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter password' : null,
                    onChanged: (val) => password = val.trim(),
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          ),
                          child: const Text('Login'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
