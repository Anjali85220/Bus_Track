import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Expose current user
  User? get currentUser => _auth.currentUser;

  /// 🔑 Login with email/password
  Future<Map<String, dynamic>?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc['lastActive'] != null) {
          DateTime lastActive = (userDoc['lastActive'] as Timestamp).toDate();
          if (DateTime.now().difference(lastActive).inDays >= 15) {
            await logout();
            return null; // force logout if inactive for 15 days
          }
        }

        await _firestore.collection('users').doc(user.uid).update({
          'lastActive': DateTime.now(),
        });

        return {
          'user': user,
          'role': userDoc['role'],
        };
      }
    } catch (e) {
      developer.log('Login error: $e');
    }
    return null;
  }

  /// Check if email already exists in Firebase Auth
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      final list = await _auth.fetchSignInMethodsForEmail(email);
      return list.isNotEmpty;
    } catch (e) {
      developer.log('Email check error: $e');
      return false;
    }
  }

  /// 🔑 Sign up with email, password, role, and optional route_no
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String role,
    String? routeNo,
  }) async {
    try {
      if ((role == 'student' || role == 'faculty') &&
          !email.endsWith('@hitam.org')) {
        return 'Please use your official college email.';
      }

      if (await isEmailAlreadyRegistered(email)) {
        return 'This email is already registered.';
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        final data = {
          'email': email,
          'role': role,
          'createdAt': DateTime.now(),
          'lastActive': DateTime.now(),
        };
        if (routeNo != null) {
          data['route_no'] = routeNo;
        }

        await _firestore.collection('users').doc(user.uid).set(data);
        return null; // success
      }
    } catch (e) {
      developer.log('Sign-up error: $e');
      return 'An error occurred during sign-up.';
    }
    return 'Unknown error occurred.';
  }

  /// ✅ Fetch user details from Firestore
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      developer.log('Get user details error: $e');
    }
    return null;
  }

  /// Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }
}
