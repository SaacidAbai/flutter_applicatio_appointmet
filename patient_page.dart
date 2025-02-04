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
