
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
