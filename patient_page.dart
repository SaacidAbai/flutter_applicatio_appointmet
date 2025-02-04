
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
