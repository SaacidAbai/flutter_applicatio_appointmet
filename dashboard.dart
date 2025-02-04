import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'patient_page.dart';
import 'doctor_page.dart';
import 'appointment_page.dart';
import 'user_page.dart';
import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String role;
  Dashboard({required this.username, required this.role});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(username: widget.username, role: widget.role),
      PatientPage(),
      DoctorPage(),
      AppointmentPage(),
    ];

