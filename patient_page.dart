  // Load patients from the database.
  void loadPatients() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('patients');
    setState(() {
      patients = data;
    });
  }
