// // auth_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'utils.dart';

// class AuthService {
//   // Singleton pattern
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   String? _currentUserEmailValue;

//   // Synchronous getter for current user's email
//   String? get currentUserEmail => _currentUserEmailValue;

//   // Sign up a new user
//   Future<bool> signUp({
//     required String email,
//     required String password,
//     required String userType,
//   }) async {
//     try {
//       // Check if email already exists
//       QuerySnapshot existingUser = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get();
//       if (existingUser.docs.isNotEmpty) {
//         // Email already in use
//         return false;
//       }

//       // Generate salt and hash password
//       String salt = Utils.generateSalt();
//       String passwordHash = Utils.generatePasswordHash(password, salt);

//       // Generate token
//       String token = Utils.generateToken();

//       // Create user document
//       await _firestore.collection('users').add({
//         'email': email,
//         'passwordHash': passwordHash,
//         'salt': salt,
//         'token': token,
//         'userType': userType,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       return true;
//     } catch (e) {
//       print('Error in signUp: $e');
//       return false;
//     }
//   }

//   // Sign in a user
//   Future<Map<String, dynamic>?> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       // Fetch user by email
//       QuerySnapshot userQuery = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();

//       if (userQuery.docs.isEmpty) {
//         // User not found
//         return null;
//       }

//       var userDoc = userQuery.docs.first;
//       String storedHash = userDoc['passwordHash'];
//       String salt = userDoc['salt'];
//       String inputHash = Utils.generatePasswordHash(password, salt);

//       if (storedHash != inputHash) {
//         // Password does not match
//         return null;
//       }

//       // Authentication successful, store current user's email
//       _currentUserEmailValue = email;

//       // Return user data
//       return userDoc.data() as Map<String, dynamic>;
//     } catch (e) {
//       print('Error in signIn: $e');
//       return null;
//     }
//   }

//   // Sign out a user
//   Future<void> signOut({required String email}) async {
//     try {
//       // Optionally, invalidate token or perform other sign-out operations
//       // For simplicity, we'll skip token management here

//       // Clear current user email if it matches
//       if (_currentUserEmailValue == email) {
//         _currentUserEmailValue = null;
//       }
//     } catch (e) {
//       print('Error in signOut: $e');
//     }
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email/password
  Future<bool> signUp({
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print('SignUp Error: ${e.code}');
      return false;
    }
  }

  // Sign in
  Future<Map<String, dynamic>?> signIn({
  required String email,
  required String password,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    return {
      'uid': userCredential.user!.uid,
      'email': email,
      'userType': userDoc['userType'],
    };
  } on FirebaseAuthException catch (e) {
    print('Login Error: ${e.code} - ${e.message}');
    
    // User-friendly error messages
    String errorMessage;
    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'Invalid email format';
        break;
      case 'user-disabled':
        errorMessage = 'Account disabled';
        break;
      case 'user-not-found':
      case 'wrong-password':
        errorMessage = 'Invalid email or password';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Email/password login not enabled';
        break;
      default:
        errorMessage = 'Login failed. Please try again.';
    }
    
    throw AuthException(errorMessage); // Create a custom AuthException class
  }
}

 
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
 

 class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
