import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // Sample user data
  List<Map<String, dynamic>> users = [
    {'name': 'Admin User', 'email': 'admin@bank.com', 'role': 'Admin'},
    {
      'name': 'Analyst A',
      'email': 'analystA@bank.com',
      'role': 'Fraud Analyst'
    },
    {
      'name': 'Analyst B',
      'email': 'analystB@bank.com',
      'role': 'Fraud Analyst'
    },
  ];

  void _addOrEditUser({Map<String, dynamic>? user, int? index}) {
    TextEditingController nameController =
        TextEditingController(text: user != null ? user['name'] : '');
    TextEditingController emailController =
        TextEditingController(text: user != null ? user['email'] : '');
    String role = user != null ? user['role'] : 'Fraud Analyst';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(25),
          title: Text(
            user == null ? 'Add New User' : 'Edit User',
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
                    items: ['Admin', 'Fraud Analyst'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (newRole) => setState(() {
                      role = newRole!;
                    }),
                    dropdownColor: Colors.blueGrey.shade800,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blueGrey,
                      border: OutlineInputBorder(),
                    ),
                  ),
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
              onPressed: () {
                setState(() {
                  if (user == null) {
                    // Add new user
                    users.add({
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': role,
                    });
                  } else if (index != null) {
                    // Edit existing user
                    users[index] = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': role,
                    };
                  }
                });
                Navigator.of(context).pop();
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.blueGrey.shade800,
        border: const OutlineInputBorder(),
      ),
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
              child: DataTable(
                columnSpacing: 16.0,
                headingRowColor:
                    MaterialStateProperty.all(Colors.blueGrey.shade700),
                columns: const [
                  DataColumn(
                      label:
                          Text('Name', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label:
                          Text('Email', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label:
                          Text('Role', style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(color: Colors.white))),
                ],
                rows: users.map((user) {
                  final index = users.indexOf(user);
                  return DataRow(
                    cells: [
                      DataCell(Text(user['name'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text(user['email'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text(user['role'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () =>
                                _addOrEditUser(user: user, index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                users.removeAt(index);
                              });
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Update Database Button
            ElevatedButton(
              onPressed: () {
                // Placeholder for saving to database
              },
              child: Text(
                "Update Database",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade900,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
