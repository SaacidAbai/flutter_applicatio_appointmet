
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
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.deletePatient(id);
      // If the deleted record is the one selected for editing, clear the form.
      if (_selectedPatientId == id) {
        _clearForm();
      }
      loadPatients();
      _showSuccessSnackBar('Patient deleted');
    }
  }
