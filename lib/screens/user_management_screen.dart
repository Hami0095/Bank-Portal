import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to listen to users collection
  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection('users').snapshots();
  }

  void _addOrEditUser({Map<String, dynamic>? userData, String? uid}) {
    TextEditingController nameController =
        TextEditingController(text: userData != null ? userData['name'] : '');
    TextEditingController emailController =
        TextEditingController(text: userData != null ? userData['email'] : '');
    String role = userData != null ? userData['role'] : 'Fraud Analyst';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Name', nameController),
                  const SizedBox(height: 8),
                  _buildTextField('Email', emailController),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: ['Fraud Analyst'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (newRole) {
                      setState(() {
                        role = newRole!;
                      });
                    },
                    dropdownColor: Colors.blueGrey.shade800,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blueGrey.shade800,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Only show password field when adding a new user
                  if (userData == null)
                    _buildTextField('Password', passwordController,
                        obscure: true),
                ],
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
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String selectedRole = role;

                if (name.isEmpty || email.isEmpty || selectedRole.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                try {
                  if (userData == null) {
                    // Add new user (Fraud Analyst)
                    String password = passwordController.text.trim();
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password is required')),
                      );
                      return;
                    }

                    // Create user with Firebase Auth
                    User? user = await _authService.signUp(
                        email, password, name, selectedRole);

                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User added successfully')),
                      );
                    }
                  } else {
                    // Edit existing user
                    String userUid = uid!;
                    await _firestore.collection('users').doc(userUid).update({
                      'name': name,
                      'email': email,
                      'role': selectedRole,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User updated successfully')),
                    );
                  }

                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  String message;
                  if (e.code == 'email-already-in-use') {
                    message = 'This email is already in use.';
                  } else if (e.code == 'weak-password') {
                    message = 'The password is too weak.';
                  } else {
                    message = 'An error occurred. Please try again.';
                  }
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  });
                } catch (e) {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  });
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

  void _deleteUser(String uid) async {
    try {
      // **Important**: Deleting a user from Firebase Auth requires admin privileges.
      // This operation should be handled securely, preferably via a Cloud Function.

      // Example: Call a Cloud Function to delete the user
      // You need to implement this Cloud Function separately.

      // Placeholder for Cloud Function call
      // await deleteUserFunction(uid);

      // For demonstration, we'll just delete the Firestore document
      await _firestore.collection('users').doc(uid).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: ${e.toString()}')),
      );
    }
  }

  void _updateDatabase() {
    // Placeholder for saving to database if needed
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

                  return DataTable(
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
                          label: Text('Role',
                              style: TextStyle(color: Colors.white))),
                      DataColumn(
                          label: Text('Actions',
                              style: TextStyle(color: Colors.white))),
                    ],
                    rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      String uid = document.id;

                      return DataRow(
                        cells: [
                          DataCell(Text(data['name'],
                              style: TextStyle(color: Colors.black))),
                          DataCell(Text(data['email'],
                              style: TextStyle(color: Colors.black))),
                          DataCell(Text(data['role'],
                              style: TextStyle(color: Colors.black))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () =>
                                    _addOrEditUser(userData: data, uid: uid),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(uid),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
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
