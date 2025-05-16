// main_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'transaction_monitoring_screen.dart';
import 'logs_reports_screen.dart';
import 'kyc_setup_screen.dart';
import 'user_management_screen.dart';
import 'login_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  String? userType;
  String? userId;

  final List<Widget> _adminPages = [
    DashboardScreen(),
    TransactionMonitoringScreen(),
    // LogsReportsScreen(),
    KYCSetupScreen(),
    // UserManagementScreen(),
  ];

  final List<Widget> _fraudAnalystPages = [
    DashboardScreen(),
    TransactionMonitoringScreen(),
    // LogsReportsScreen(),
    // KYCSetupScreen(),
    // Fraud Analysts do not have access to User Management
  ];

 @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchUserDetails(user.uid);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  Future<void> _fetchUserDetails(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      userType = userDoc['userType'];
      userId = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userType == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Widget> pages = userType == 'Admin' ? _adminPages : _fraudAnalystPages;

    return Scaffold(
      body: Row(
        children: [
          NavigationBarWidget(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            isAdmin: userType == 'Admin',
          ),
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // String? currentEmail = _authService.currentUserEmail;
          // if (currentEmail != null) {
          //   await _authService.signOut(email: currentEmail);
          // }
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginScreen()),
          // );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isAdmin;

  const NavigationBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> navItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard'},
      {'icon': Icons.monetization_on, 'title': 'Transaction Monitoring'},
      // {'icon': Icons.receipt_long, 'title': 'Logs & Reports'},
      {'icon': Icons.verified_user, 'title': 'KYC Database Setup'},
    ];

    // if (isAdmin) {
    //   navItems.add({'icon': Icons.people, 'title': 'User Management'});
    // }

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
          ...navItems.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            return _buildNavItem(item['icon'], item['title'], idx);
          }).toList(),
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
