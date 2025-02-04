import 'package:flutter/material.dart';
import 'database_helper.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  List<Map<String, dynamic>> doctors = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _specialtyController = TextEditingController();
  int? _selectedDoctorId; // ID of the doctor being edited

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  // Load doctors from the database
  void loadDoctors() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('doctors');
    setState(() {
      doctors = data;
    });
  }

  // Add a new doctor
  void addDoctor() async {
    String name = _nameController.text;
    String specialty = _specialtyController.text;
    if (name.isNotEmpty && specialty.isNotEmpty) {
      await DatabaseHelper.insertDoctor({
        'name': name,
        'specialty': specialty,
      });
      _clearForm();
      loadDoctors();
      _showSuccessSnackBar('Doctor added successfully');
    }
  }

  // Update the selected doctor
  void updateDoctor() async {
    if (_selectedDoctorId != null) {
      String name = _nameController.text;
      String specialty = _specialtyController.text;
      if (name.isNotEmpty && specialty.isNotEmpty) {
        await DatabaseHelper.updateDoctor(_selectedDoctorId!, {
          'name': name,
          'specialty': specialty,
        });
        _clearForm();
        loadDoctors();
        _showSuccessSnackBar('Doctor updated successfully');
      }
    } else {
      _showErrorSnackBar('No doctor selected for update');
    }
  }

  // Delete a doctor
  void deleteDoctor(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this doctor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.deleteDoctor(id);
      if (_selectedDoctorId == id) {
        _clearForm();
      }
      loadDoctors();
      _showSuccessSnackBar('Doctor deleted');
    }
  }

  // Clear the form fields
  void _clearForm() {
    setState(() {
      _nameController.clear();
      _specialtyController.clear();
      _selectedDoctorId = null;
    });
  }

  // Show a SnackBar with a success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Show a SnackBar with an error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Management'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doctor Registration',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                      SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _specialtyController,
                        decoration: InputDecoration(
                          labelText: 'Specialty',
                          prefixIcon: Icon(Icons.medical_services, color: Colors.teal),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: addDoctor,
                              icon: Icon(Icons.add),
                              label: Text('Add'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: updateDoctor,
                              icon: Icon(Icons.update),
                              label: Text('Update'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Doctors List',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal)),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.teal.shade100),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Specialty')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: doctors.map((doctor) {
                    return DataRow(cells: [
                      DataCell(Text(doctor['id'].toString())),
                      DataCell(Text(doctor['name'])),
                      DataCell(Text(doctor['specialty'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _nameController.text = doctor['name'];
                                _specialtyController.text = doctor['specialty'];
                                _selectedDoctorId = doctor['id'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteDoctor(doctor['id']),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
