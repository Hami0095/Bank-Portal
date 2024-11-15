import 'package:flutter/material.dart';

class LogsReportsScreen extends StatelessWidget {
  // Sample log data
  final List<Map<String, dynamic>> logs = [
    {
      'timestamp': '2024-11-14 09:35:21',
      'event': 'Transaction Declined',
      'user': 'Analyst A',
      'transactionID': 'TXN001',
      'description': 'Flagged transaction declined due to suspicious activity.',
    },
    {
      'timestamp': '2024-11-14 08:22:10',
      'event': 'Transaction Approved',
      'user': 'Analyst B',
      'transactionID': 'TXN002',
      'description': 'Flagged transaction approved after further verification.',
    },
    {
      'timestamp': '2024-11-13 17:15:45',
      'event': 'New Fraud Analyst Added',
      'user': 'Admin',
      'transactionID': '',
      'description': 'Analyst C added to the system.',
    },
    {
      'timestamp': '2024-11-13 10:42:33',
      'event': 'KYC Database Updated',
      'user': 'Admin',
      'transactionID': '',
      'description': 'KYC database updated with new customer profiles.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Logs & Reports",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter and Export Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Event Logs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 58, 76, 85),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Placeholder action for filter
                      },
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logs List
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _buildLogCard(log);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log) {
    return Card(
      color: Colors.blueGrey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Timestamp: ${log['timestamp']}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Event: ${log['event']}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "User: ${log['user']}",
              style: TextStyle(color: Colors.white70),
            ),
            if (log['transactionID'].isNotEmpty)
              Text(
                "Transaction ID: ${log['transactionID']}",
                style: TextStyle(color: Colors.white70),
              ),
            const SizedBox(height: 8),
            Text(
              "Description: ${log['description']}",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
