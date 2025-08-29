import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TrackMyBus/firebase_auth_service.dart';
import 'package:TrackMyBus/dashboard_faculty.dart';

class SignupFacultyPage extends StatefulWidget {
  const SignupFacultyPage({super.key});

  @override
  State<SignupFacultyPage> createState() => _SignupFacultyPageState();
}

class _SignupFacultyPageState extends State<SignupFacultyPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool _isLoading = false;

  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (!email.endsWith('@hitam.org')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use HITAM email only')),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? result = await _authService.signUpWithEmail(
      email: email.trim(),
      password: password.trim(),
      role: 'faculty',
    );

    setState(() => _isLoading = false);

    if (result == null) {
      final user = _authService.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'role': 'faculty',
        });
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FacultyDashboard()),
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
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Faculty Signup',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (val) => name = val,
                      validator: (val) => val!.isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email (@hitam.org)'),
                      onChanged: (val) => email = val,
                      validator: (val) => val!.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      validator: (val) => val!.length < 6 ? 'Password too short' : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            ),
                            child: const Text('Sign Up'),
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login-role');
                      },
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
