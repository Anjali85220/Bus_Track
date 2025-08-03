import 'package:flutter/material.dart';

class LoginFacultyPage extends StatefulWidget {
  const LoginFacultyPage({super.key});

  @override
  State<LoginFacultyPage> createState() => _LoginFacultyPageState();
}

class _LoginFacultyPageState extends State<LoginFacultyPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/dashboard-faculty');
    }
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
                    onChanged: (val) => email = val,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter password' : null,
                    onChanged: (val) => password = val,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text('Login'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
