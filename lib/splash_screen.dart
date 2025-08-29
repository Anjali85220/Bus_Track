import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_service.dart';
import 'home_page.dart';
import 'dashboard_student.dart';
import 'dashboard_faculty.dart';
import 'dashboard_driver.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/splash_background.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // After 3 sec → check login status
    Future.delayed(const Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ✅ Already logged in → fetch role
        final userData = await _authService.getUserDetails(user.uid);
        final role = userData?['role'];

        if (role == 'student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentDashboard()),
          );
        } else if (role == 'faculty') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FacultyDashboard()),
          );
        } else if (role == 'driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverDashboard()),
          );
        } else {
          // Role not found → go to login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        // ❌ Not logged in → go to login/signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                // Responsive full-screen video
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),

                // Top-right logo
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 16,
                  child: Image.asset(
                    'assets/hitam_logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
