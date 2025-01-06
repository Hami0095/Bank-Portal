import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to users collection
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  void _addOrEditUser({Map<String, dynamic>? userData, String? userId}) {
    TextEditingController emailController =
        TextEditingController(text: userData != null ? userData['email'] : '');
    TextEditingController nameController =
        TextEditingController(text: userData != null ? userData['name'] : '');
    String userType = userData != null ? userData['userType'] : 'Fraud Analyst';
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(25),
          title: Text(
            userData == null ? 'Add New User' : 'Edit User',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey.shade900,
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Name', nameController),
                      const SizedBox(height: 8),
                      _buildTextField('Email', emailController),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: userType,
                        items: ['Admin', 'Fraud Analyst'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (newRole) {
                          setState(() {
                            userType = newRole!;
                          });
                        },
                        dropdownColor: Colors.blueGrey.shade800,
                        decoration: InputDecoration(
                          labelText: 'User Type',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.blueGrey.shade800,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Only show password field when adding a new user
                      if (userData == null)
                        _buildTextField('Password', passwordController,
                            obscure: true),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String name = nameController.text.trim();
                String selectedRole = userType;

                if (email.isEmpty || name.isEmpty || selectedRole.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                try {
                  if (userData == null) {
                    // Adding a new user
                    String password = passwordController.text.trim();
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password is required')),
                      );
                      return;
                    }

                    bool success = await _authService.signUp(
                      email: email,
                      password: password,
                      userType: selectedRole,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User added successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email already in use')),
                      );
                    }
                  } else {
                    // Editing an existing user
                    await _firestore.collection('users').doc(userId).update({
                      'email': email,
                      'name': name,
                      'userType': selectedRole,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User updated successfully')),
                    );
                  }

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error in _addOrEditUser: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.blueGrey.shade800,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: ${e.toString()}')),
      );
    }
  }

  void _updateDatabase() {
    // Placeholder for additional database update operations if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Management",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _addOrEditUser();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Add New User",
                    style: TextStyle(color: Colors.white),
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Placeholder for CSV upload
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('CSV upload not implemented yet.')),
                    );
                  },
                  icon: Icon(Icons.upload_file, color: Colors.white),
                  label: Text(
                    "Upload CSV",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Placeholder for database export
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Export not implemented yet.')),
                    );
                  },
                  icon: Icon(Icons.download, color: Colors.white),
                  label: Text(
                    "Export",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // User Data Table
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getUsersStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong',
                        style: TextStyle(color: Colors.white));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 16.0,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blueGrey.shade700),
                      columns: const [
                        DataColumn(
                            label: Text('Name',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('User Type',
                                style: TextStyle(color: Colors.white))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(color: Colors.white))),
                      ],
                      rows:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String userId = document.id;

                        return DataRow(
                          cells: [
                            DataCell(Text(data['name'],
                                style: TextStyle(color: Colors.black))),
                            DataCell(Text(data['email'],
                                style: TextStyle(color: Colors.black))),
                            DataCell(Text(data['userType'],
                                style: TextStyle(color: Colors.black))),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  onPressed: () => _addOrEditUser(
                                      userData: data, userId: userId),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteUser(userId),
                                ),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Update Database Button
            Center(
              child: ElevatedButton(
                onPressed: _updateDatabase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "Update Database",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
