import 'package:flutter/material.dart';

class KYCSetupScreen extends StatefulWidget {
  @override
  _KYCSetupScreenState createState() => _KYCSetupScreenState();
}

class _KYCSetupScreenState extends State<KYCSetupScreen> {
  // Sample KYC data
  List<Map<String, dynamic>> customers = [
    {
      'name': 'John Doe',
      'idType': 'Passport',
      'idNumber': 'A1234567',
      'address': '123 Elm St'
    },
    {
      'name': 'Jane Smith',
      'idType': 'Driver\'s License',
      'idNumber': 'DL890123',
      'address': '456 Oak Ave'
    },
    {
      'name': 'Alice Brown',
      'idType': 'National ID',
      'idNumber': 'ID654321',
      'address': '789 Pine Blvd'
    },
  ];

  void _addOrEditCustomer({Map<String, dynamic>? customer, int? index}) {
    TextEditingController nameController =
        TextEditingController(text: customer != null ? customer['name'] : '');
    TextEditingController idTypeController =
        TextEditingController(text: customer != null ? customer['idType'] : '');
    TextEditingController idNumberController = TextEditingController(
        text: customer != null ? customer['idNumber'] : '');
    TextEditingController addressController = TextEditingController(
        text: customer != null ? customer['address'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(25),
          title: Text(
            customer == null ? 'Add New Customer' : 'Edit Customer',
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
                  _buildTextField('ID Type', idTypeController),
                  const SizedBox(height: 8),
                  _buildTextField('ID Number', idNumberController),
                  const SizedBox(height: 8),
                  _buildTextField('Address', addressController),
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
                  if (customer == null) {
                    // Add new customer
                    customers.add({
                      'name': nameController.text,
                      'idType': idTypeController.text,
                      'idNumber': idNumberController.text,
                      'address': addressController.text,
                    });
                  } else if (index != null) {
                    // Edit existing customer
                    customers[index] = {
                      'name': nameController.text,
                      'idType': idTypeController.text,
                      'idNumber': idNumberController.text,
                      'address': addressController.text,
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

  void _updateDatabase() {
    // Placeholder function for updating the database
    // Add logic here to save records or upload CSV to the database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KYC Database Setup",
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
                    _addOrEditCustomer();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Add New Record",
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
                    // Placeholder for export
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

            // KYC Data Table
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
                      label: Text('ID Type',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('ID Number',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Address',
                          style: TextStyle(color: Colors.white))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(color: Colors.white))),
                ],
                rows: customers.map((customer) {
                  final index = customers.indexOf(customer);
                  return DataRow(
                    cells: [
                      DataCell(Text(customer['name'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text(customer['idType'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text(customer['idNumber'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text(customer['address'],
                          style: TextStyle(color: Colors.black))),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _addOrEditCustomer(
                                customer: customer, index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                customers.removeAt(index);
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
            const SizedBox(height: 16),

            // Update Database Button
            Center(
              child: ElevatedButton(
                onPressed: _updateDatabase,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Colors.blueAccent,
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
