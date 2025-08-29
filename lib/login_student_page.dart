import 'package:flutter/material.dart';
import 'firebase_auth_service.dart';
import 'dashboard_student.dart';
// import 'faculty_dashboard.dart';
// import 'driver_dashboard.dart';

class LoginStudentPage extends StatefulWidget {
  const LoginStudentPage({Key? key}) : super(key: key);

  @override
  _LoginStudentPageState createState() => _LoginStudentPageState();
}

class _LoginStudentPageState extends State<LoginStudentPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.loginWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      final role = result['role'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful! Role: $role')),
      );

      // 👉 Navigate directly instead of using route names
      if (role == 'student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentDashboard()),
        );
      } 
      // else if (role == 'faculty') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const FacultyDashboardPage()),
      //   );
      // } 
      // else if (role == 'driver') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const DriverDashboardPage()),
      //   );
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}
