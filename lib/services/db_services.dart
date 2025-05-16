import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String _baseUrl = 'http://192.168.100.180:5000/customers';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*'
  };

  static const Duration _timeout = Duration(seconds: 10);

  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Handle both formats - direct array or wrapped response
        if (decoded is List) {
          return decoded;
        } else if (decoded['data'] is List) {
          return decoded['data'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Customer fetch error: $e');
      throw Exception('Failed to load customers. Please try again.');
    }
  }

  static Future<void> addCustomer(Map<String, dynamic> customer) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'CustomerID': customer['CustomerID'],
          'FullName': customer['FullName'],
          'IBAN': customer['IBAN'],
          'Phone': customer['Phone'],
          'AccountType': customer['AccountType'],
          'Branch': customer['Branch']
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] != true) {
          throw Exception(responseData['error'] ?? 'Failed to add customer');
        }
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Customer add error: $e');
    }
  }

  static Future<void> deleteCustomer(String customerId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$customerId'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Customer delete error: $e');
    }
  }
}
