import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth errors here
      print('FirebaseAuthException: ${e.message}');
      throw e;
    } catch (e) {
      print('Error signing in: $e');
      throw e;
    }
  }

  // Sign up with email and password
  Future<User?> signUp(
      String email, String password, String name, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Add user details to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'name': name,
        'email': email,
        'role': role, // 'Admin' or 'Fraud Analyst'
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth errors here
      print('FirebaseAuthException: ${e.message}');
      throw e;
    } catch (e) {
      print('Error signing up: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream for auth state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Fetch user role
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc['role'];
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }
}
