import 'package:flutter/material.dart';
import 'database_helper.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> users = [];
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'user'; // Default value for role
  int? _selectedUserId; // To store the ID of the selected user for update

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

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

  // Update an existing user record in the database
  void updateUser() async {
    if (_selectedUserId != null) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      if (username.isNotEmpty && password.isNotEmpty) {
        Map<String, dynamic> updatedUser = {
          'username': username,
          'email': '', // Optional: adjust if needed.
          'password': password,
          'role': _selectedRole,
        };
        await DatabaseHelper.updateUser(_selectedUserId!, updatedUser);
        _usernameController.clear();
        _passwordController.clear();
        setState(() {
          _selectedUserId = null; // Reset the selected user after update.
          _selectedRole = 'user';
        });
        loadUsers();
      } else {
        print("Username or Password is empty");
      }
    } else {
      print("No user selected for update");
    }
  }

  // Delete a user record from the database
  void deleteUser(int id) async {
    await DatabaseHelper.deleteUser(id);
    // If the deleted record was the selected one, reset _selectedUserId.
    if (_selectedUserId == id) {
      _selectedUserId = null;
      _usernameController.clear();
      _passwordController.clear();
      _selectedRole = 'user';
    }
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card widget for the registration form
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Registration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.verified_user, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(
                          'Role:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedRole,
                          items: <String>['user', 'admin']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: addUser,
                          icon: Icon(Icons.add_circle_outline),
                          label: Text('Add'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: updateUser,
                          icon: Icon(Icons.update_outlined),
                          label: Text('Update'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Users list header
            Text(
              'Users List',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 10),
            // Card wrapping the DataTable for better appearance
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.teal.shade100),
                  columns: const [
                    DataColumn(
                        label: Text('ID',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Username',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Role',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['id'].toString())),
                      DataCell(Text(user['username'])),
                      DataCell(Text(user['role'])),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueAccent),
                            tooltip: "Edit User",
                            onPressed: () {
                              setState(() {
                                // Set the selected user id and populate the form fields.
                                _selectedUserId = user['id'];
                                _usernameController.text = user['username'];
                                _passwordController.text = user['password'] ?? '';
                                _selectedRole = user['role'] ?? 'user';
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever,
                                color: Colors.redAccent),
                            tooltip: "Delete User",
                            onPressed: () => deleteUser(user['id']),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
