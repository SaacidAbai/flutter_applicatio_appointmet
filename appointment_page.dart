
  void updateAppointment(int id) async {
    String date = _dateController.text;
    if (selectedPatientId != null &&
        selectedDoctorId != null &&
        date.isNotEmpty) {
      await DatabaseHelper.updateAppointment(id, {
        'patientId': selectedPatientId,
        'doctorId': selectedDoctorId,
        'date': date,
      });
      _dateController.clear();
      setState(() {
        selectedAppointmentId = null; // إعادة تعيين المتغير بعد التحديث
      });
      loadAppointments();
    }
  }

  void deleteAppointment(int id) async {
    await DatabaseHelper.deleteAppointment(id);
    loadAppointments();
  }

  // دوال مساعدة لاسترجاع اسم المريض والطبيب من الـ id
  String getPatientName(int patientId) {
    var patient = patients.firstWhere(
          (element) => element['id'] == patientId,
      orElse: () => {},
    );
    return patient.isNotEmpty ? patient['name'] : '';
  }

  String getDoctorName(int doctorId) {
    var doctor = doctors.firstWhere(
          (element) => element['id'] == doctorId,
      orElse: () => {},
    );
    return doctor.isNotEmpty ? doctor['name'] : '';
  }
