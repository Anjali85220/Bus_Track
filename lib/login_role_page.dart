import 'package:flutter/material.dart';

class LoginRolePage extends StatelessWidget {
  const LoginRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80DEEA), Color(0xFF26C6DA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login As",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login-driver'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Login as Driver', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login-faculty'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Login as Faculty', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login-student'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Login as Student', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      ),
    );
  }
}
