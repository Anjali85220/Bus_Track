import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFacultyPage extends StatefulWidget {
  const LoginFacultyPage({super.key});

  @override
  State<LoginFacultyPage> createState() => _LoginFacultyPageState();
}

class _LoginFacultyPageState extends State<LoginFacultyPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Check if email ends with @hitam.org
        if (email.endsWith('@hitam.org')) {
          Navigator.pushNamed(context, '/dashboard-faculty');
        } else {
          await FirebaseAuth.instance.signOut();
          _showError('Please use your official @hitam.org email.');
        }
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
        title: const Text('Faculty Login'),
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
                      labelText: 'Faculty Email (@hitam.org)',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || !value.endsWith('@hitam.org')) {
                        return 'Enter a valid @hitam.org email';
                      }
                      return null;
                    },
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
