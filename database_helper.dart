
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
