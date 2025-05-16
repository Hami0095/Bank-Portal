// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class MongoApi {
//   static const baseUrl = 'http://192.168.100.180:3000'; 

//   static Future<List<dynamic>> getCustomers() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/customers'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body) as List;
//       } else {
//         throw Exception('Failed to load customers');
//       }
//     } catch (e) {
//       print('Error fetching customers: $e');
//       rethrow;
//     }
//   }

//   static Future<void> addCustomer(Map<String, dynamic> data) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/customers'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(data),
//       );

//       if (response.statusCode != 201) {
//         throw Exception('Failed to add customer');
//       }
//     } catch (e) {
//       print('Error adding customer: $e');
//       rethrow;
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoApi {
  // IP and port split for Uri.http()
  static const String host = '192.168.100.180';
  static const int port = 3000;

  static Future<List<dynamic>> getCustomers() async {
    try {
      final uri = Uri.parse('http://192.168.100.180:3000/customers');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        print('GET /customers failed with status: ${response.statusCode}');
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      print('Error fetching customers: $e');
      rethrow;
    }
  }

  static Future<void> addCustomer(Map<String, dynamic> data) async {
    try {
      final uri = Uri.http('$host:$port', '/customers');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 201) {
        print('POST /customers failed with status: ${response.statusCode}');
        throw Exception('Failed to add customer');
      }
    } catch (e) {
      print('Error adding customer: $e');
      rethrow;
    }
  }
}
