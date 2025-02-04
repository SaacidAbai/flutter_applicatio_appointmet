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
