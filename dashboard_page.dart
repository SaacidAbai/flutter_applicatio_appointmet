import 'package:flutter/material.dart';
import 'database_helper.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  final String role;

  DashboardPage({required this.username, required this.role});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int patientCount = 0;
  int doctorCount = 0;
  int appointmentCount = 0;
  int userCount = 0;

  final List<String> bannerImages = [
    "img/1.jpg",
    "img/2.jpg",
    "img/3.jpg",
  ];

  int currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    int pCount = await DatabaseHelper.getPatientCount();
    int dCount = await DatabaseHelper.getDoctorCount();
    int aCount = await DatabaseHelper.getAppointmentCount();
    int uCount = await DatabaseHelper.getUserCount();

    setState(() {
      patientCount = pCount;
      doctorCount = dCount;
      appointmentCount = aCount;
      userCount = uCount;
    });
  }
