import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              title: "Recent Transactions",
              subtitle: "View recent flagged transactions",
              icon: Icons.list_alt,
              color: Colors.blue,
            ),
            // _buildDashboardCard(
            //   title: "Alerts",
            //   subtitle: "Monitor suspicious activity",
            //   icon: Icons.warning,
            //   color: Colors.orange,
            // ),
            _buildDashboardCard(
              title: "KYC Database",
              subtitle: "Manage KYC data",
              icon: Icons.verified_user,
              color: Colors.green,
            ),
            // _buildDashboardCard(
            //   title: "User Management",
            //   subtitle: "Add/Remove Fraud Analysts",
            //   icon: Icons.people,
            //   color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: Colors.blueGrey.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.arrow_forward, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
