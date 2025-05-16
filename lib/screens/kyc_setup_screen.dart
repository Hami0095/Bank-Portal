// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class KYCSetupScreen extends StatefulWidget {
//   @override
//   _KYCSetupScreenState createState() => _KYCSetupScreenState();
// }

// class _KYCSetupScreenState extends State<KYCSetupScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late CollectionReference _customersCollection;

//   @override
//   void initState() {
//     super.initState();
//     _customersCollection = _firestore.collection('kyc_customers');
//   }

//   void _addOrEditCustomer({Map<String, dynamic>? customer, String? docId}) {
//     TextEditingController nameController =
//         TextEditingController(text: customer != null ? customer['name'] : '');
//     TextEditingController idTypeController =
//         TextEditingController(text: customer != null ? customer['idType'] : '');
//     TextEditingController idNumberController = TextEditingController(
//         text: customer != null ? customer['idNumber'] : '');
//     TextEditingController addressController = TextEditingController(
//         text: customer != null ? customer['address'] : '');

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(25),
//           title: Text(
//             customer == null ? 'Add New Customer' : 'Edit Customer',
//             style: const TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Colors.blueGrey.shade900,
//           content: SizedBox(
//             width: 400,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTextField('Name', nameController),
//                   const SizedBox(height: 8),
//                   _buildTextField('ID Type', idTypeController),
//                   const SizedBox(height: 8),
//                   _buildTextField('ID Number', idNumberController),
//                   const SizedBox(height: 8),
//                   _buildTextField('Address', addressController),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child:
//                   const Text('Cancel', style: TextStyle(color: Colors.white)),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (customer == null) {
//                   await _customersCollection.add({
//                     'name': nameController.text,
//                     'idType': idTypeController.text,
//                     'idNumber': idNumberController.text,
//                     'address': addressController.text,
//                     'createdAt': FieldValue.serverTimestamp(),
//                   });
//                 } else if (docId != null) {
//                   await _customersCollection.doc(docId).update({
//                     'name': nameController.text,
//                     'idType': idTypeController.text,
//                     'idNumber': idNumberController.text,
//                     'address': addressController.text,
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//               child:
//                   const Text('Save', style: TextStyle(color: Colors.blueGrey)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white70),
//         filled: true,
//         fillColor: Colors.blueGrey.shade800,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "KYC Database Setup",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blueGrey.shade900,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _addOrEditCustomer(),
//                   icon: Icon(Icons.add, color: Colors.white),
//                   label: Text("Add New Record",
//                       style: TextStyle(color: Colors.white)),
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {}, // CSV upload placeholder
//                   icon: Icon(Icons.upload_file, color: Colors.white),
//                   label:
//                       Text("Upload CSV", style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {}, // Export placeholder
//                   icon: Icon(Icons.download, color: Colors.white),
//                   label: Text("Export", style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueGrey),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _customersCollection
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData)
//                     return Center(child: CircularProgressIndicator());

//                   return DataTable(
//                     columnSpacing: 16.0,
//                     headingRowColor:
//                         MaterialStateProperty.all(Colors.blueGrey.shade700),
//                     columns: const [
//                       DataColumn(
//                           label: Text('Name',
//                               style: TextStyle(color: Colors.white))),
//                       DataColumn(
//                           label: Text('ID Type',
//                               style: TextStyle(color: Colors.white))),
//                       DataColumn(
//                           label: Text('ID Number',
//                               style: TextStyle(color: Colors.white))),
//                       DataColumn(
//                           label: Text('Address',
//                               style: TextStyle(color: Colors.white))),
//                       DataColumn(
//                           label: Text('Actions',
//                               style: TextStyle(color: Colors.white))),
//                     ],
//                     rows: snapshot.data!.docs.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>;
//                       return DataRow(
//                         cells: [
//                           DataCell(Text(data['name'],
//                               style: TextStyle(color: Colors.white70))),
//                           DataCell(Text(data['idType'],
//                               style: TextStyle(color: Colors.white70))),
//                           DataCell(Text(data['idNumber'],
//                               style: TextStyle(color: Colors.white70))),
//                           DataCell(Text(data['address'],
//                               style: TextStyle(color: Colors.white70))),
//                           DataCell(Row(
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.edit, color: Colors.green),
//                                 onPressed: () => _addOrEditCustomer(
//                                     customer: data, docId: doc.id),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () =>
//                                     _customersCollection.doc(doc.id).delete(),
//                               ),
//                             ],
//                           )),
//                         ],
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:bank_portal/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KYCSetupScreen extends StatefulWidget {
  @override
  _KYCSetupScreenState createState() => _KYCSetupScreenState();
}

class _KYCSetupScreenState extends State<KYCSetupScreen> {
  List<dynamic> _customers = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);
    try {
      debugPrint('Fetching customers...');
      final customers = await CustomerService.getCustomers();
      debugPrint('Received ${customers.length} customers');
      setState(() => _customers = customers);
    } catch (e) {
      debugPrint('Error details: $e');
      _showErrorSnackbar(
          'Failed to load: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCustomer() async {
    final newCustomer = {
      'CustomerID': _customerIdController.text,
      'FullName': _nameController.text,
      'IBAN': _ibanController.text,
      'Phone': _phoneController.text,
      'AccountType': _accountTypeController.text,
      'Branch': _branchController.text,
    };

    setState(() => _isLoading = true);
    try {
      await CustomerService.addCustomer(newCustomer);
      _fetchCustomers();
      _clearForm();
      Navigator.of(context).pop();
      _showSuccessSnackbar('Customer added successfully');
    } catch (e) {
      _showErrorSnackbar('Error adding customer: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCustomer(String customerId) async {
    setState(() => _isLoading = true);
    try {
      await CustomerService.deleteCustomer(customerId);
      _fetchCustomers();
      _showSuccessSnackbar('Customer deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Error deleting customer: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _customerIdController.clear();
    _ibanController.clear();
    _phoneController.clear();
    _accountTypeController.clear();
    _branchController.clear();
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFormField('Full Name', _nameController),
              _buildFormField('Customer ID', _customerIdController),
              _buildFormField('IBAN', _ibanController),
              _buildFormField('Phone', _phoneController),
              _buildFormField('Account Type', _accountTypeController),
              _buildFormField('Branch', _branchController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addCustomer,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String customerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCustomer(customerId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<dynamic> get _filteredCustomers {
    if (_searchController.text.isEmpty) {
      return _customers;
    }
    return _customers.where((customer) {
      return customer['FullName'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
          customer['CustomerID'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
          customer['IBAN'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              );
    }).toList();
  }
  
  Future<void> _testConnection() async {
    try {
      debugPrint('Testing connection to server...');
      final response = await http.get(
        Uri.parse('http://192.168.100.180:5000/customers'),
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('Connection test response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      _showSuccessSnackbar('Connection successful!');
    } catch (e) {
      debugPrint('Connection test failed: $e');
      _showErrorSnackbar('Connection failed: ${e.toString()}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Center(
      //   child: FloatingActionButton(
          
      //     onPressed: _testConnection,
      //     child: Icon(Icons.bug_report),
      //   ),
      // ),
      appBar: AppBar(
        title: Text("KYC Database Setup"),
        backgroundColor: const Color.fromARGB(255, 251, 252, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Customers',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _fetchCustomers,
                  tooltip: 'Refresh',
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddCustomerDialog,
                  icon: Icon(Icons.add),
                  label: Text("Add Customer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                Text(
                  'Total Customers: ${_customers.length}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredCustomers.isEmpty
                      ? Center(child: Text('No customers found'))
                      : ListView.builder(
                          itemCount: _filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = _filteredCustomers[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(customer['FullName'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${customer['CustomerID'] ?? ''}'),
                                    Text('IBAN: ${customer['IBAN'] ?? ''}'),
                                    Row(
                                      children: [
                                        Chip(
                                          label: Text(customer['KYC_Status'] ??
                                              'Pending'),
                                          backgroundColor:
                                              customer['KYC_Status'] ==
                                                      'Verified'
                                                  ? Colors.green.shade100
                                                  : Colors.orange.shade100,
                                        ),
                                        SizedBox(width: 8),
                                        Chip(
                                          label: Text(
                                              customer['RiskCategory'] ??
                                                  'Low'),
                                          backgroundColor:
                                              customer['RiskCategory'] == 'High'
                                                  ? Colors.red.shade100
                                                  : Colors.green.shade100,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteConfirmation(
                                      customer['CustomerID']),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
