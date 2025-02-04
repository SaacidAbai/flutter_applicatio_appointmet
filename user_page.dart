  SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: addUser,
                          icon: Icon(Icons.add_circle_outline),
                          label: Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
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
                            backgroundColor: Colors.orangeAccent,
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
