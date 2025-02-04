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

    _navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Patients'),
      BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Doctors'),
      BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
    ];

    if (widget.role.toLowerCase() != "user") {
      _pages.add(UserPage());
      _navItems.add(
        BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: 'Users'),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard (${widget.role})'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: _navItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 10,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            selectedFontSize: 14,
            unselectedFontSize: 12,
          ),
        ),
      ),
    );
  }
}
