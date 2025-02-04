
  // CRUD functions for the doctors table.
  static Future<int> insertDoctor(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('doctors', row);
  }

  static Future<int> updateDoctor(int id, Map<String, dynamic> row) async {
    final db = await database;
    row.remove('id');
    return await db.update('doctors', row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteDoctor(int id) async {
    final db = await database;
    return await db.delete('doctors', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD functions for the appointments table.
  static Future<int> insertAppointment(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('appointments', row);
  }

  static Future<int> updateAppointment(int id, Map<String, dynamic> row) async {
    final db = await database;
    row.remove('id');
    return await db.update('appointments', row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAppointment(int id) async {
    final db = await database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD functions for the users table.
  static Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await database;
    row.remove('id');
    return await db.insert('users', row);
  }

  static Future<int> updateUser(int id, Map<String, dynamic> row) async {
    final db = await database;
    row.remove('id');
    return await db.update('users', row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD functions for the products table (if needed).
  static Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('products', row);
  }

  static Future<int> updateProductPrice(int id, double newPrice) async {
    final db = await database;
    return await db.update('products', {'price': newPrice}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
