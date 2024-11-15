import 'package:bank_portal/screens/dashboard_screen.dart';
import 'package:bank_portal/screens/kyc_setup_screen.dart';
import 'package:bank_portal/screens/login_screen.dart';
import 'package:bank_portal/screens/logs_reports_screen.dart';
import 'package:bank_portal/screens/transaction_monitoring_screen.dart';
import 'package:bank_portal/screens/user_management_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    TransactionMonitoringScreen(),
    LogsReportsScreen(),
    KYCSetupScreen(),
    UserManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Bar
          NavigationBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Main Content Area
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const NavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bank Portal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Colors.white54),
          _buildNavItem(Icons.dashboard, 'Dashboard', 0),
          _buildNavItem(Icons.monetization_on, 'Transaction Monitoring', 1),
          _buildNavItem(Icons.receipt_long, 'Logs & Reports', 2),
          _buildNavItem(Icons.verified_user, 'KYC Database Setup', 3),
          _buildNavItem(Icons.people, 'User Management', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      selected: index == selectedIndex,
      selectedTileColor: Colors.blueGrey.shade700,
      onTap: () => onItemSelected(index),
    );
  }
}
