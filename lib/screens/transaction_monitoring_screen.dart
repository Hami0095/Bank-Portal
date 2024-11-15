import 'package:flutter/material.dart';

class TransactionMonitoringScreen extends StatelessWidget {
  // Sample transaction data
  final List<Map<String, dynamic>> transactions = [
    {
      'transactionID': 'TXN001',
      'amount': 1500.0,
      'sender': 'User A',
      'receiver': 'User B',
      'status': 'Flagged',
    },
    {
      'transactionID': 'TXN002',
      'amount': 500.0,
      'sender': 'User C',
      'receiver': 'User D',
      'status': 'Pending',
    },
    {
      'transactionID': 'TXN003',
      'amount': 3000.0,
      'sender': 'User E',
      'receiver': 'User F',
      'status': 'Approved',
    },
    {
      'transactionID': 'TXN004',
      'amount': 10000.0,
      'sender': 'User G',
      'receiver': 'User H',
      'status': 'Flagged',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction Monitoring",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction, context);
          },
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
      Map<String, dynamic> transaction, BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaction ID: ${transaction['transactionID']}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Amount: \$${transaction['amount']}",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "Sender: ${transaction['sender']}",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "Receiver: ${transaction['receiver']}",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status: ${transaction['status']}",
                  style: TextStyle(
                    color: transaction['status'] == 'Flagged'
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (transaction['status'] == 'Flagged')
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Placeholder action for Approve
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Transaction ${transaction['transactionID']} approved'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text("Approve"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Placeholder action for Decline
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Transaction ${transaction['transactionID']} declined'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text("Decline"),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
