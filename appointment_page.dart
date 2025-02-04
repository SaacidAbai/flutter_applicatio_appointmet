import 'package:flutter/material.dart';
import 'database_helper.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> patients = [];
  List<Map<String, dynamic>> doctors = [];

  int? selectedPatientId;
  int? selectedDoctorId;
  int? selectedAppointmentId; // معرف الموعد المختار للتحديث

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAppointments();
    loadPatients();
    loadDoctors();
  }

  void loadAppointments() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('appointments');
    setState(() {
      appointments = data;
    });
  }

  void loadPatients() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('patients');
    setState(() {
      patients = data;
      // إذا لم يتم تحديد مريض مسبقاً يتم اختيار الأول افتراضيًا
      if (data.isNotEmpty && selectedPatientId == null) {
        selectedPatientId = data.first['id'] as int;
      }
    });
  }

