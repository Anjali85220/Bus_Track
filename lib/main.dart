import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'splash_screen.dart';
import 'home_page.dart';
import 'signup_role_page.dart';
import 'signup_driver_page.dart';
import 'signup_faculty_page.dart';
import 'signup_student_page.dart';
import 'login_role_page.dart';
import 'login_driver_page.dart';
import 'login_faculty_page.dart';
import 'login_student_page.dart';
import 'dashboard_driver.dart';
import 'dashboard_faculty.dart';
import 'dashboard_student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackMyBus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/signup-role': (context) => const SignupRolePage(),
        '/signup-driver': (context) => const SignupDriverPage(),
        '/signup-faculty': (context) => const SignupFacultyPage(),
        '/signup-student': (context) => const SignupStudentPage(),
        '/login-role': (context) => const LoginRolePage(),
        '/login-driver': (context) => const LoginDriverPage(),
        '/login-faculty': (context) => const LoginFacultyPage(),
        '/login-student': (context) => LoginStudentPage(),
        '/dashboard-driver': (context) => const DriverDashboard(),
        '/dashboard-faculty': (context) => const FacultyDashboard(),
        '/dashboard-student': (context) => const StudentDashboard(),
      },
    );
  }
}
