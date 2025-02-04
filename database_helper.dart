
        // Create the appointments table with foreign keys.
        await db.execute(
            "CREATE TABLE appointments(id INTEGER PRIMARY KEY AUTOINCREMENT, patientId INTEGER, doctorId INTEGER, date TEXT, "
                "FOREIGN KEY(patientId) REFERENCES patients(id), FOREIGN KEY(doctorId) REFERENCES doctors(id));"
        );

        // Create the users table with columns for role and password.
        await db.execute(
            "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT, role TEXT);"
        );

        // Insert an initial user record (for example: an admin user).
        await db.insert(
          'users',
          {
            'username': 'admin',
            'email': 'admin@example.com',
            'password': 'admin123',
            'role': 'admin'
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // (Optional) Create the products table.
        await db.execute(
            "CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price DOUBLE);"
        );
      },
    );
  }

  // Method to get a user (for example, during login).
  static Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }
