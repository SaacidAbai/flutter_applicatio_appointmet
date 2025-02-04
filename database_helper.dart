 static Future<Map<String, dynamic>?> getAdmin(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'admin',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  // CRUD functions for the patients table.
  static Future<int> insertPatient(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('patients', row);
  }

  static Future<int> updatePatient(int id, Map<String, dynamic> row) async {
    final db = await database;
    // Ensure the primary key is not included in the update map.
    row.remove('id');
    return await db.update('patients', row, where: 'id = ?', whereArgs: [id]);
  }
