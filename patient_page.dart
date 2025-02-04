import 'package:flutter/material.dart';
import 'database_helper.dart';

class PatientPage extends StatefulWidget {
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  List<Map<String, dynamic>> patients = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  int? _selectedPatientId;

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  // Load patients from the database.
  void loadPatients() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('patients');
    setState(() {
      patients = data;
    });
  }

  // Add a new patient record to the database.
  void addPatient() async {
    String name = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;
    if (name.isNotEmpty && age > 0) {
      await DatabaseHelper.insertPatient({
        'name': name,
        'age': age,
      });
      _clearForm();
      loadPatients();
      _showSuccessSnackBar('Patient added successfully');
    }
  }

  // Update an existing patient record in the database.
  void updatePatient() async {
    if (_selectedPatientId == null) return;

    String name = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;
    if (name.isNotEmpty && age > 0) {
      await DatabaseHelper.updatePatient(_selectedPatientId!, {
        'name': name,
        'age': age,
      });
      _clearForm();
      loadPatients();
      _showSuccessSnackBar('Patient updated successfully');
    }
  }

  // Delete a patient record from the database.
  void deletePatient(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this patient?'),
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
      await DatabaseHelper.deletePatient(id);
      // إذا كان السجل المحذوف هو السجل المحدد للتعديل، نقوم بمسح بيانات النموذج.
      if (_selectedPatientId == id) {
        _clearForm();
      }
      loadPatients();
      _showSuccessSnackBar('Patient deleted');
    }
  }

  // Clear the form fields and reset the selected patient id.
  void _clearForm() {
    setState(() {
      _nameController.clear();
      _ageController.clear();
      _selectedPatientId = null;
    });
  }

  // Show a SnackBar with a success message.
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card for the patient registration form.
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Patient Registration',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.clear, size: 18),
                          label: Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[600],
                          ),
                          onPressed: _clearForm,
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(
                            _selectedPatientId == null ? Icons.add_circle : Icons.update,
                            size: 18,
                          ),
                          label: Text(_selectedPatientId == null ? 'Add New' : 'Update'),
                          style: ElevatedButton.styleFrom(
                            primary: _selectedPatientId == null ? Colors.blue : Colors.orange,
                          ),
                          onPressed: _selectedPatientId == null ? addPatient : updatePatient,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Patients List',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 15),
            // Card wrapping the DataTable for better appearance.
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade50!,
                    ),
                    columns: [
                      DataColumn(
                        label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('NAME', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('AGE', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: patients.map((patient) {
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (patient['id'] == _selectedPatientId) {
                              return Colors.blue.shade100!;
                            }
                            return patients.indexOf(patient) % 2 == 0
                                ? Colors.grey.shade50
                                : Colors.white;
                          },
                        ),
                        cells: [
                          DataCell(Text('#${patient['id']}')),
                          DataCell(Text(patient['name'])),
                          DataCell(Text(patient['age'].toString())),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                                onPressed: () {
                                  setState(() {
                                    _nameController.text = patient['name'];
                                    _ageController.text = patient['age'].toString();
                                    _selectedPatientId = patient['id'];
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete',
                                onPressed: () => deletePatient(patient['id']),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
