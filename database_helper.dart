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
