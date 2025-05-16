// import 'dart:convert';
// import 'dart:math';
// import 'package:crypto/crypto.dart';
// import 'package:uuid/uuid.dart';

// class Utils {
//   // Generate a random salt
//   static String generateSalt([int length = 16]) {
//     final rand = Random.secure();
//     final saltBytes = List<int>.generate(length, (_) => rand.nextInt(256));
//     return base64Url.encode(saltBytes);
//   }

//   // Generate SHA256 hash of password + salt
//   static String generatePasswordHash(String password, String salt) {
//     final bytes = utf8.encode(password + salt);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   // Generate a unique token
//   static String generateToken() {
//     var uuid = Uuid();
//     return sha256.convert(utf8.encode(uuid.v4())).toString();
//   }
// }
