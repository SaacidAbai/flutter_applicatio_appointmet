

  void loadDoctors() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('doctors');
    setState(() {
      doctors = data;
      // إذا لم يتم تحديد طبيب مسبقاً يتم اختيار الأول افتراضيًا
      if (data.isNotEmpty && selectedDoctorId == null) {
        selectedDoctorId = data.first['id'] as int;
      }
    });
  }

  void addAppointment() async {
    String date = _dateController.text;
    if (selectedPatientId != null &&
        selectedDoctorId != null &&
        date.isNotEmpty) {
      await DatabaseHelper.insertAppointment({
        'patientId': selectedPatientId,
        'doctorId': selectedDoctorId,
        'date': date,
      });
      _dateController.clear();
      loadAppointments();
    }
  }
