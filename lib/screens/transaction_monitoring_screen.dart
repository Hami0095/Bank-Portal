import 'package:bank_portal/services/aml_api_services.dart';
import 'package:flutter/material.dart';

class TransactionMonitoringScreen extends StatefulWidget {
  @override
  _TransactionMonitoringScreenState createState() =>
      _TransactionMonitoringScreenState();
}

class _TransactionMonitoringScreenState
    extends State<TransactionMonitoringScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isSimulating = false;
  int _simulatedCount = 0;

  Future<void> _runSimulation() async {
    setState(() {
      _isSimulating = true;
      _transactions.clear();
      _simulatedCount = 0;
    });

    // Optional: Delay to show loading state
    await Future.delayed(Duration(milliseconds: 300));

    // Run simulation via your AML API
    final results = await AmlApiServices.simulateDemoTransactions();

    setState(() {
      _transactions = results;
      _isSimulating = false;
      _simulatedCount = results.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AML Monitoring"),
        backgroundColor: Colors.blueGrey[900],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSimulating ? null : _runSimulation,
        icon: Icon(Icons.play_arrow),
        label: Text(_isSimulating ? "Analyzing..." : "Run Simulation"),
        backgroundColor: _isSimulating ? Colors.grey : Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Simulation Status Panel
          Container(
            padding: EdgeInsets.all(12),
            color: Colors.blueGrey[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusChip(
                  icon: Icons.receipt,
                  label: "Transactions",
                  value: _simulatedCount.toString(),
                ),
                _buildStatusChip(
                  icon: Icons.warning,
                  label: "AML Flags",
                  value: _transactions
                      .where((t) => t['is_aml'] == true)
                      .length
                      .toString(),
                  color: Colors.red,
                ),
                _buildStatusChip(
                  icon: Icons.percent,
                  label: "Risk Rate",
                  value: _transactions.isEmpty
                      ? "0%"
                      : "${(_transactions.fold(0.0, (sum, t) => sum + (t['aml_risk'] ?? 0.0)) / _transactions.length * 100).toStringAsFixed(1)}%",
                ),
              ],
            ),
          ),
          Expanded(
            child: _isSimulating
                ? Center(child: _buildLoadingIndicator())
                : _transactions.isEmpty
                    ? _buildEmptyState()
                    : _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      {required IconData icon,
      required String label,
      required String value,
      Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Colors.white70, size: 20),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(strokeWidth: 2),
        SizedBox(height: 20),
        Text("Detecting AML Patterns...",
            style: TextStyle(color: Colors.white70)),
        SizedBox(height: 8),
        Text("Analyzing transaction graph",
            style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.blueGrey[300]),
          SizedBox(height: 16),
          Text(
            "No Simulation Results",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            "Run the AML simulator to detect suspicious patterns",
            style: TextStyle(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100), // Space for FAB
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final txn = _transactions[index];
        return _buildTransactionCard(txn);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> txn) {
    // Safe defaults for all fields
    final isAml = txn['is_aml'] ?? false;
    final riskValue =
        (txn['aml_risk'] as num?)?.toDouble() ?? 0.0; // Null-safe conversion
    final riskPercent =
        (riskValue * 100).toStringAsFixed(1); // Now safe to multiply

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Colors.blueGrey[800],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TX-${txn['transaction_id'] ?? 'N/A'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAml ? Colors.red[900] : Colors.green[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAml ? "HIGH RISK" : "LOW RISK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Null-safe account display
            Text("From: ${txn['SenderAccount'] ?? 'Unknown'}",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 4),
            Text("To: ${txn['ReceiverAccount'] ?? 'Unknown'}",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: riskValue,
              backgroundColor: Colors.blueGrey[700],
              color: _getRiskColor(riskValue),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$riskPercent% Risk",
                    style: TextStyle(color: Colors.white70)),
                if (isAml)
                  Text("Pattern: ${txn['pattern'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.amber)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void _showTransactionDetails(BuildContext context, Map<String, dynamic> txn) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Colors.blueGrey[800],
  //       title:
  //           Text("Transaction Details", style: TextStyle(color: Colors.white)),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             _buildDetailRow("ID", txn['transaction_id']),
  //             _buildDetailRow("From", txn['SenderAccount']),
  //             _buildDetailRow("To", txn['ReceiverAccount']),
  //             _buildDetailRow(
  //                 "Amount", "\$${txn['Amount']?.toStringAsFixed(2) ?? 'N/A'}"),
  //             _buildDetailRow("Risk Score",
  //                 "${(txn['aml_risk'] * 100).toStringAsFixed(1)}%"),
  //             if (txn['is_aml'] == true)
  //               _buildDetailRow("AML Pattern", txn['pattern']),
  //             SizedBox(height: 16),
  //             Text(
  //               "Graph Analysis",
  //               style:
  //                   TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(height: 8),
  //             Text(
  //               "This transaction was flagged because it creates a ${txn['pattern']} pattern in the financial graph network.",
  //               style: TextStyle(color: Colors.white70),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text("CLOSE", style: TextStyle(color: Colors.blueAccent)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDetailRow(String label, String value) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //             width: 100,
  //             child: Text("$label:", style: TextStyle(color: Colors.white70))),
  //         Expanded(child: Text(value, style: TextStyle(color: Colors.white))),
  //       ],
  //     ),
  //   );
  // }

  Color _getRiskColor(double risk) {
    if (risk > 0.75) return Colors.red;
    if (risk > 0.5) return Colors.orange;
    if (risk > 0.25) return Colors.yellow;
    return Colors.green;
  }
}


