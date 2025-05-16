// aml_api_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AmlApiServices {
  static const String _baseUrl = 'http://192.168.100.180:5000';

  static Future<Map<String, dynamic>> checkTransactionRisk(
      Map<String, dynamic> transaction) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check_transaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'AML Risk check failed for ${transaction["TransactionID"]}');
    }
  }

  static Future<List<Map<String, dynamic>>> simulateDemoTransactions() async {
    List<Map<String, dynamic>> results = [];

    for (var i = 0; i < 50; i++) {
      final txn = {
        "TransactionID": "txn_$i",
        "SenderAccount": "A${i % 10 + 1}", // Reuse accounts to create patterns
        "ReceiverAccount": "B${i % 5 + 1}",
        "Amount": (i + 1) * 100,
        "Currency": "USD",
        "Timestamp": DateTime.now().toIso8601String(),
      };

      try {
        final result = await checkTransactionRisk(txn);
        results.add(result);
      } catch (e) {
        results.add({
          "transaction_id": txn["TransactionID"],
          "error": e.toString(),
        });
      }
    }

    return results;
  }
}
