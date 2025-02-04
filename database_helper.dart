import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Getter to obtain the database; it will be created automatically if it doesn't exist.
  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'doctor_app.db'),
      version: 1, // Increase this number if you update the schema.
      onCreate: (db, version) async {
        // Create the 'admin' table.
        await db.execute(
            "CREATE TABLE admin(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT);"
        );
        // Insert an initial admin record.
        await db.insert(
          'admin',
          {'username': 'admin', 'password': 'admin123'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Create the patients table.
        await db.execute(
            "CREATE TABLE patients(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER);"
        );

        // Create the doctors table.
        await db.execute(
            "CREATE TABLE doctors(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, specialty TEXT);"
        );

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

  // New method to get an admin from the admin table (for admin-specific login).
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

  static Future<int> deletePatient(int id) async {
    final db = await database;
    return await db.delete('patients', where: 'id = ?', whereArgs: [id]);
  }

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

  // ****************************
  // Functions to get the row counts in tables.
  // ****************************

  static Future<int> getPatientCount() async {
    final db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) as count FROM patients");
    return Sqflite.firstIntValue(res) ?? 0;
  }

  static Future<int> getDoctorCount() async {
    final db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) as count FROM doctors");
    return Sqflite.firstIntValue(res) ?? 0;
  }

  static Future<int> getAppointmentCount() async {
    final db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) as count FROM appointments");
    return Sqflite.firstIntValue(res) ?? 0;
  }

  static Future<int> getUserCount() async {
    final db = await database;
    var res = await db.rawQuery("SELECT COUNT(*) as count FROM users");
    return Sqflite.firstIntValue(res) ?? 0;
  }
}
