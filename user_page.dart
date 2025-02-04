  // Load users from the database
  void loadUsers() async {
    final db = await DatabaseHelper.database;
    final data = await db.query('users');
    setState(() {
      users = data;
    });
  }

  // Add a new user record to the database
  void addUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      Map<String, dynamic> newUser = {
        'username': username,
        'email': '', // Optional: adjust if needed.
        'password': password,
        'role': _selectedRole,
      };
      await DatabaseHelper.insertUser(newUser);
      _usernameController.clear();
      _passwordController.clear();
      setState(() {
        _selectedRole = 'user';
        _selectedUserId = null; // Reset the selected user.
      });
      loadUsers();
    } else {
      print("Username or Password is empty");
    }
  }

